//
//  GetMyOfficeStatisticsViewModel.swift
//  eVAS Tracker
//
//  Created by Brian on 10/7/21.
//

import Foundation
class GetMyOfficeStatisticsViewModel:NSObject
{
    
    var onStartLoading: (() -> Void)?
    var onStopLoading: (() -> Void)?
    var onSuccessHandler: ((OfficeStatisticsModel) -> Void)?
    var onErrorHandler: ((String) -> Void)?

    let httpUtility = WebService()
    
    let recahbility = rechabilityModel()
    
   
    func fetchData(EmployeeID:String)
    {
        
        self.onStartLoading?()
      
        httpUtility.NetworkCall(requestUrl: "\(ApiEndpoints.GetMyOfficeStatistics)\(EmployeeID)", Method: .get, requestBody:nil, resultType: OfficeStatisticsModel.self){[weak self](ApiResponse,error)  in
                self?.onStopLoading?()
       
                if(error == nil)
                {
                  
                    if(ApiResponse != nil)
                    {
             
                        do {
                                  let data = try JSONSerialization.data(withJSONObject: ApiResponse! , options: .prettyPrinted)
                                  
                                  let responseData = try JSONDecoder().decode(OfficeStatisticsModel.self, from: data)
                
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
