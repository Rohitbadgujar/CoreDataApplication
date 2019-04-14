//
//  AddUpdateHeritageViewController.swift
//  HeritageIndia-CoreDataApplication
//
//  Created by Rohit on 1/17/1398 AP.
//  Copyright © 1398 Rohit. All rights reserved.
//

import UIKit
import CoreData

class AddUpdateHeritageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    var entity : NSEntityDescription! = nil;
    var Obj : Heritage! = nil;
    var imageName = String();
    var Count = Int()
    var imagePicker = UIImagePickerController();
   var isNewData = false;
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true);
  
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var informationTextField: UITextView!
    
   
    @IBOutlet weak var infoAlertButton: UIButton!
    @IBOutlet weak var webAlertButton: UIButton!
     @IBOutlet weak var addAlertButton: UIButton!
     @IBOutlet weak var nameAlertButton: UIButton!
     @IBOutlet weak var browseAlertButton: UIButton!
    
    @IBAction func pickImageButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self;
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = true;
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        //if editing existing player, then delete the player data first
        if !self.isNewData{
            deleteHeritageData();
        }
        
        if validateUserInput() {
            saveDataToCD();
            saveImageToPath();
            navigationController?.popViewController(animated: true);
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoAlertButton.isHidden = true;
        nameAlertButton.isHidden = true
        addAlertButton.isHidden = true
        browseAlertButton.isHidden = true
        webAlertButton.isHidden = true
        if Obj == nil {
            self.isNewData = true;
        }
        else{
            nameTextField.text = Obj.name
            addressTextField.text = Obj.address
            websiteTextField.text = Obj.url
            informationTextField.text = Obj.information
            imageView.image = getImageFromDirectory(imageName: Obj.image!);
           
            imageName = Obj.image!
            let bgImg = UIImageView(frame: UIScreen.main.bounds);
            bgImg.image = imageView.image!
            //sbgImg.contentMode = UIView.ContentMode.scaleToFill;
            bgImg.alpha = 0.2;
            self.view.insertSubview(bgImg, at: 0);
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        self.dismiss(animated: true, completion: nil);
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageName = String(Count + 1) + "image";
    }
    
    func validateUserInput() -> Bool{
        let alert = UIAlertController(title: "Invalid Input", message: "Please Enter Valid input",preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { _ in
          
        }))
        infoAlertButton.isHidden = true;
        nameAlertButton.isHidden = true
        addAlertButton.isHidden = true
        browseAlertButton.isHidden = true
        webAlertButton.isHidden = true
        if (nameTextField.text?.isEmpty)! {
            alert.message = "Name field is mandatory";
            nameAlertButton.isHidden = false
            self.present(alert,animated: true);
        }
        else if (addressTextField.text?.isEmpty)!{
            addAlertButton.isHidden = false
            alert.message = "Address field is mandatory";
            self.present(alert,animated: true);
        }
        else if (websiteTextField.text?.isEmpty == nil){
            webAlertButton.isHidden = false
            alert.message = "Please enter a valid URL";
            self.present(alert,animated: true);
        }
        else if (informationTextField.text?.isEmpty == nil){
            infoAlertButton.isHidden = false
            alert.message = "Please enter a valid Heritage Information";
            self.present(alert,animated: true);
        }
        else if(imageName.count < 5){
            browseAlertButton.isHidden = false
            alert.message = "Please select an image using browse button";
            self.present(alert,animated: true);
        }
        else{
            return true;
        }
        return false;
    }
    
    func saveDataToCD(){
        Obj = Heritage(context: context);
        Obj.name = nameTextField.text;
        Obj.address = addressTextField.text!;
        Obj.information = informationTextField.text;
        Obj.url = websiteTextField.text;
        Obj.image = imageName
        do{
            try context.save();
            let alert = UIAlertController(title: "Data Saved", message: "Data Succefully Saved to Core Data",         preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
        
            self.present(alert,animated: true);
        }
        catch{
                    }
    }
    
    func saveImageToPath(){
        let imageNameWithExtension = imageName
        let imageUrl = URL(fileURLWithPath: paths.first!).appendingPathComponent(imageNameWithExtension);
        //save the image from image view
        do{
            if let pngImageData = imageView.image!.pngData(){
                try pngImageData.write(to: imageUrl)
            }
        }catch{
            
        }
    }
    
    func getImageFromDirectory(imageName : String) -> UIImage {
        let imageNameWithExtension = imageName;
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true);
        let imageUrl = URL(fileURLWithPath: paths.first!).appendingPathComponent(imageNameWithExtension);
        return UIImage(contentsOfFile: imageUrl.path)!;
    }
    
    func deleteHeritageData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Heritage");
        request.predicate = NSPredicate(format: "name = %@", Obj.name!);
        let result = try? context.fetch(request);
        let res = result as! [Heritage]
        for obj in res{
            context.delete(obj);
        }
        do{
            try context.save();
        }
        catch{
            print("Error");
        }
    }
    
}
