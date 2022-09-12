//
//  DoseMasterModel.swift
//  eVAS Tracker
//
//  Created by Brian on 10/17/21.
//

import Foundation
struct DoseMasterModel : Codable {
    var doseID : Int?
    var doseName : String?
    
    enum CodingKeys: String, CodingKey {

        case doseID = "DoseID"
        case doseName = "DoseName"
       
    }

   

}
