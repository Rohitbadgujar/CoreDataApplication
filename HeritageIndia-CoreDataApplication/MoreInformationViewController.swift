//
//  MoreInformationViewController.swift
//  IndianHeritage
//
//  Created by Rohit on 12/18/1397 AP.
//  Copyright © 1397 Rohit. All rights reserved.
//

import UIKit

class MoreInformationViewController: UIViewController {
    var heritageData : HeritageModelClass!
    
    @IBOutlet weak var heritageNameLabel: UILabel!
    
    @IBOutlet weak var heritageAddressLabel: UILabel!
    
    @IBOutlet weak var myview: UIImageView!
    
    
    @IBOutlet weak var heritageInformationText: UITextView!
    @IBOutlet weak var heritageUrlLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Indian Heritage Information"
        heritageNameLabel.text = heritageData.getName()
        heritageAddressLabel.text = heritageData.getAddress()
        heritageUrlLabel.text = heritageData.getUrl()
        heritageInformationText.text = heritageData.getinformation()
        let bgImg = UIImageView(frame: UIScreen.main.bounds);
        bgImg.image = UIImage(named: heritageData.getImage());
        ///bgImg.contentMode = UIView.ContentMode.scaleToFill;
        bgImg.alpha = 0.2;
        self.view.insertSubview(bgImg, at: 0);
        // Do any additional setup after loading the view.
    }
    
    
    override func prepare(for webseque: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        let destination = webseque.destination as! WebsiteViewController //typecasting because segue.destination returns UIViewController
        // Pass the selected object to the new view controller.
        
       destination.heritageData = self.heritageData
    }
    
}
