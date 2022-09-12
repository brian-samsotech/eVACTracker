//
//  CheckRechabiliy.swift
//  EVAS
//
//  Created by Brian on 5/30/21.
//

import Foundation

class rechabilityModel:NSObject
{
    
 
    var onSuccessHandler: (() -> Void)?
    var onErrorHandler: (() -> Void)?
 
   
    func pingServer(url:String)
{
        
        if(url == "")
        {
            if((onErrorHandler) != nil)
            {
                self.onErrorHandler!();
            }
        }
        else{
           
    do{
       
        _ = try Data(contentsOf:URL(string:url)!)

  
        if((self.onSuccessHandler) != nil)
        {
            self.onSuccessHandler!();
        }
        }
   
    
    catch
    {
        if((self.onErrorHandler) != nil)
        {
            self.onErrorHandler!();
        }
    }
            }
     
       
       
}
}
