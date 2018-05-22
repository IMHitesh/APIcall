# APIcall

**Support**

IDE: `Xcode 9.0`

API Type: `Json API`

Target: `iOS 9.0 and Later`


**Import below file**

`API.swift`

`mageUploading.swift`

`Reachability.swift`

`Struct.swift`


**Change Base URL**

Goto> `API.swift` > Add Base URL

**Add sub base URL as Below**

`let strCountryAPI = "country-list"`

`let strForgotPassword = "api/people/"`

`let strloginAPI = "userlogin"`

`let strEditProfile = "edit-profile"`

**Add Enum With API Type**

`enum apiType:Int {`

`case CountryAPI = 0`

`case forgotPasswordAPI = 1`

`case loginAPI = 2`

`case EditProfile = 3`

`}`


**Add value to array as below**

`    var aryUrlString:[String] = [strCountryAPI,strForgotPassword,strloginAPI,strEditProfile]`

**Simple GET, POST and Multipart request**


`fileprivate func SampleGetRequest() {`

        API.sharedInstance.makeAPICall(apiTypeValue:.CountryAPI, params:nil, method:.GET, SuccessBlock: { (response) in
            
            print(response)
            
        }, FailureBlock: { (error) in
            
            print(error)
            
        })
    }
    
    
    fileprivate func SamplePostRequest() {
        
        let bodyParams = ["clientId":"1_3bcbxd9e24g0gk4swg0kwgcwg4o8k8g4g888kwc44gcc0gwwk4",            "clientSecret":"4ok2x70rlfokc8g0wws8c8kwcokw80k44sg48goc0ok4w0so0k",
                          "email":"mahesh.sonaiya+34@brainvire.com",
                          "password":"Brain@2016",
                          "deviceType":"2",
                          "grantType":"password",
                          "deviceToken":"sdsfsddsvds"
        ]
        
        API.sharedInstance.makeAPICall(apiTypeValue:.loginAPI, params: bodyParams, method:.POST, SuccessBlock: { (response) in
            
            print(response)
            
        }) { (error) in
            
            print(error)
            
        }
    }
    
    
    fileprivate func MultipartImageUploading() {
        
        let data = UIImagePNGRepresentation(UIImage.init(named:"1.jpg")!)
        
        let dictReq = ["email":"hitesh.surani@brainvire.com",
                       "fname":"Hitesh",
                       "lname":"Surani",
                       "phoneno":"8140042846",
                       "profile_pic":"",
                       "select_city":"779",
                       "select_country":"101",
                       "select_state":"12",
                       "user_id" : "7512"
        ]
        
        API.sharedInstance.UploadImage(fileName:"profile_pic", data:data! as NSData, apiTypeValue:.EditProfile, params: dictReq, method:.POST, SuccessBlock: { (response) in
            
            print(response)
            
        }) { (dictError) in
            
            print(dictError)
            
        }
    }
