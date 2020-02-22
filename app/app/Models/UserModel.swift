//
//  User.swift
//  app
//
//  Created by kelly on 2020/02/21.
//  Copyright © 2020 kelly. All rights reserved.
//

import Foundation

public class UserModel: Decodable {
    
    public let login: String?
    public let company: String?
    public let email: String?
    
    public init?(){
        self.login = "";
        self.company = "";
        self.email = "";
    }

    public init(login: String?, company: String?, email: String?) {
        self.login = login;
        self.company = company;
        self.email = email;
    }
}
