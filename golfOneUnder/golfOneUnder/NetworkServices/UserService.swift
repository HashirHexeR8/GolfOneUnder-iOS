//
//  UserService.swift
//  golfOneUnder
//
//  Created by Muhammad Hashir on 11/22/22.
//

import Foundation

protocol UserServiceProtocol {
    func loginUser(userName: String, password: String, onResponse: @escaping ((_ response: CallbackResponse<UserInfoDTO>) -> ()))
}

class UserService: UserServiceProtocol {

    static var sharedInstance = UserService()
    
    func loginUser(userName: String, password: String, onResponse: @escaping ((CallbackResponse<UserInfoDTO>) -> ())) {
        
        let params = ["email":userName, "password":password]
        
        NetworkManager.sharedInstance.post(url: WebUrls.loginUserEndPointName, parameters: params) { response in
            if response.responseStatus == .success {
                do {
                    let serverResponse = try JSONDecoder().decode(BaseServiceResponseDTO<UserInfoDTO>.self, from: response.dataResult!)
                    if serverResponse.action.lowercased() != "failed" {
                        let userInfo = serverResponse.data
                        OneFinderUserDefaults.sharedInstance.setUserAuthToken(token: userInfo?.token ?? "")
                        OneFinderUserDefaults.sharedInstance.setUserId(userId: Int(userInfo?.id ?? "0") ?? 0)
                        OneFinderUserDefaults.sharedInstance.setUserInfo(userInfo: userInfo)
                        onResponse(CallbackResponse(dataResult: userInfo!))
                    }
                    else {
                        print("Unable to login at this moment. \(String(describing: serverResponse.error))")
                        onResponse(CallbackResponse(errorMessage: "\(String(describing: serverResponse.error))"))
                    }
                }
                catch let error {
                    print("Unable to login at this moment. \(error)")
                    onResponse(CallbackResponse(errorMessage: "Unable to login at this moment."))
                }
            }
            else {
                print("Login Error \(String(describing: response.errorMessage))")
                onResponse(CallbackResponse(errorMessage: "Unable to login at this moment."))
            }
        }
    }
    
    func signupUser(userSignupInfo: UserSignUpRequestDTO, onResponse: @escaping ((CallbackResponse<UserInfoSignUpDTO>) -> ())) {
        
        NetworkManager.sharedInstance.post(url: WebUrls.signupUserEndPointName, parameters: userSignupInfo) { response in
            if response.responseStatus == .success {
                do {
                    let serverResponse = try JSONDecoder().decode(BaseServiceResponseDTO<UserInfoSignUpDTO>.self, from: response.dataResult!)
                    if serverResponse.action.lowercased() != "failed" {
                        let userInfo = serverResponse.data
                        OneFinderUserDefaults.sharedInstance.setUserAuthToken(token: userInfo?.token ?? "")
                        OneFinderUserDefaults.sharedInstance.setUserId(userId: Int(userInfo?.id ?? "0") ?? 0)
                        OneFinderUserDefaults.sharedInstance.setUserInfo(userInfo: UserInfoDTO(userSignUp: serverResponse.data!))
                        onResponse(CallbackResponse(dataResult: userInfo!))
                    }
                    else {
                        print("Unable to signup at this moment. \(String(describing: serverResponse.error))")
                        onResponse(CallbackResponse(errorMessage: "\(serverResponse.error ?? "Unable to signup at this moment.")"))
                    }
                }
                catch let error {
                    print("Unable to signup at this moment. \(error)")
                    onResponse(CallbackResponse(errorMessage: "Unable to signup at this moment."))
                }
            }
            else {
                print("signup Error \(String(describing: response.errorMessage))")
                onResponse(CallbackResponse(errorMessage: "Unable to signup at this moment."))
            }
        }
    }
    
    func logoutCurrentUser() {
        OneFinderUserDefaults.sharedInstance.setUserId(userId: 0)
        OneFinderUserDefaults.sharedInstance.setUserAuthToken(token: "")
        OneFinderUserDefaults.sharedInstance.setUserInfo(userInfo: nil)
        OneFinderUserDefaults.sharedInstance.clearDeviceList()
    }
    
    func deleteUserProfile(onResponse: @escaping ((CallbackResponse<Void>) -> ())) {
        let params = ["token": OneFinderUserDefaults.sharedInstance.getUserAuthToken()]
        NetworkManager.sharedInstance.post(url: WebUrls.deleteUserProfileEndPointName, parameters: params) { response in
            if response.responseStatus == .success {
                do {
                    let userData = try JSONDecoder().decode(BaseServiceResponseDTO<String>.self, from: response.dataResult!)
                    if userData.action.lowercased() != "failed" {
                        onResponse(CallbackResponse())
                    }
                    else {
                        print("\(String(describing: userData.error))")
                        onResponse(CallbackResponse(errorMessage: "Unable to perform this action: \(userData.error ?? "")"))
                    }
                }
                catch let error {
                    print("Unable to delete user profile at this moment. \(error.localizedDescription)")
                    onResponse(CallbackResponse(errorMessage: "Unable to perform this action."))
                }
            }
            else {
                print("Unable to delete user profile at this moment: \(String(describing: response.errorMessage))")
                onResponse(CallbackResponse(errorMessage: "Unable to perform this action: \(String(describing: response.errorMessage))"))
            }
        }
    }
}
