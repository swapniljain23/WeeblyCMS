//
//  WEModifyPageViewController.swift
//  WeeblyCMS
//
//  Created by Swapnil Jain on 10/1/17.
//  Copyright © 2017 Weebly. All rights reserved.
//

import UIKit
import CoreData

class WEModifyPageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

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
        reloadCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- IBAction
    @objc func addElement(_ sender: UIBarButtonItem){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let element = NSEntityDescription.insertNewObject(forEntityName: "Element", into: managedContext) as! Element
        element.elementOrder = 0
        element.elementName = "Default name"
        element.elementDescription = "Default description"
        
        // Relate website and page
        websitePage?.addToElements(element)
        
        // Save
        do{
            try managedContext.save()
            reloadCollectionView()
        }catch let error{
            // Handle error here
            print(error.localizedDescription)
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
        cell.elementName.text = element.elementName
        return cell
    }
    
    // MARK:- UICollectionView delegate
    
    // MARK:- Helpers
    func reloadCollectionView(){
        // Get all elements
        let descriptor = NSSortDescriptor(key: "elementOrder", ascending: true)
        if let elements = websitePage?.elements{
            pageElements =  elements.sortedArray(using: [descriptor]) as! [Element]
        }
        collectionView.reloadData()
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
