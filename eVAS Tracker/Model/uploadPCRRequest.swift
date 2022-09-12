//
//  uploadPCRRequest.swift
//  eVAS Tracker
//
//  Created by Brian on 10/17/21.
//

import Foundation
struct uploadPCRRequest:Codable
{
    var FileBase64String: String?
    var EmployeeID: Int?
    var IsPCRPositive: Bool?
    var PCRDateTime:String?
}
