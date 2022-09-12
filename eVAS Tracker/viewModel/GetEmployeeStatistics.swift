//
//  GetEmployeeStatistics.swift
//  eVAS Tracker
//
//  Created by Brian on 10/7/21.
//

import UIKit

class GetEmployeeStatisticsViewModel:NSObject
{
    
    var onStartLoading: (() -> Void)?
    var onStopLoading: (() -> Void)?
    var onSuccessHandler: ((userModel) -> Void)?
    var onErrorHandler: ((String) -> Void)?

    let httpUtility = WebService()
    
    let recahbility = rechabilityModel()
    
   
    func fetchData(EmployeeID:String)
    {
        
        self.onStartLoading?()
      
        httpUtility.NetworkCall(requestUrl: "\(ApiEndpoints.GetEmployeeStatisticByEmployeeID)\(EmployeeID)", Method: .get, requestBody:nil, resultType: userModel.self){[weak self](ApiResponse,error)  in
                self?.onStopLoading?()
       
                if(error == nil)
                {
                  
                    if(ApiResponse != nil)
                    {
             
                        do {
                                  let data = try JSONSerialization.data(withJSONObject: ApiResponse! , options: .prettyPrinted)
                                  
                                  let responseData = try JSONDecoder().decode(userModel.self, from: data)
                
                         print(responseData)
                          self?.onSuccessHandler!(responseData).self
                 
                       
                              
                              }
                        catch _{
                                
                            self?.onErrorHandler?("02")
                             
                                self?.onStopLoading?()
                              
                              }
                    }
                    else
                    {
                    self?.onErrorHandler?("02")
                     
                        self?.onStopLoading?()
                    }
                    
                }
                else
                {
                    self?.onErrorHandler?(error ?? "02")
                 
                    self?.onStopLoading?()
                }
            }
      
            
     
        
    }
    
}
