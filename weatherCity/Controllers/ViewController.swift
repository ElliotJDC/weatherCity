//
//  ViewController.swift
//  weatherCity
//
//  Created by Elliot Cunningham on 26/10/2018.
//  Copyright © 2018 Elliot Cunningham. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var cityFRC: NSFetchedResultsController<City>?

    @IBOutlet weak var cityCollectionView: UICollectionView!
    @IBOutlet weak var navigationItemView: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCitys()
        self.configureView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.cityCollectionView.reloadData()
    }
    
    private func configureView() {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10.0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let width = self.cityCollectionView.bounds.size.width
        let height = (self.cityCollectionView.bounds.size.height/3 - 30)
        layout.itemSize = CGSize(width: width, height: height)
        
        self.cityCollectionView.setCollectionViewLayout(layout, animated: true)
        self.cityCollectionView.reloadData()
    }


}

// MARK: CoreData Stack,

extension ViewController : NSFetchedResultsControllerDelegate {
    
    func loadCitys() -> Void {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<City> = City.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "isCurrentPosition", ascending: true)]
        
        self.cityFRC = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.cityFRC?.delegate = self
        do {
            try self.cityFRC?.performFetch()
        }
        catch let error {
            print("error trying to fetch city", error)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.cityCollectionView.reloadData()
    }
}

// MARK: CoreDataStack

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let citysFRC = self.cityFRC else { return 0 }
        return citysFRC.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell:CityCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityCellIdentifier", for: indexPath) as? CityCollectionViewCell else {
            fatalError()
        }
        
        cell.isReadyForShow = false
        cell.reloadView()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width
        let height = (collectionView.frame.size.height/3 - 30)
        
        return CGSize(width: width, height: height)
        
    }
    

}

