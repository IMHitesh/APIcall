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

Simple GET, POST and Multipart request


`fileprivate func SampleGetRequest() {`

        API.sharedInstance.makeAPICall(apiTypeValue:.CountryAPI, params:nil, method:.GET, SuccessBlock: { (response) in
            
            print(response)
            
        }, FailureBlock: { (error) in
            
            print(error)
            
        })
    }
