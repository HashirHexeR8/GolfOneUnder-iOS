//
//  OneFinderUserDefaults.swift
//  golfOneUnder
//
//  Created by Muhammad Hashir on 12/1/22.
//

import Foundation

class OneFinderUserDefaults {
    
    //User Default Keys
    private let userAuthKey =  "userAuthKey"
    private let userIDKey =  "userIDKey"
    private let userInfoKey = "userInfoKey"
    private let deviceInfoListKey = "deviceInfoListKey"
    
    static let sharedInstance = OneFinderUserDefaults()
    
    func setUserInfo(userInfo: UserInfoDTO?) {
        let encoder = JSONEncoder()
        do {
            if userInfo == nil {
                UserDefaults.standard.set(NSData(), forKey: userInfoKey)
            }
            else {
                let encodedData = try encoder.encode(userInfo)
                UserDefaults.standard.set(encodedData, forKey: userInfoKey)
            }
        }
        catch {
            print("Unable to Encode User (\(error))")
        }
    }
    
    func getUserInfo() -> UserInfoDTO? {
        let decoder = JSONDecoder()
        do {
            let data = UserDefaults.standard.data(forKey: userInfoKey)
            return try decoder.decode(UserInfoDTO.self, from: data!)
        }
        catch {
            print("Unable to Encode User (\(error))")
        }
        return nil
    }
    
    func setUserAuthToken(token: String) {
        UserDefaults.standard.set(token, forKey: userAuthKey)
    }
    
    func getUserAuthToken() -> String {
        return UserDefaults.standard.string(forKey: userAuthKey) ?? ""
    }
    
    func setUserId(userId: Int) {
        UserDefaults.standard.set(userId, forKey: userIDKey)
    }
    
    func getUserId() -> Int {
        UserDefaults.standard.integer(forKey: userIDKey)
    }
    
    func addDeviceInfo(deviceInfo: DeviceInfoDTO) {
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        do {
            if let data = UserDefaults.standard.data(forKey: deviceInfoListKey) {
                var deviceList = try decoder.decode([DeviceInfoDTO].self, from: data)
                deviceList.append(deviceInfo)
                let encodedData = try encoder.encode(deviceList)
                UserDefaults.standard.set(encodedData, forKey: deviceInfoListKey)
            }
            else {
                var deviceList = [DeviceInfoDTO]()
                deviceList.append(deviceInfo)
                let encodedData = try encoder.encode(deviceList)
                UserDefaults.standard.set(encodedData, forKey: deviceInfoListKey)
            }
        }
        catch {
            print("Unable to Encode Device List (\(error))")
        }
    }
    
    func getDeviceList() -> [DeviceInfoDTO] {
        
        let decoder = JSONDecoder()
        do {
            if let data = UserDefaults.standard.data(forKey: deviceInfoListKey) {
                return try decoder.decode([DeviceInfoDTO].self, from: data)
            }
            return []
        }
        catch {
            print("Unable to Encode Device List (\(error))")
        }
        
        return []
    }
    
    func clearDeviceList() {
        let encoder = JSONEncoder()
        do {
            let list: [DeviceInfoDTO] = []
            let encodedData = try encoder.encode(list)
            UserDefaults.standard.set(encodedData, forKey: deviceInfoListKey)
        }
        catch {
            print("Unable to Encode Device List (\(error))")
        }
    }
}
