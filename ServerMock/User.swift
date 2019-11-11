//
//  User.swift
//  ServerMock
//
//  Created by Sergey Pogrebnyak on 11.11.2019.
//  Copyright © 2019 Sergey Pogrebnyak. All rights reserved.
//

import Foundation
import SwiftyJSON

struct User {
    let name: String
    let userName: String
    let company: String

    init (fromJson json: JSON) {
        self.name = json["name"].string ?? ""
        self.userName = json["userName"].string ?? ""
        self.company = json["company"].string ?? ""
    }

    func getDescriptionForAlert() -> String {
        return "name: \(name) \n user name: \(userName) \n company: \(company)"
    }
}
