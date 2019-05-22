//
//  DatabaseQueries.swift
//  MyApp
//
//  Created by Admin on 10/3/18.
//  Copyright © 2018 Olynk Inc. All rights reserved.
//

import Foundation
import FMDB

class fmdbClass: NSObject {
   
    fileprivate static var database: FMDatabase!
    fileprivate static var pathToDatabase: String!
    fileprivate static let documentsDirectory = Bundle.main.path(forResource: "MyAppDb", ofType: "sqlite")

//PRAGMA MARK:- OPEN DATABASE
    static func openDatabase() -> Bool {
        pathToDatabase = documentsDirectory!.appending("/MyAppDb.sqlite")
        print(pathToDatabase)
        
        pathToDatabase = documentsDirectory
        database = FMDatabase(path: pathToDatabase!)
        
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
    
//PRAGMA MARK:- INSERT RECORD QUERY
    static func insertLogsData(values : [String:AnyObject]) {
        if openDatabase() {
            var query = ""
    
            query += "INSERT INTO Log (\(ktargetId), \(kRSSI) , \(kTimestamp) , \(kLatitude) , \(kLongitude) , \(kBatteryStatus)) values ('\(values[ktargetId] ?? "" as AnyObject)',\(values[kRSSI] ?? "" as AnyObject),\(values[kTimestamp] ?? "" as AnyObject),\(values[kLatitude] ?? "" as AnyObject),\(values[kLongitude] ?? "" as AnyObject),'\(values[kBatteryStatus] ?? "" as AnyObject)')"
            
            do {
                try database.executeUpdate(query, values: nil)
            } catch {
                print(error.localizedDescription)
            }

            database.close()
        }
    }
    
    //PRAGMA MARK:- SELECT SINGLE RECORD QUERY
    static func getData(tableName : String , id : [Int]) -> [DBModel] {
        let dbDataArr = DBModel()
        var arrData = [DBModel]()
        
            if openDatabase() {
                for i in id {
                    let querySQL = "SELECT * FROM \(tableName) WHERE id = \(i)"
                    
                    do {
                        let results = try database.executeQuery(querySQL, values: nil)
                        while results.next() {
                            
                            if let emailid = results.string(forColumn: ktargetId) {
                                dbDataArr.targetId = emailid
                            }
                            
                            if let rssi = results.string(forColumn: kRSSI) {
                                dbDataArr.rssi = rssi
                            }
                            
                            if let timestamp = results.string(forColumn: kTimestamp) {
                                dbDataArr.timestamp = timestamp
                            }
                            
                            if let latitude = results.string(forColumn: kLatitude) {
                                dbDataArr.latitude = latitude
                            }
                            
                            if let long = results.string(forColumn: kLongitude) {
                                dbDataArr.longitude = long
                            }
                            
                            if let betryLvl = results.string(forColumn: kBatteryStatus) {
                                dbDataArr.betteryStatus = betryLvl
                            }
                            
                            arrData.append(dbDataArr)
                            print(arrData)
                        }
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
                database.close()
            }
            return arrData
        }
    
    //PRAGMA MARK:- SELECT ALL RECORD QUERY
    static func getAllData(tableName : String) -> [DBModel] {
        var arrData = [DBModel]()
        
        if openDatabase() {
            let querySQL = "SELECT * FROM \(tableName)"
            
            do {
                let results = try database.executeQuery(querySQL, values: nil)
                while results.next() {
                    let dbDataArr = DBModel()
                    
                    if let emailid = results.string(forColumn: ktargetId) {
                        dbDataArr.targetId = emailid
                    }
                    
                    if let rssi = results.string(forColumn: kRSSI) {
                        dbDataArr.rssi = rssi
                    }
                    
                    if let timestamp = results.string(forColumn: kTimestamp) {
                        dbDataArr.timestamp = timestamp
                    }
                    
                    if let latitude = results.string(forColumn: kLatitude) {
                        dbDataArr.latitude = latitude
                    }
                    
                    if let long = results.string(forColumn: kLongitude) {
                        dbDataArr.longitude = long
                    }
                    
                    if let betryLvl = results.string(forColumn: kBatteryStatus) {
                        dbDataArr.betteryStatus = betryLvl
                    }
                    
                    arrData.append(dbDataArr)
                    print(arrData)
                }
            }
            catch {
                print(error.localizedDescription)
            }
            database.close()
        }
        return arrData
    }
    
//PRAGMA MARK:- DELETE RECORD QUERY
   static func deleteRecord(tableName : String , id : [Int]) {
        if openDatabase() {
            for i in id {
                let query = "delete from \(tableName) where \(kId) = \(i)"
                
                do {
                    try database.executeUpdate(query, values: nil)
                } catch {
                    print(error.localizedDescription)
                }
            }
            database.close()
        }
    }
}
