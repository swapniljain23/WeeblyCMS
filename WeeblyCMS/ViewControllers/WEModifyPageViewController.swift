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
    var elementToEdit: Element?
    
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
        
        // Add gesture recognizer
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
        
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
    
    @objc func handleLongPressGesture(gesture: UILongPressGestureRecognizer){
        print("handleLongPressGesture")
        switch(gesture.state) {
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
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

        guard let elementType = element.elementType else{
            return cell
        }
        
        // Show text/image
        if elementType == eElementType.text.rawValue{
            cell.elementName.text = element.elementName
            cell.elementImageView.image = nil
        }else if elementType == eElementType.image.rawValue, let image = element.elementImage, let imageData = image as? Data {
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
        // Selection
        let selectedItem = self.pageElements[indexPath.row]
        
        // Show option to edit/delete
        let alertController = UIAlertController(title: "Operations", message: "", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (action) in
            if let elementType = selectedItem.elementType, elementType == eElementType.image.rawValue{
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                self.elementToEdit = selectedItem
                self.present(imagePicker, animated: true, completion: nil)
            }else if let elementType = selectedItem.elementType, elementType == eElementType.text.rawValue{
                let addNewElementVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNewElementVC") as? WEAddNewElementViewController
                if let addNewElementVC = addNewElementVC{
                    addNewElementVC.websitePage = self.websitePage
                    addNewElementVC.delegate = self
                    addNewElementVC.operationType = .edit
                    addNewElementVC.element = selectedItem
                    self.present(addNewElementVC, animated: true, completion: nil)
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action) in
            // Delete item
            let element = selectedItem
            self.deleteElement(element: element)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("collectionView:moveItemAt")
        let itemToMove = pageElements[sourceIndexPath.row]
        pageElements.remove(at: sourceIndexPath.row)
        pageElements.insert(itemToMove, at: destinationIndexPath.row)
        updatePageElementOrder()
    }
    
    // MARK:- UIImagePicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Debug logs
        print(info)
        
        guard info.count > 0, let selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage else{
            return
        }
        // Save selected image here.
        if let element = elementToEdit{
            // Edit
            editElementWithImage(element: element, elementImage: selectedImage)
            elementToEdit = nil
        }else{
            // Save
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
        element.elementType = eElementType.image.rawValue
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
    
    func editElementWithImage(element: Element, elementImage: UIImage){
        guard let imageData = UIImagePNGRepresentation(elementImage) else{
            return
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        element.elementImage = NSData(data: imageData)
        
        // Save
        do{
            try managedContext.save()
        }catch let error{
            // Handle error here
            print(error.localizedDescription)
        }
    }
    
    func updatePageElementOrder(){
        for (index, element) in pageElements.enumerated(){
            element.elementOrder = Int16(index)
        }
        // Save context
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
    }
}
