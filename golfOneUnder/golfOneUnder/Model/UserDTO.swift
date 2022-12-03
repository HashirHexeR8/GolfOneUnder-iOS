//
//  UserDTO.swift
//  golfOneUnder
//
//  Created by Muhammad Hashir on 11/22/22.
//

import Foundation

struct UserLoginRequestDTO {
    
    init(userName: String, userEmail: String) {
        self.userName = userName
        self.userEmail = userEmail
    }
    
    var userName: String
    var userEmail: String
}

struct UserSignUpRequestDTO: Encodable {
    
    var email: String
    var password: String
    var name: String
    var username: String
}

struct UserInfoDTO: Decodable, Encodable {
    
    init () {
        
    }
    
    init (userSignUp: UserInfoSignUpDTO) {
        name = userSignUp.name
        username = userSignUp.username
        email = userSignUp.email
        id = userSignUp.id
        profile_pic = userSignUp.profile_pic
        token = userSignUp.token
    }
    
    var name: String? = ""
    var username: String? = ""
    var email: String? = ""
    var id: String? = ""
    var profile_pic: String? = ""
    var token: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case name
        case username
        case email
        case id
        case profile_pic
        case token
    }
}

struct UserInfoSignUpDTO: Decodable, Encodable {
    var name: String? = ""
    var username: String? = ""
    var email: String? = ""
    var id: String? = ""
    var profile_pic: String? = ""
    var token: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case name
        case username
        case email
        case id
        case profile_pic
        case token
    }
}


