//
//  uploadProfilePictureModel.swift
//  eVAS Tracker
//
//  Created by Brian on 10/17/21.
//
import Foundation
struct uploadProfilePictureRequest:Codable
{
    var ProfileBase64Img: String?
    var EmployeeID: Int?
   
}
