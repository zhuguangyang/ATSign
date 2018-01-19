//
//  GYNetWorking.swift
//  GYHelpToolsSwift
//
//  Created by ZGY on 2017/4/12.
//  Copyright © 2017年 Giant. All rights reserved.
//
//  Author:        Airfight
//  My GitHub:     https://github.com/airfight
//  My Blog:       http://airfight.github.io/
//  My Jane book:  http://www.jianshu.com/users/17d6a01e3361
//  Current Time:  2017/4/12  16:53
//  GiantForJade:  Efforts to do my best
//  Real developers ship.

import Alamofire
import SwiftyJSON
import PromiseKit

public func Print<T>(_ message: T,file: String = #file,method: String = #function, line: Int = #line)
{
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}

let serverTrustPolicies: [String: ServerTrustPolicy] = ["kyfw.12306.cn": ServerTrustPolicy.performDefaultEvaluation(validateHost: true)]

// Create custom manager
let headers = [
    "refer": "https://kyfw.12306.cn/otn/leftTicket/init",
    "Host": "kyfw.12306.cn",
    "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:36.0) Gecko/20100101 Firefox/36.0",
    "Connection" : "keep-alive"]



var  AlamofireManager:Alamofire.SessionManager = {
    // Create the server trust policies
    let serverTrustPolicies: [String: ServerTrustPolicy] = ["kyfw.12306.cn": ServerTrustPolicy.performDefaultEvaluation(validateHost: true)]
    
    // Create custom manager
    let headers = [
        "refer": "https://kyfw.12306.cn/otn/leftTicket/init",
        "Host": "kyfw.12306.cn",
        "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:36.0) Gecko/20100101 Firefox/36.0",
        "Connection" : "keep-alive"]
    let configuration = URLSessionConfiguration.default
    
    configuration.httpCookieAcceptPolicy = .always
    configuration.httpAdditionalHeaders = headers
    configuration.timeoutIntervalForRequest = 10
    
    let manager = Alamofire.SessionManager(
        configuration: configuration,
        serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
    )
    return manager
}()

enum GYNetWorkStatus {
    
    /// 未知网络
    case UnKnown
    
    /// 无网络
    case NotReachable
    
    /// 手机网络
    case ReachableViaWWAN
    
    /// WIFI
    case ReachableViaWiFi
}

enum GYRequestSerializer {
    
    /// Json格式
    case Json
    
    /// 二进制格式
    case Http
}

typealias GYHttpRequestSuccess = (AnyObject) -> Void
typealias GYHttpRequestSuccessData = (Data) -> Void

typealias GYHttpRequestFailed = (Error) -> Void

typealias GYAlamofireResponse = (DataResponse<Any>) -> Void

typealias GYNetWorkState = (GYNetWorkStatus) -> Void

class GYNetWorking{
    
    static let `default`: GYNetWorking = GYNetWorking()
    
    /// 网络监听
    let manager = NetworkReachabilityManager(host: "www.baidu.com")
    var alldataRequestTask:NSMutableDictionary = NSMutableDictionary()
    
    /// 是否只接受第一次请求  默认只接受第一次请求
    var isRequest: Bool = true
    
}


// MARK: - 获取当前网络状态
extension GYNetWorking {
    
   
     func netWorkStatusWithBlock(_ block: @escaping GYNetWorkState) {
    
        manager?.startListening()

        manager?.listener = { status in

            switch status {
            case .unknown:
                block(.UnKnown)
            case .notReachable:
                DispatchQueue.main.async {

                }
                block(.NotReachable)
            case .reachable(.ethernetOrWiFi):
                block(.ReachableViaWiFi)
            case .reachable(.wwan):
                block(.ReachableViaWWAN)
            }
        }
        
    }
    
    fileprivate func isReachable() -> Bool{
        return (manager?.isReachable)!
    }
    
    fileprivate func isWWANetwork() -> Bool {
        return (manager?.isReachableOnWWAN)!
    }
    
    fileprivate func isWiFiNetwork() -> Bool {
        return (manager?.isReachableOnEthernetOrWiFi)!
    }
}

extension GYNetWorking {
    
    func preLoginFlow(success:@escaping (NSImage)->Void,failure:@escaping (NSError)->Void){
        loginInit().then{dynamicJs -> Promise<Void> in
            return self.requestDynamicJs(dynamicJs, referHeader: ["refer": "https://kyfw.12306.cn/otn/login/init"])
            }.then{_ -> Promise<NSImage> in
                return self.getPassCodeNewForLogin()
            }.then{ image in
                success(image)
            }.catch { error in
                failure(error as NSError)
        }
    }
    
//    func loginInit()->Promise<String>{
//        return Promise{ fulfill, reject in
//            let url = "https://kyfw.12306.cn/otn/login/init"
//            let headers = ["refer": "https://kyfw.12306.cn/otn/leftTicket/init"]
//            AlamofireManager.request(url, headers:headers).responseString(completionHandler:{response in
//                switch (response.result){
//                case .failure(let error):
//                    reject(error)
//                case .success(let content):
//                    var dynamicJs = ""
//                    if let matches = Regex("src=\"/otn/dynamicJs/([^\"]+)\"").getMatches(content){
//                        dynamicJs = matches[0][0]
//                    }
//                    else{
//                       print("fail to get dynamicJs:\(content)")
//                    }
//                    
//                    self.getConfigFromInitContent(content)
//                    
//                    fulfill(dynamicJs)
//                }})
//        }
//    }
    
}


// MARK: - 网络请求
extension GYNetWorking {
    
    
  func requestData(_ urlRequest: URLRequestConvertible, sucess:@escaping GYHttpRequestSuccessData,failure: @escaping GYHttpRequestFailed) {
    
    let responseJSON: (DataResponse<Data>) -> Void = { [weak self]  (response:DataResponse<Data>) in
        switch response.result {
        case .success(let data):
            sucess(data)
            break
        default:
            break
        }
    }
    
    let manager = AlamofireManager
    //        此处设置超时无效
    //                manager.session.configuration.timeoutIntervalForRequest = 3
    let dataRequest =  manager.request(urlRequest)
        .responseData(queue: nil, completionHandler: responseJSON)
        
    }
    /// 自动校验 返回Json格式
    ///
    /// - Parameters:
    ///   - urlRequest: urlRequest description
    ///   - sucess: sucess description
    ///   - failure: failure description
    func requestJson(_ urlRequest: URLRequestConvertible, sucess:@escaping GYHttpRequestSuccess,failure: @escaping GYHttpRequestFailed) {
  
        Print(urlRequest)
        let responseJSON: (DataResponse<Any>) -> Void = { [weak self]  (response:DataResponse<Any>) in
            if let value = urlRequest.urlRequest?.url?.absoluteString {
                //                sleep(3)
                self?.alldataRequestTask.removeObject(forKey: value)
                
            }
            
            self?.handleResponse(response, sucess: sucess, failure: failure)
            
        }
        
        
        let task = alldataRequestTask.value(forKey: (urlRequest.urlRequest?.url?.absoluteString)!) as? DataRequest
        guard isRequest && (task == nil) else {
            return
        }
        
        task?.cancel()

        let manager = AlamofireManager
        //        此处设置超时无效
//                manager.session.configuration.timeoutIntervalForRequest = 3
        let dataRequest =  manager.request(urlRequest)
                                .responseJSON(completionHandler: responseJSON)

        alldataRequestTask.setValue(dataRequest, forKey: (urlRequest.urlRequest?.url?.absoluteString)!)
    }
    
}


// MARK: - 处理请求结果
extension GYNetWorking {
    
    /// 处理请求结果 （根据项目需求修改）
    ///
    /// - Parameters:
    ///   - response: response description
    ///   - sucess: sucess description
    ///   - failure: failure description
    fileprivate func handleResponse(_ response: DataResponse<Any> ,sucess:@escaping GYHttpRequestSuccess,failure: @escaping GYHttpRequestFailed) {
        
        if let _ = response.result.value {
            
        switch response.result {
        case .success(let json):
            var result = json as! [String:AnyObject]
            Print(json)
            guard let code = result["responseCode"] as? NSInteger else {
                return
            }
            
            if code >= 0 {
                
                sucess(json as AnyObject)
                
            } else {
                
                var str =  result["msg"] as? String ?? "未知错误"
                
                if code == -10002 {
                    str = "服务器异常"
                }
                
                let errorString = str
                let userInfo = [NSLocalizedDescriptionKey:errorString]
                let error: NSError = NSError(domain: errorString, code: code, userInfo: userInfo)
                
                failure(error)
            }
            
        case .failure(let error):
            
            failure(error)
        }

        } else {
            DispatchQueue.main.async {
                
//                if response.result.debugDescription.contains("Code=-1001") {
//
//
//                } else {
//                    Print(response.value)
//                }
////                response.result
//                Print(response.result.error?.localizedDescription)
                if response.result.error != nil {
                failure(response.result.error!)
                
                }
            }
            
        }
    }
    
}

