//
//  ServiceApi.swift
//  GYHelpToolsSwift
//
//  Created by ZGY on 2017/4/14.
//  Copyright © 2017年 Giant. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/4/14  17:20
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import Cocoa
/// APIDemo
class GYServiceApi: NSObject {
    
    #if DEBUG
//    static var host: String = "http://192.168.173.22:2017"
    static var host: String = "http://www.winployee.com/cw-ms/user/server/update.json"
    #else
    static var host: String = "http://www.winployee.com/cw-ms/user/server/update.json"
    #endif
    
    ///
    
    ///
    /// - Returns: return value description
    internal class func tokenLogin() -> String {
    
        return "\(host)"
    }
    
    ///
    /// - Returns: return value description
    internal class func ShowInfo() -> String {
        
        return "\(signUrl)/api/att/coGetInfo.json"
    }
    
    /// - Returns: return value description
    internal class func SignIn() -> String {
        
        return "\(signUrl)/api/att/clock.json?accessToken=\(accessToken)"
    }
    
    /// - Returns: return value description
    internal class func SignOut() -> String {
        
        return "\(signUrl)/api/att/clock.json"
    }
    
    
    
    /// 获取验证码
    ///
    /// - Returns: return value description
    internal class func getPhoneCode() -> String {
        
        return "\(host)/App/AppLogin/GetPhoneCode"
    }
    
    /// 登录
    ///
    /// - Returns: return value description
    internal class func login() -> String {
        return "\(host)/App/AppLogin/APPLogin"
    }
    
    
    /// 注册
    ///
    /// - Returns: return value description
    internal class func register() -> String {
        return "\(host)/APP/AppLogin/APPLogin"
    }
    
    
    /// 核算贷款额度 此处可添加用户个人申请额度
    ///
    /// - Returns: return value description
    internal class func submitUserInfoDetaile() -> String {
        return "\(host)/App/AppLogin/SubmitUserInfoDetaile"
    }
    
    
    /// 提交申请单
    ///
    /// - Returns: return value description
    internal class func SubmitApplication() -> String {
        return "\(host)/App/Apply/SubmitApply"
    }
    
    
    
    /// 获取用户信息
    ///
    /// - Returns: return value description
    internal class func GetUserInfo() -> String {
        
        return "\(host)/App/User/GetUserInfo"
    }
    
    /// 获取用户申请贷款进度
    ///
    /// - Returns: return value description
    internal class func GetUserApplyState() -> String {
        
        return "\(host)/App/User/GetUserApplyState"
    }
    
    //GetPost/App/User/GetUserApplyStateByID
    
    /// 获取用户申请贷款进度
    ///
    /// - Returns: return value description
    internal class func GetUserApplyStateByID() -> String {
        
        return "\(host)/App/User/GetUserApplyStateByID"
    }
    
    /// 合同
    ///
    /// - Returns: return value description
    internal class func CompactInfo() -> String {
        
        return "\(host)/App/User/AppCompactInfo"
    }
    //GetPost/App/User/GetMyInviter
    
    /// 我的邀请人
    ///
    /// - Returns: return value description
    internal class func GetMyInviter() -> String {
        
        return "\(host)/App/User/GetMyInviter"
    }
    //GetPost/App/User/GetInviterInfo
    
    /// 我的邀请人
    ///
    /// - Returns: return value description
    internal class func GetInviterInfo() -> String {
        
        return "\(host)/App/User/GetInviterInfo"
    }
    
    /// 我的申请历史
    ///
    /// - Returns: return value description
    internal class func GetUserApplyHistory() -> String {
        
        return "\(host)/App/Apply/GetUserApplyHistory"
    }
    
    /// 是否可申请
    ///GetPost/App/Apply/IsCanApply
    /// - Returns: return value description
    internal class func IsCanApply() -> String {
        
        return "\(host)/App/Apply/IsCanApply"
    }

    
}
