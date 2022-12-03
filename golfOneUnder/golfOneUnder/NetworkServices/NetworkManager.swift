//
//  NetworkManager.swift
//  golfOneUnder
//
//  Created by Muhammad Hashir on 11/22/22.
//

import Foundation

class NetworkManager {
    
    static var sharedInstance = NetworkManager()
    
    private init () {
        
    }
    
    func post<T: Encodable>(url: String, parameters: T, onCompletion: @escaping ((_ response: CallbackResponse<Data>) -> ())) {
        let finalURL = WebUrls.productionBaseUrl + url
        guard let url = URL(string: finalURL) else { fatalError("Missing URL") }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONEncoder().encode(parameters) else {
            return
        }
        
        urlRequest.httpBody = httpBody
        print("Making a network call: \(url.absoluteString)")
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                print("Request error for URL \(url): ", error)
                onCompletion(CallbackResponse(errorMessage: "Error from server"))
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode == 200 {
                guard let data = data else { return }
                onCompletion(CallbackResponse(dataResult: data))
            }
            else {
                onCompletion(CallbackResponse(errorMessage: "Error from server \(String(describing: error?.localizedDescription))"))
            }
        }.resume()
    }
}
