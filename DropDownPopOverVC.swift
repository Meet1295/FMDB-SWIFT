//
//  DropDownPopOverVC.swift
//  MyApp
//
//  Created by Admin on 9/25/18.
//  Copyright © 2018 Olynk Inc. All rights reserved.
//

import UIKit
import FMDB
import FirebaseDatabase

protocol ClassScanVCDelegate: class {
    func selectedData(selectedVal : String)
}

let pickerCellId = "pickerCell"

class DropDownPopOverVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblview: UITableView!
    weak var delegate: ClassScanVCDelegate?
    weak var appDelegate:AppDelegate? = nil
    
    var pickerData = [String]()
    let todayDate = Date()
    var timeInterval = TimeInterval()
    var timer = Timer()
    
    var dbRefer = DatabaseReference()
    var dbHandle = DatabaseHandle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeInterval = todayDate.timeIntervalSince1970
        print(Int64(timeInterval))
        dbRefer = Database.database().reference().child("V3")
        tblview.reloadData()
      //  stratGettingDataTimer()
        deleteLogData()
    }
    
    //PRAGMA MARK:- Table view Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: pickerCellId, for: indexPath)
        let lblTitle = cell.viewWithTag(1) as? UILabel
        lblTitle?.text = pickerData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selectedData(selectedVal: pickerData[indexPath.row])
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }


    func stratGettingDataTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 60.0 , target: self, selector: #selector(self.fetchRecordFromDatabase), userInfo: nil, repeats: true)
    }
    
//    @objc func stopGettingDataTimer(){
//        timer.invalidate()
//    }
//
    
   @objc func fetchRecordFromDatabase() {
//        let arrAllData = fmdbClass.getAllData(tableName: ktblName)
//
//        for data in arrAllData {
//            print(data)
//            let selectedVal = dbRefer.root.child("Log").key
//            let addedData = [kId:"1" , kEmailId:data.emailId , kRSSI : data.rssi , kTimestamp : data.timestamp , kLatitude: "23.78496" , kLongitude : data.longitude , kBettryLevel : data.betteryLevel]
//            dbRefer.child(selectedVal).child("1").childByAutoId().setValue(addedData)
//        }
   }
    
//PRAGMA MARK:- DELETE QUERY
    func deleteLogData() {

//        let arr = [2,3]
//
//        fmdbClass.deleteRecord(tableName: ktblName,id: arr)
     
//        let arr1 = fmdbClass.getAllData(tableName: ktblName)
//        print(arr1)
//
//        let arr2 = fmdbClass.getData(tableName: ktblName, id: arr)
//        print(arr2)
        
        
        var dictInsertData = [String : AnyObject]()
        dictInsertData[ktargetId] = "dsgfhjgsdfjgghsdfjhgdfshj" as AnyObject
        dictInsertData[kRSSI] = "-10"  as AnyObject
        dictInsertData[kTimestamp] =  String(Int64(timeInterval))  as AnyObject
        dictInsertData[kLatitude] = "23.5677" as AnyObject //appDelegate?.latitude  as AnyObject
        dictInsertData[kLongitude] = "73.8477" as AnyObject //appDelegate?.longitude  as AnyObject
        dictInsertData[kBatteryStatus] = "46%"  as AnyObject

        fmdbClass.insertLogsData(values : dictInsertData)

   }
}
