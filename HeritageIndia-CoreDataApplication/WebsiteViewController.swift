//
//  WebsiteViewController.swift
//  IndianHeritage
//
//  Created by Rohit on 12/18/1397 AP.
//  Copyright © 1397 Rohit. All rights reserved.
//

import UIKit
import WebKit
class WebsiteViewController: UIViewController , WKNavigationDelegate {
    var webData : String!
    var heritageData : HeritageModelClass!
    
    
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Web Data";
        self.title = "Indian Heritage Information"
        webData = heritageData.getUrl()
        let url = URL(string: webData)
        let request = URLRequest(url: url!)
        webView.load(request)
        webView.navigationDelegate = self;
        
        // Do any additional setup after loading the view.
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
