//
//  HeritageIndiaTableViewController.swift
//  HeritageIndia-CoreDataApplication
//
//  Created by Rohit on 1/16/1398 AP.
//  Copyright © 1398 Rohit. All rights reserved.
//

import UIKit
import CoreData
let shared1 = ModelViewController();
// Delegate
extension HeritageIndiaTableViewController : DelegateTableViewNew{
    func onClick(index: Int) {
        ind = index
    }
}

class HeritageIndiaTableViewController: UITableViewController, XMLParserDelegate, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
    //fetch request
    var fetchreq : NSFetchedResultsController<NSFetchRequestResult>! = nil
    var xmlData: [HeritageModelClass] = []
    var heritageData = HeritageModelClass()
    var heritageDetails: [Heritage] = []
    var filter: [Heritage] = []
    var searchController = UISearchController();
    var ind : Int = 0; //Initializing ind for tracking indexPath
    
    //Initializing context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //  let ad = UIApplication.shared.delegate as! AppDelegate
    // let context = ad.persistanceContainer.viewContext
    
    var obj : Heritage! = nil
    var entity: NSEntityDescription! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Heritage Indian Places"
        
        //Creating Request REsult Object
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Heritage");
        let sortAscending = NSSortDescriptor(key: "name", ascending: true);
        req.sortDescriptors = [sortAscending];
        
        fetchreq = NSFetchedResultsController(fetchRequest: req, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchreq.delegate = self
        
        if try! context.count(for: req) == 0 {
            exportXMLAndSave()
        }
        do{
            try fetchreq.performFetch()
            heritageDetails = fetchreq.fetchedObjects as! [Heritage]
        }
        catch{
            print("Error fetching data")
        }
        searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchBar.placeholder = "Search Indian Heritage Places"
            controller.searchResultsUpdater = self
            controller.obscuresBackgroundDuringPresentation = false
            tableView.tableHeaderView = controller.searchBar
            definesPresentationContext = true
            
            return controller
        })();
        
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController){
        filter.removeAll(keepingCapacity: false)
        
        filter = heritageDetails.filter{
            $0.name!.lowercased().contains(searchController.searchBar.text!.lowercased())
        }
        self.tableView.reloadData()
    }
    
    
    func filterTheTableView() -> Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    override func viewDidAppear(_ animated: Bool) {
        heritageDetails = fetchreq.fetchedObjects as! [Heritage]
        searchController.searchBar.text = "";
        searchController.isActive = false;
        self.tableView.reloadData();
    }

    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        heritageDetails = fetchreq.fetchedObjects as! [Heritage];
        searchController.searchBar.text = "";
        searchController.isActive = false;
        self.tableView.reloadData();
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(filterTheTableView()){
            return filter.count;
        }
        else{
            return heritageDetails.count;
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell;
        if (filterTheTableView()){
            obj = filter[indexPath.row];
        }
        else{
            obj = heritageDetails[indexPath.row];
        }
        cell.nameLabel!.text = obj.name
        cell.addressLabel!.text = obj.address
        if obj.image != nil {
            print("Image Name-" + obj.image!)
            cell.imageViewLabel!.image = getImageFromDocumentsDirectory(imageName: obj.image!)
        }
        cell.layer.borderWidth = 3
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if(filterTheTableView()){
                obj = filter[indexPath.row];
            }
            else{
                obj = heritageDetails[indexPath.row];
            }
            context.delete(obj);
            do{
                try context.save();
            }
            catch{
            }
            
            do{
                try fetchreq.performFetch();
                heritageDetails = fetchreq.fetchedObjects as! [Heritage];
            }
            catch{
            }
            self.tableView.reloadData();
        }
    }
    
    func getImageFromDocumentsDirectory(imageName : String) -> UIImage {
        let imageNameWithExtension = imageName + ".png";
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true);
        let imageUrl = URL(fileURLWithPath: paths.first!).appendingPathComponent(imageNameWithExtension);
        return UIImage(contentsOfFile: imageUrl.path)!;
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0;
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editsegue"{
            let destination = segue.destination as! AddUpdateHeritageViewController
            
            //getting the current cell from the index path
            
            if (filterTheTableView()){
                destination.Obj = filter[ind];
                destination.Count = heritageDetails.count //keep Count for Creating unique image id
            }
            else{
                destination.Obj = heritageDetails[ind];
                destination.Count = heritageDetails.count
            }
            
        }
        else if segue.identifier == "selectedsegue" {
            let destination = segue.destination as! SelectedHeritageViewController
            let indexPath = tableView.indexPathForSelectedRow
            
            //getting the current cell from the index path
            let data = heritageDetails[indexPath!.row];
            heritageData.name = data.name!
            heritageData.image = data.image!
            heritageData.address = data.address!
            heritageData.url = data.url!
            heritageData.information = data.information!
            destination.Obj = heritageData
            
        }
        else{
            let destination = segue.destination as! AddUpdateHeritageViewController
            destination.Count = heritageDetails.count
        }
        
        
        
        
    }
    func exportXMLAndSave(){
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
    func saveImageToPath(image : UIImage, path: URL){
        do{
            if let pngImageData = image.pngData(){
                try pngImageData.write(to: path)
            }
        }catch{
            print("Unable to save image in documents directory")
        }
    }
    
    
}

