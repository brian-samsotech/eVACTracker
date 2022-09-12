//
//  ApiEndpoints.swift

//
//  Created by Brian on 3/16/21.
//

import Foundation
struct ApiEndpoints
{
    
  
    //Dev
//static let baseUrl = "http://192.168.2.162:8083/"
    static let baseUrl = "http://evastracker.samsotech-ereg.cloud/"
    static let pathOnline = "api/Services/"
    static let ValidateLogin = baseUrl+pathOnline+"ValidateLogin"
    static let GetEmployeeStatisticByEmployeeID = baseUrl+pathOnline+"GetEmployeeStatisticByEmployeeID?employeeID="
    static let GetMyTeamStatistics = baseUrl+pathOnline+"GetMyTeamStatistics?employeeID="
    static let GetMyOfficeStatistics = baseUrl+pathOnline+"GetMyOfficeStatistics?employeeID="
    static let NotifyHR = baseUrl+pathOnline+"NotifyHR"
    static let ChangePassword = baseUrl+pathOnline+"ChangePassword"
    static let GetDoseMaster = baseUrl+pathOnline+"GetDoseMaster"
    static let GetVaccineMasterList = baseUrl+pathOnline+"GetVaccineMasterList"
    static let UploadProfilePic = baseUrl+pathOnline+"UploadProfilePic"
    static let UploadPCRResult = baseUrl+pathOnline+"UploadPCRResult"
    static let UploadVaccinationCertificate = baseUrl+pathOnline+"UploadVaccinationCertificate"
    
}

struct userDefaultVal
{
    static let EmployeeID = "EmployeeID"
 
  
}
