//
//  WEAddNewElementViewController.swift
//  WeeblyCMS
//
//  Created by Swapnil Jain on 10/1/17.
//  Copyright © 2017 Weebly. All rights reserved.
//

import UIKit
import CoreData

class WEAddNewElementViewController: UIViewController {

    // MARK:- Properties
    @IBOutlet weak var elementNameTxtField: UITextField!
    @IBOutlet weak var elementDescTxtView: UITextView!
    var websitePage: Page?
    weak var delegate: WERefreshPage?
    var element: Element?
    var operationType: eOperationType = .create
    
    // MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // If its edit, then show the information
        if operationType == .edit, let element = element{
            elementNameTxtField.text = element.elementName
            elementDescTxtView.text = element.elementDescription
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- IBAction
    @IBAction func saveNewElement(_ sender: UIBarButtonItem){
        guard let elementName = elementNameTxtField.text, !elementName.isEmpty,
            let elementDesc = elementDescTxtView.text, !elementDesc.isEmpty else{
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        switch operationType {
        case .create:
            let element = NSEntityDescription.insertNewObject(forEntityName: "Element", into: managedContext) as! Element
            element.elementOrder = Int16(websitePage?.elements?.count ?? 0)
            element.elementType = eElementType.text.rawValue
            element.elementName = elementName
            element.elementDescription = elementDesc
            websitePage?.addToElements(element)
        case .edit:
            element?.elementName = elementName
            element?.elementDescription = elementDesc
        case .delete:
            break
        }
        
        // Save
        do{
            try managedContext.save()
            dismiss(animated: true, completion: {
                self.delegate?.refreshMyPage()
            })
        }catch let error{
            // Handle error here
            print(error.localizedDescription)
        }
    }

    @IBAction func cancel(_ sender: UIBarButtonItem){
        dismiss(animated: true, completion: nil)
    }
}
