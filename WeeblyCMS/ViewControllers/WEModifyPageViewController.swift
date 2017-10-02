//
//  WEModifyPageViewController.swift
//  WeeblyCMS
//
//  Created by Swapnil Jain on 10/1/17.
//  Copyright © 2017 Weebly. All rights reserved.
//

import UIKit
import CoreData

class WEModifyPageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, WERefreshPage, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK:- Properties
    @IBOutlet weak var collectionView: UICollectionView!
    var websitePage: Page?
    var pageElements = [Element]()
    
    // MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Bar button item to add elements
        let addElementButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addElement(_:)))
        navigationItem.rightBarButtonItem = addElementButton
        
        // Set title
        if let websitePage = websitePage{
            title = websitePage.pageName
        }
        
        // Reload colletion view
        refreshMyPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- IBAction
    @objc func addElement(_ sender: UIBarButtonItem){
        
        let alertController = UIAlertController(title: "Add new element", message: "", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Add Text", style: .default, handler: { (action) in
            let addNewElementVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNewElementVC") as? WEAddNewElementViewController
            if let addNewElementVC = addNewElementVC{
                addNewElementVC.websitePage = self.websitePage
                addNewElementVC.delegate = self
                self.present(addNewElementVC, animated: true, completion: nil)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Add Image", style: .default, handler: { (action) in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK:- UICollectionView data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageElements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ElementCell", for: indexPath) as! ElementCollectionViewCell
        let element = pageElements[indexPath.row]
        
        // Show text/image
        if let elementName = element.elementName{
            cell.elementName.text = elementName
            cell.elementImageView.image = nil
        }else if let image = element.elementImage, let imageData = image as? Data {
            cell.elementImageView.image = UIImage(data: imageData)
            cell.elementName.text = nil
        }else{
            // error?
            cell.elementName.text = nil
            cell.elementImageView.image = nil
        }
        return cell
    }
    
    // MARK:- UICollectionView delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Show option to edit/delete
        let alertController = UIAlertController(title: "Operations", message: "", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (action) in
            let addNewElementVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNewElementVC") as? WEAddNewElementViewController
            if let addNewElementVC = addNewElementVC{
                addNewElementVC.websitePage = self.websitePage
                addNewElementVC.delegate = self
                addNewElementVC.operationType = .edit
                addNewElementVC.element = self.pageElements[indexPath.row]
                self.present(addNewElementVC, animated: true, completion: nil)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action) in
            // Delete item
            let element = self.pageElements[indexPath.row]
            self.deleteElement(element: element)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK:- UIImagePicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Debug logs
        print(info)
        
        // Save selected image here.
        if info.count > 0, let selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            saveElementWithImage(elementImage: selectedImage)
        }
        
        // Dismiss picker
        picker.dismiss(animated: true, completion: {
            self.refreshMyPage()
        })
    }
    
    // MARK:- Helpers
    func refreshMyPage(){
        // Get all elements
        let descriptor = NSSortDescriptor(key: "elementOrder", ascending: true)
        if let elements = websitePage?.elements{
            pageElements =  elements.sortedArray(using: [descriptor]) as! [Element]
        }
        collectionView.reloadData()
    }
    
    // MARK:- Coredata Operations
    func deleteElement(element: Element){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        // Remove element
        websitePage?.removeFromElements(element)
        // Save context
        do{
            try managedContext.save()
            refreshMyPage()
        }catch let error{
            // Handle error here
            print(error.localizedDescription)
        }
    }
    
    func saveElementWithImage(elementImage: UIImage){
        guard let imageData = UIImagePNGRepresentation(elementImage) else{
            return
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let element = NSEntityDescription.insertNewObject(forEntityName: "Element", into: managedContext) as! Element
        element.elementOrder = Int16(websitePage?.elements?.count ?? 0)
        element.elementImage = NSData(data: imageData)
        websitePage?.addToElements(element)
        
        // Save
        do{
            try managedContext.save()
        }catch let error{
            // Handle error here
            print(error.localizedDescription)
        }
    }
}
