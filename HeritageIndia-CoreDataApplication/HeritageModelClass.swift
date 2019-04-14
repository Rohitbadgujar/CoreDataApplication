//
//  HeritageDetails.swift
//  Person Information
//
//  Created by Rohit on 12/16/1397 AP.
//  Copyright © 1397 Rohit Badgujar. All rights reserved.
//

import Foundation
class HeritageModelClass {
    //Properties
    var name    : String
    var information : String
    var address : String
    var image   : String
    var url     : String
    
    
    //Initialisers
    init() {
        self.name     = ""
        self.address  = ""
        self.information    = ""
        self.image    = ""
        self.url       = ""
    }
    
    init(name:String, address:String, information:String, image:String, url:String) {
        
        self.name     = name
        self.address  = address
        self.information    = information
        self.image    = image
        self.url       = url
    }
    //Methods
    func setName(name: String) {self.name = name}
    func getName()-> String {return self.name}
    
    func setAddress(address: String) {self.address = address}
    func getAddress()-> String {return self.address}
    
    func setinformation(information: String) {self.information = information}
    func getinformation()-> String {return self.information}
    
    func setImage(image: String) {self.image = image}
    func getImage()-> String {return self.image}
    
    func setUrl(url: String) {self.url = url}
    func getUrl()-> String {return self.url}
    
}
