//
//  Article.swift
//  app
//
//  Created by kelly on 2020/05/05.
//  Copyright © 2020 kelly. All rights reserved.
//

import Foundation

struct Article: Codable, Identifiable {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
}
