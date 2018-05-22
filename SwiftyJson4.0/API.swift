//
//  API.swift
//  SwiftyJson4.0
//
//  Created by Hitesh.surani on 11/10/17.
//  Copyright © 2017 Brainvire. All rights reserved.
//

import UIKit


//API

let strBaseUrl = "BaseURL"
let strCountryAPI = "country-list"
let strForgotPassword = "api/people/"
let strloginAPI = "userlogin"
let strEditProfile = "edit-profile"
enum apiType:Int {
    case CountryAPI = 0
    case forgotPasswordAPI = 1
    case loginAPI = 2
    case EditProfile = 3

}

//HTTP Methods
enum HttpMethod : String {
    case  GET
    case  POST
    case  DELETE
    case  PUT
}

class API: NSObject {

    let aryAllRequest = [URLRequest]()
    
//    // URL Request
//    var request : URLRequest?
//    var session : URLSession?
    
    let configuration = URLSessionConfiguration.default
    
    var aryUrlString:[String] = [strCountryAPI,strForgotPassword,strloginAPI,strEditProfile]
    
    let reachability = Reachability()!
    var isReachable = true

    
    static let sharedInstance = API()
    
    private override init() {

    }
    
    
    func makeAPICallWithModalClass<T:Decodable>(apiTypeValue:apiType,params: Dictionary<String, Any>?, method: HttpMethod,SuccessBlock: @escaping (AnyObject) -> Void,FailureBlock: @escaping ([String:String]?)-> Void,type:T.Type?) {
        
        
        if(!isReachable){
            let dictError = ["message":"No internet connection available",
                             "status": "Failed"]
            FailureBlock(dictError)
        }
        
        
        let url = strBaseUrl + aryUrlString[apiTypeValue.rawValue]
        
        
        // URL Request
        let request = createRequestWithDictionary(url:url, params: params, method: method)
        let session = URLSession(configuration: configuration)

        
        
        //IMHKS:Set session time if needed default 60 sec
        /*
         configuration.timeoutIntervalForRequest = 30
         configuration.timeoutIntervalForResource = 30
         */

        
        session.dataTask(with: request! as URLRequest) { (data, response, error) -> Void in
            
//            self.hideLoader()
            guard let data = data else { return }
            
            do {
                let objModalClass = try JSONDecoder().decode(type!,from: data)

                DispatchQueue.main.sync {
                    SuccessBlock(objModalClass as AnyObject)
                }
            } catch{
                DispatchQueue.main.sync {

                    let dictError:[String:String] = ["message":"Error to coonecting server",
                                                     "status": "Failed"]

                    FailureBlock(dictError)
                }
            }
            }.resume()
    }
    
    
    func makeAPICall(apiTypeValue:apiType,params: Dictionary<String, Any>?, method: HttpMethod,SuccessBlock: @escaping (AnyObject) -> Void,FailureBlock: @escaping ([String:String])-> Void) {
        
        if(!isReachable){
            let dictError = ["message":"No internet connection available",
                             "status": "Failed"]
            FailureBlock(dictError)
        }
        
        let url = strBaseUrl + aryUrlString[apiTypeValue.rawValue]
        
        // URL Request
        let request = createRequestWithDictionary(url:url, params: params, method: method)
        let session = URLSession(configuration: configuration)

        print(request?.description)
        
        
        //IMHKS:Set session time if needed default 60 sec
        /*
         
         configuration.timeoutIntervalForRequest = 30
         configuration.timeoutIntervalForResource = 30
         
         */
        
        session.dataTask(with: request! as URLRequest) { (data, response, error) -> Void in
            
            guard let data = data else { return }
            
            
            if (error != nil){
                let dictError:[String:String] = ["message":(error?.localizedDescription)!,
                                 "status": "Failed"]
                FailureBlock(dictError)

            }else{
                DispatchQueue.main.sync {
                if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                {
                    SuccessBlock(jsonResponse as AnyObject)
                }else{
                    let dictError = ["message":"Error to coonecting server",
                                     "status": "Failed"]
                    FailureBlock(dictError)
                    }
                }}}.resume()
    }
    
    //MARK: Create request
    func createRequestWithDictionary(url: String,params: Dictionary<String, Any>?,method: HttpMethod) -> URLRequest? {
        
        var requestToReturn : URLRequest?
        
        
        requestToReturn = URLRequest(url: URL(string: url)!)

        //For API Parameter
        if let params = params {
            let  jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            requestToReturn?.setValue("application/json", forHTTPHeaderField: "Content-Type")
            requestToReturn?.httpBody = jsonData//?.base64EncodedData()
        }
        
        requestToReturn?.httpMethod = method.rawValue
        
        return requestToReturn
    }
    
    
    //MARK:Image Uploading
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    //Mark: Check for internet connection
    func startReachablity(){
        reachability.whenReachable = { reachability in
            print("Reachable")
            self.isReachable = true
        }
        reachability.whenUnreachable = { _ in
            self.isReachable = true
            print("Not Reachable")
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}



