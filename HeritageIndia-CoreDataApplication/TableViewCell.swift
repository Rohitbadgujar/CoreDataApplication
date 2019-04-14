//
//  TableViewCell.swift
//  HeritageIndia-CoreDataApplication
//
//  Created by Rohit on 1/16/1398 AP.
//  Copyright © 1398 Rohit. All rights reserved.
//


import UIKit
protocol DelegateTableViewNew {
    func onClick(index : Int)
}
class TableViewCell: UITableViewCell {
    
    var cellDelegate = DelegateTableViewNew?.none
    var index : IndexPath?
    @IBOutlet weak var addressLabel: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    // @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var imageViewLabel: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func clickEdit(_ sender: Any) {
        cellDelegate?.onClick(index: (index?.row)!)
    }
    
}

