
//
//  File.swift
//  SwiftyJson4.0
//
//  Created by Hitesh Surani on 12/05/18.
//  Copyright © 2018 Brainvire. All rights reserved.
//

import UIKit

extension API{
    func UploadImage(fileName:String,
                     data:NSData,apiTypeValue:apiType,params: Dictionary<String, Any>?, method: HttpMethod,SuccessBlock: @escaping (AnyObject) -> Void,FailureBlock: @escaping ([String:String]?)-> Void){
        
        
        if(!isReachable){
            let dictError = ["message":"No internet connection available",
                             "status": "Failed"]
            FailureBlock(dictError)
        }
        
        
        let url = strBaseUrl + aryUrlString[apiTypeValue.rawValue]
        
        var request = createRequestWithDictionary(url:url, params: params, method: method)
        
        
        print(request?.description)
        var session = URLSession(configuration: configuration)
        
        
        //IMHKS:Set session time if needed default 60 sec
        /*
         configuration.timeoutIntervalForRequest = 30
         configuration.timeoutIntervalForResource = 30
         */
        
        
        let boundary = generateBoundaryString()
        let fullData = photoDataToFormData(data: data,boundary:boundary,fileName:fileName)

        
        request?.setValue("multipart/form-data; boundary=" + boundary, forHTTPHeaderField:"Content-Type")
        
        request?.setValue(String(fullData.length), forHTTPHeaderField:"Content-Length")
        request?.httpBody = fullData as Data
        request?.httpShouldHandleCookies = false
        
        
        session = URLSession(configuration: configuration)
        
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
    
    func photoDataToFormData(data:NSData,boundary:String,fileName:String) -> NSData {
        let fullData = NSMutableData()
        
        // 1 - Boundary should start with --
        let lineOne = "--" + boundary + "\r\n"
        fullData.append(lineOne.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        
        // 2
        let lineTwo = "Content-Disposition: form-data; name=\"image\"; filename=\"" + fileName + "\"\r\n"
        
        fullData.append(lineTwo.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        
        // 3
        let lineThree = "Content-Type: image/jpg\r\n\r\n"
        fullData.append(lineThree.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        
        // 4
        fullData.append(data as Data)
        
        // 5
        let lineFive = "\r\n"
        fullData.append(lineFive.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        
        // 6 - The end. Notice -- at the start and at the end
        let lineSix = "--" + boundary + "--\r\n"
        fullData.append(lineSix.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        
        return fullData
    }
    
}
