//
//  CallbackResponse.swift
//  golfOneUnder
//
//  Created by Muhammad Hashir on 11/22/22.
//

import Foundation

struct CallbackResponse<T> {
    
    init() {
        self.errorMessage = ""
        self.dataResult = nil
        self.responseStatus = .success
    }
    
    init (errorMessage: String) {
        self.errorMessage = errorMessage
        self.responseStatus = .failure
        self.dataResult = nil
    }
    
    init (dataResult: T) {
        self.dataResult = dataResult
        self.responseStatus = .success
        self.errorMessage = nil
    }
    
    var responseStatus: networkCallResponseStatus
    var errorMessage: String?
    var dataResult: T?
}

struct BaseServiceResponseDTO<T: Decodable>: Decodable {
    let action: String
    let data: T?
    let error: String?
    
    enum CodingKeys: String, CodingKey {
        case action
        case data
        case error
    }
}
