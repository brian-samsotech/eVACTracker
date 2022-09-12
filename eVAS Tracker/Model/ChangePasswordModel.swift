//
//  ChangePasswordModel.swift
//  eVAS Tracker
//
//  Created by Brian on 10/10/21.
//

import Foundation
struct ChangePasswordModel:Codable
{
    var EmployeeID: Int?
    var OldPassword: String?
    var NewPassword: String?
}
