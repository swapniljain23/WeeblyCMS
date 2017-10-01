//
//  ViewController.swift
//  WeeblyCMS
//
//  Created by Swapnil Jain on 9/30/17.
//  Copyright © 2017 Weebly. All rights reserved.
//

import UIKit
import CoreData

class WERootViewController: UIViewController {

    // MARK:- Properties
    var myWebsite: Website = Website()
    
    // MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch saved websites
        if let websites = fetchSavedWebsites(), websites.count > 0{
            // Proceed with displaying saved website/s
            myWebsite = websites[0]
            loadMyWebsite()
        }else{
            // Prompt user to create first website
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "CreateWebsite", sender: self)
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:- Load website
    func loadMyWebsite(){
        print("Website Name: \(myWebsite.websiteName)")
        for page in myWebsite.pages!{
            let pageObj = page as! Page
            print("PAGE# \(pageObj.pageOrder): \(pageObj.pageName)")
        }
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
}

