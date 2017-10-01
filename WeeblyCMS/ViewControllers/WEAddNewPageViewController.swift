//
//  WEAddNewPageViewController.swift
//  WeeblyCMS
//
//  Created by Swapnil Jain on 9/30/17.
//  Copyright © 2017 Weebly. All rights reserved.
//

import UIKit
import CoreData

class WEAddNewPageViewController: UIViewController, UITextFieldDelegate {

    // MARK:- Properties
    @IBOutlet weak var pageTitle: UITextField!
    var myWebsite: Website?
    weak var refreshWebsiteDelegate: RefreshWebsite?
    
    // MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- IBAction
    @IBAction func cancel(_ sender: UIBarButtonItem){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem){
        if let text = pageTitle.text, !text.isEmpty, let myWebsite = myWebsite{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let page = NSEntityDescription.insertNewObject(forEntityName: "Page", into: managedContext) as! Page
            page.pageOrder = Int16(myWebsite.pages?.count ?? 0)
            page.pageName = text
            myWebsite.addToPages(page)
            
            // Save
            do{
                try managedContext.save()
                if let delegate = refreshWebsiteDelegate{
                    delegate.loadMyWebsite()
                }
                dismiss(animated: true, completion: nil)
            }catch let error{
                // Handle error here
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func addElement(_ sender: UIBarButtonItem){
        
    }
    
    // MARK:- UITextField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
