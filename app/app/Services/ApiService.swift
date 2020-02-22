//
//  ApiService.swift
//  app
//
//  Created by kelly on 2020/02/21.
//  Copyright © 2020 kelly. All rights reserved.
//

import Foundation

enum ApiService {
    private static let API_BASE_URL = API.baseURL
    
    private static func setCommonHeader(request: inout URLRequest ) {
        request.addValue(API.key, forHTTPHeaderField: "X-API-KEY")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
    }
    
    public static func get() {
        var request = URLRequest(url: API_BASE_URL)
        request.httpMethod = "GET"
        
        setCommonHeader(request: &request);
        
        let task = URLSession.shared.dataTask(with: API_BASE_URL, completionHandler: { (data, response, error) in
            if let data = data,
                let model = try? JSONDecoder().decode(UserModel.self, from: data) {
                print(model.login!)
            }
        })
        
        task.resume()
    }
    
    public static func post() {
        
    }
}
