//
//  ViewController.swift
//  WeeblyCMS
//
//  Created by Swapnil Jain on 9/30/17.
//  Copyright © 2017 Weebly. All rights reserved.
//

import UIKit
import CoreData

class WERootViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WERefreshWebsite, UITextFieldDelegate {

    // MARK:- Properties
    var myWebsite: Website?
    var myWebsitePages = [Page]()
    
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var websiteTitle: UILabel!
    @IBOutlet weak var websiteTextField: UITextField!
    
    // MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshMyWebsite()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:- Load website
    func refreshMyWebsite(){
        
        // Set a website if already exist
        if myWebsite == nil, let websites = fetchSavedWebsites(), websites.count > 0{
            myWebsite = websites[0]
        }
        
        // Guard against no website
        guard let myWebsite = myWebsite, let websitePages = myWebsite.pages else{
            createNewWebsite()
            return
        }
        
        // Preceed with loading website
        myWebsitePages.removeAll()
        print("My Website: \(String(describing: myWebsite.websiteName))")
        //websiteTitle.text = myWebsite.websiteName
        websiteTextField.text = myWebsite.websiteName
        for page in websitePages{
            let pageObj = page as! Page
            print("\tPAGE# \(pageObj.pageOrder): \(String(describing: pageObj.pageName))")
            if let elements = pageObj.elements{
                for element in elements{
                    let elementObj = element as! Element
                    print("\t\tElement# \(elementObj.elementOrder): \(String(describing: elementObj.elementName)) -> \(String(describing: elementObj.elementDescription))")
                }
            }
        }
        let descriptor = NSSortDescriptor(key: "pageOrder", ascending: true)
        if let pages = myWebsite.pages{
            myWebsitePages =  pages.sortedArray(using: [descriptor]) as! [Page]
        }
        tableView.reloadData()
    }
    
    // MARK:- Core data operations
    func fetchSavedWebsites() -> [Website]?{
        // Fetch
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        do{
            return try managedContext.fetch(Website.fetchRequest())
        }catch _ as NSError{
            // Handle error
        }
        return nil
    }
    
    // MARK:- UITableView data source methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myWebsitePages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PageCell", for: indexPath)
        let page = myWebsitePages[indexPath.row]
        cell.textLabel?.text = page.pageName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    // MARK:- UITableView delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Push to modify page
        let modifyPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModifyPage") as! WEModifyPageViewController
        modifyPageVC.websitePage = myWebsitePages[indexPath.row]
        navigationController?.pushViewController(modifyPageVC, animated: true)
    }
    
    // MARK:- UITextField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        updateWebsiteTitle(newTitle: textField.text)
        return true
    }
    
    // MARK:- Segue/Navigation methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "ToCreateNewPage"{
            let newPageVC = segue.destination as! WEAddNewPageViewController
            newPageVC.refreshWebsiteDelegate = self
            newPageVC.myWebsite = myWebsite
        }
    }
    
    func createNewWebsite(){
        // Prompt user to create first website
        let createNewWebsiteVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateNewWebsiteVC") as! WECreateWebsiteViewController
        createNewWebsiteVC.delegate = self
        present(createNewWebsiteVC, animated: true, completion: nil)
    }
    
    func updateWebsiteTitle(newTitle: String?){
        // update title
        myWebsite?.websiteName = newTitle
        
        // save context
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
    }
}

