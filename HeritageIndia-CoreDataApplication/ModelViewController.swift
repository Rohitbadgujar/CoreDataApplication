//
//  ModelViewController.swift
//  HeritageIndia-CoreDataApplication
//
//  Created by Rohit on 1/18/1398 AP.
//  Copyright © 1398 Rohit. All rights reserved.
//

import UIKit
import CoreData
protocol DelegateModelViewController{
    func exportXMLAndSave(context: NSManagedObjectContext)
    func saveImageToPath(image : UIImage, path: URL)
}
class ModelViewController: UIViewController {
    var xmlData: [HeritageModelClass] = []
    var obj : Heritage! = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   public func exportXMLAndSave(context: NSManagedObjectContext){
        let xmlParser = XMLHeritageParser()
        xmlParser.parseData()
        xmlData = xmlParser.heritage;
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true);
        
        //parse XML data to obj
        for list in xmlData{
            
            obj = Heritage(context: context);
            
            //save other elements
            obj.name = list.name;
            obj.address = list.address
            obj.information = list.information;
            obj.url = list.url;
            obj.image =  list.image;
            let imageNameWithExtension = obj.image
            let imageUrl = URL(fileURLWithPath: paths.first!).appendingPathComponent(imageNameWithExtension!);
            saveImageToPath(image: UIImage(named: obj.image!)!, path: imageUrl);
        }
        
        do {
            try context.save();
        }
        catch{
            print("Error saving data to Core Data")
        }
        
    }
   public func saveImageToPath(image : UIImage, path: URL){
        do{
            if let pngImageData = image.pngData(){
                try pngImageData.write(to: path)
            }
        }catch{
            print("Unable to save image in documents directory")
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
