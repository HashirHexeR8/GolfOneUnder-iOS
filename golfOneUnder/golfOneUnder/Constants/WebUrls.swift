//
//  WebUrls.swift
//  golfOneUnder
//
//  Created by Muhammad Hashir on 11/22/22.
//
///This class holds all the data for API Endpoints name and base urls

import Foundation

struct WebUrls {
    ///Base URL to access production Database that the end users will be using
    static let productionBaseUrl = "https://finder-appp.herokuapp.com/api/"
    ///Base URL to access staging Database that will be used for testing purposes only.
    static let stagingBaseUrl = ""
    
    static let loginUserEndPointName = "login"
    static let signupUserEndPointName = "signup"
    static let getLoggedInUserEndPointName = "check_login"
    static let deleteUserProfileEndPointName = "delete_account"
    
}
