//
//  ApiService.swift
//  app
//
//  Created by kelly on 2020/02/21.
//  Copyright © 2020 kelly. All rights reserved.
//

import Foundation

enum HttpMethod: String, CustomStringConvertible {
    case GET
    case POST
    
    var description: String {
        return self.rawValue
    }
}

enum ApiService {
    private static let API_BASE_URL = API.baseURL
    
    private static func addCommonHeader(request: inout URLRequest ) {
        request.addValue(API.key, forHTTPHeaderField: "X-API-KEY")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
    }
    
    private static func call(httpMethod: HttpMethod) {
        var request = URLRequest(url: API_BASE_URL)
        request.httpMethod = httpMethod.description
        
        addCommonHeader(request: &request);
        
        let task = URLSession.shared.dataTask(with: API_BASE_URL, completionHandler: { (data, response, error) in
            if let data = data,
                let article = try? JSONDecoder().decode(Article.self, from: data) {
                print(article)
            }
        })
        
        task.resume()
    }
    
    static func get() {
        call(httpMethod: HttpMethod.GET)
    }
    
    static func post() {
        call(httpMethod: HttpMethod.POST)
    }
}
