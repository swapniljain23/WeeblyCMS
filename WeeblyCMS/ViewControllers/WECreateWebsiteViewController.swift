//
//  WECreateWebsiteViewController.swift
//  WeeblyCMS
//
//  Created by Swapnil Jain on 9/30/17.
//  Copyright © 2017 Weebly. All rights reserved.
//

import UIKit
import CoreData

class WECreateWebsiteViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    var isCancellable = false
    weak var delegate: WERefreshWebsite?
    
    // MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- IBAction
    @IBAction func saveWebsiteName(_ sender: UIBarButtonItem){
        if let isEmpty = textField.text?.isEmpty, !isEmpty{
            // Create a new website here.
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            let website = NSEntityDescription.insertNewObject(forEntityName: "Website", into: managedContext) as! Website
            website.websiteName = textField.text!
            
            let page = NSEntityDescription.insertNewObject(forEntityName: "Page", into: managedContext) as! Page
            page.pageOrder = 0
            page.pageName = "HOME"

            // Relate website and page
            website.addToPages(page)
            
            // Save
            do{
                try managedContext.save()
                if let delegate = delegate{
                    delegate.refreshMyWebsite()
                }
                dismiss(animated: true, completion: nil)
            }catch let error{
                // Handle error here
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem){
        if isCancellable{
            dismiss(animated: true, completion: nil)
        }else{
            textField.text = ""
            textField.resignFirstResponder()
            enableDisableBarButton(isEnable: false)
        }
    }
    
    // MARK:- UITextfield delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        enableDisableBarButton(isEnable: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let isEmpty = textField.text?.isEmpty, isEmpty{
            enableDisableBarButton(isEnable: false)
        }
    }
    
    // MARK:- Helper
    func enableDisableBarButton(isEnable: Bool){
        saveButton.isEnabled = isEnable
        cancelButton.isEnabled = isEnable
    }
}
