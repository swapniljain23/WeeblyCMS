//
//  WEModifyPageViewController.swift
//  WeeblyCMS
//
//  Created by Swapnil Jain on 10/1/17.
//  Copyright © 2017 Weebly. All rights reserved.
//

import UIKit
import CoreData

class WEModifyPageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, WERefreshPage {

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
            // TODO:
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
        cell.elementName.text = element.elementName
        return cell
    }
    
    // MARK:- UICollectionView delegate
    
    // MARK:- Helpers
    func refreshMyPage(){
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
