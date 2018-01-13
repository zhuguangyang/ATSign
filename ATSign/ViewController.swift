//
//  ViewController.swift
//  ATSign
//
//  Created by macpro on 2017/12/4.
//  Copyright © 2017年 macpro. All rights reserved.
//

import Cocoa
import SwiftyJSON


class ViewController: NSViewController {

    @IBOutlet weak var textView: NSScrollView!
    
    @IBOutlet var attextView: NSTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GYNetWorking.default.requestData(GYRouter.tokenLogin(parameters: [:]), sucess: { (data) in
            print(data)
            DispatchQueue.main.async {
                let image = NSImage(data: data)

                let imageView = NSImageView(frame: NSRect(x: 0, y: 0, width: 200, height: 200));
                imageView.image = image
                self.view.addSubview(imageView)

            }
            
            }) { (error) in
 
            }
            
        }

    func tokenLogin() {
        
        GYNetWorking.default.requestJson(GYRouter.tokenLogin(parameters: ["deviceInfo":["platform": "ios", "version":"10.3.3", "manufactor":"apple"]]), sucess: { (data) in
            let dataObj = data["data"] as? [String:AnyObject]
            if dataObj != nil {
                signUrl = dataObj?["cpServer"] as? String ?? signUrl
            } else {
                sleep(1)
                self.tokenLogin()
                
            }
            
        }) { (error) in
            sleep(1)
            self.tokenLogin()
        }
        
    }
    
   func ShowInfo() {
        
    GYNetWorking.default.requestJson(GYRouter.ShowInfo(parameters: [:]), sucess: { (result) in

            let data = result["data"] as? [String:AnyObject]//
            self.showModel.coWorkOff = data?["coWorkOff"] as? String ?? ""
            self.showModel.currentDate = data?["currentDate"] as? String ?? ""
            self.showModel.currentDateDesc = data?["currentDateDesc"]as? String ?? ""
            self.showModel.currentTime = data?["currentTime"] as? String ?? ""
            self.showModel.timeWorkOn = data?["timeWorkOn"] as? String ?? ""
            self.showModel.timeWorkOff = data?["timeWorkOff"] as? String ?? ""
            self.showModel.welcome = data?["welcome"] as? String ?? ""
            self.showModel.workingTimeDesc = data?["workingTimeDesc"] as? String ?? ""

            var sArray = [schedulesModel]()
            let schedules = data?["schedules"] as? [[String:String]]
                if let array = schedules {
                    for item in array {
                        var sModel = schedulesModel()
                        sModel.attCoSol = item["attCoSol"]!
                        sModel.enableOffEndTime = item["enableOffEndTime"] ?? ""
                        sModel.enableOnEndTime = item["enableOnEndTime"] ?? ""
                        sModel.enableOffStartTime = item["enableOffStartTime"] ?? ""
                        sModel.enableOnStartTime = item["enableOnStartTime"] ?? ""
                        sModel.scheduleId = item["scheduleId"] ?? ""
                        sModel.scheduleName = item["scheduleName"] ?? ""
                        sModel.workOnTime = item["workOnTime"] ?? ""
                        sArray.append(sModel)
                    }
                }
            self.showModel.schedules = sArray
            self.logging("走到界面成功")
            self.params()
        }) { (error) in
            Print(error)
            self.logging("走到界面失败")
            self.ShowInfo()
        }
        
    }
    
    func signIn() {
        
        GYNetWorking.default.requestJson(GYRouter.SignIn(parameters: signoutParams), sucess: { (data) in
            
            self.logging(data.description)
            self.logging("OK")
        }) { (error) in
            Print(error)
            self.logging(error.localizedDescription)
            self.logging("faliure")
            self.signIn()
        }
        
    }
    
    func signOut() {
        
        GYNetWorking.default.requestJson(GYRouter.SignOut(parameters: signoutParams), sucess: { (data) in
            self.logging(data.description)
        }) { (error) in
            Print(error)
            self.logging(error.localizedDescription)
        }

    }
    
    fileprivate func load() -> String {
        
        let formatter = DateFormatter()
        formatter.amSymbol = "上午"
        formatter.pmSymbol = "下午"
        formatter.dateFormat = "aaa";
        return formatter.string(from: Date())
    }
    
    private func compareTime() -> Bool{
        
        let formatter = DateFormatter()
        formatter.amSymbol = "上午"
        formatter.pmSymbol = "下午"
        formatter.dateFormat = "HH";

        return Int(formatter.string(from: Date()))! <= 9  || Int(formatter.string(from: Date()))! >= 18
    }
    
    fileprivate func params() {
        guard let schedule = showModel.schedules.last else {
            self.logging("拿不到实例")
            return
        }
        
        let sp: [String: String] = ["attCoSol": schedule.attCoSol, "enableOffEndTime": schedule.enableOffEndTime , "enableOffStartTime": schedule.enableOffStartTime, "enableOnEndTime": schedule.enableOnEndTime , "enableOnStartTime": schedule.enableOnStartTime , "scheduleId": schedule.scheduleId, "scheduleName": schedule.scheduleName , "workOnTime": schedule.workOnTime]
        let index = Int(arc4random()%5)
        let model = cordinations[index]
        let lp: [String: String] = ["latitude": model.latitude, "longitude": model.longitude, "success": "1","speed":"-1","accuracy":"65"]
        
        var fp: [String: String] = ["onOrOff": "off", "attCoSol": "gps"]
        switch load() {
        case "上午": // 签到
            fp = ["onOrOff": "on", "attCoSol": "gps"]
        case "下午": //签退
            fp = ["onOrOff": "off", "attCoSol": "gps"]
        default:
            break
        }
        
        var ss: [String: Any] =  ["scheduleInfo": sp, "gspInfoVO": lp]

        for item in fp{
            ss[item.key] = item.value
        }
        
        signoutParams = ["checkout": dicToJsonString(ss)!]
//        signoutParams = ss
        
        self.signIn()
    }
    
    fileprivate func logging(_ str:String) {
        DispatchQueue.main.async {
            self.attextView.string = self.attextView.string + str + "\n"
        }
    }
    
    lazy var showModel: ShowModel = {
        return ShowModel()
    }()
    
    lazy var cordinations: [LocationModel] = { // 坐标管理
        let param = [("31.24179053588886", "121.60099938523173"), ("31.2423446635075", "121.601311694944"),("31.2421205421344", "121.601074708977"),("31.2420892233947", "121.601053864909"),("31.2423787778534", "121.601203233117")]
        var array = [LocationModel]()
        for item in param {
            var model = LocationModel()
            model.latitude = item.0 as String
            model.longitude = item.1 as String
            array.append(model)
        }
        
        return array
    }()
    
    lazy var signoutParams: [String: Any] = {
        return [String: Any]()
    }()

    func dicToJsonString(_ dic: [String: Any]) -> String?{
        let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        guard let haveData = data else{
            return nil
        }
        var strJson = String(data: haveData, encoding: String.Encoding.utf8)
        
        strJson = strJson?.replacingOccurrences(of: "\n", with: "")
        //strJson = strJson?.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        return strJson
    }

    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

