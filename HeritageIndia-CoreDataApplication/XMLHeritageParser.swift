//
//  XMLHeritageParser.swift
//  HeritageIndia-CoreDataApplication
//
//  Created by Rohit on 1/16/1398 AP.
//  Copyright © 1398 Rohit. All rights reserved.
//

import Foundation
class XMLHeritageParser: NSObject, XMLParserDelegate{
   
    var heritage = [HeritageModelClass] ();
    var elementName: String = String();
    //vars to hold tag data
    var name = String();
    var address = String();
    var information = String();
    var image = String();
    var url = String();
    func parseData(){
        //parse the data
        if let path = Bundle.main.url(forResource: "heritage", withExtension: "xml"){
            if let parser = XMLParser(contentsOf: path){
                parser.delegate = self;
                parser.parse();
            }
        }
        
    }
    //begin parsing when player tag is encountered
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "heritage" {
            name = String()
            address = String()
            image = String()
            information = String()
            url = String()
        }
        self.elementName = elementName;
    }
    //add to array when parsing of one player is complete
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "heritage" {
            let heritageDetails = HeritageModelClass(name: name, address: address, information: information, image: image, url: url);
            heritage.append(heritageDetails);
        }
    }
    //parsing
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines);
        
        if(!data.isEmpty){
            switch self.elementName {
            case "name":
                name += data;
                break;
            case "address":
                address += data;
                break;
            case "information":
                information += data;
                break;
            case "image":
                image += data;
                break;
            case "url":
                url += data;
                break;
            default:
                break;
            }
        }
    }
}

