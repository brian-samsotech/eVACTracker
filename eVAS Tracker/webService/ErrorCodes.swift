//
//  ErrorCodes.swift
//  NBO
//
//  Created by Rinkal on 7/29/19.
//  Copyright © 2019 Rinkal. All rights reserved.
//

import Foundation
import UIKit

func Error_code(error_code: String) -> String {
    var str:String!
    switch (error_code) {
 
    case "01":
        str = "There seems to be an issue with the server connection. Please try again"
    case "02":
        str = "There seems to be an issue with the response from the server. Please try again"
    case "03":
        str = "Network connection not available, kindly check your connection and try again"
    case "04":
        str = "Provide Username and Password"
        case "05":
            str = "Data not availble"
    
   
    default:
        str = "An error has occurred. Please Try Again"
    }
    return str
}

struct CustomError {
  
    public static let TimeOutError = "The app will logout after 30 minutes of inactivity!"
    public static let Error = "An error has occurred. Please Try Again"
    public static let NetworkConnection = "Network connection not available, kindly check your connection and try again."
    public static let ParseError = "There seems to be an issue with processing the response from the server. Please try again"
    public static let Success = "Success"
   
}
func getVaccinationType(Type: String) -> (String,UIColor,Bool) {
    var status:String!
    var color:UIColor!
    var isUpload:Bool!
    switch (Type) {
 
    case "Not Known":
        status = "Vaccination Status Not Known"
        color = UIColor.red
        isUpload = true
    case "Completed":
        status = "COVID-19 Vaccinated"
        color = greenColor
        isUpload = false
    case "Not Completed":
        status = "COVID-19 Vaccination Pending"
        color = UIColor.gray
        isUpload = true
    case "Accommodations":
        status = "COVID-19 Accommodations"
        color = greenColor
        isUpload = false
    default:
        status = "Vaccine status not known"
        color = UIColor.red
        isUpload = true
    }
    return (status,color,isUpload)
}
func getPCRType(Days: Int) -> (String,UIColor,Bool) {
    var status:String!
    var color:UIColor!
    var isUpload:Bool!
    switch (Days) {
        case _ where Days > 14:
            status = "\(Days) days - Last PCR Negative"
            color = aember
            isUpload = true
        case _ where Days == 0:
            status = "PCR Status Not Known"
            color = UIColor.gray
            isUpload = true
        case _ where Days < 14:
            status = "\(Days) days - Last PCR Negative"
            color = greenColor
            isUpload = false
    default:
        status = "PCR Status Not Known"
        color = UIColor.red
        isUpload = true
    }
    return (status,color,isUpload)
}

func formattedDateFromString(dateString: String, InputFormat format: String, OutputFormat format2: String) -> String? {

    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = format

    if let date = inputFormatter.date(from: dateString) {

        let outputFormatter = DateFormatter()
      outputFormatter.dateFormat = format2

        return outputFormatter.string(from: date)
    }

    return nil
}
