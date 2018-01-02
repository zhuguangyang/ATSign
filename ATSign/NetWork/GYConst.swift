//
//  GYConst.swift
//  ATSign
//
//  Created by macpro on 2017/12/4.
//  Copyright © 2017年 macpro. All rights reserved.
//

import Cocoa

let AppLogin = "http://www.winployee.com/cw-ms/user/login.json" // 登陆
let TokenLogin = "http://www.winployee.com/cw-ms/user/server/update.json" // Token登陆
var signUrl = "https://cpnd-hz.winployee.com"
var ShowInfo = "\(signUrl)/api/att/coGetInfo.json" // 签到界面
var SignIn = "\(signUrl)/api/att/clockout.json" // 签到
var SignOut = "\(signUrl)/api/att/clockout.json" // 签退
let accessToken = "a3f0ecd9-0f0f-4903-a9a8-69da58c9f908"
//a3f0ecd9-0f0f-4903-a9a8-69da58c9f908

struct schedulesModel {
    var attCoSol: String = ""
    var enableOffEndTime: String = ""
    var enableOffStartTime: String = ""
    var enableOnEndTime: String = ""
    var enableOnStartTime: String = ""
    var scheduleId: String = ""
    var scheduleName: String = ""
    var workOnTime: String = ""
}

struct ShowModel {
    var coWorkOff: String = ""
    var currentDate: String = ""
    var currentDateDesc: String = ""
    var currentTime: String = ""
    var timeWorkOff: String = ""
    var timeWorkOn: String = ""
    var welcome: String = ""
    var workingTimeDesc: String = ""
    var schedules: [schedulesModel] = []
}


struct LocationModel {
    var latitude: String = "31.24179053588886"
    var longitude: String = "121.60099938523173"
}
