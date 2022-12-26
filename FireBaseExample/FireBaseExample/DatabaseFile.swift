//
//  DatabaseFile.swift
//  FireBaseExample
//
//  Created by ashutosh deshpande on 21/12/2022.
//

import Foundation

final class DataBaseFile {
    
    static let shared = DataBaseFile()
    
    private init(){
        
    }
    
    func saveDetails(uId : String, eMail : String){
        UserDefaults.standard.setValue(uId, forKey: "uId")
        UserDefaults.standard.setValue(eMail, forKey: "eMail")
    }
    
    func fetchUId() -> String{
        let uId = UserDefaults.standard.string(forKey: "uId")
        return uId!
    }
    
    func fetchEMail() -> String{
        let eMail = UserDefaults.standard.string(forKey: "eMail")
        return eMail!
    }
    
}
