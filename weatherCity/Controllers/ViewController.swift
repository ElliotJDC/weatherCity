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
    var weatherFRC: NSFetchedResultsController<Weather>?
    
    var scrennSize = UIScreen.main.bounds.size
    var addCityView: AddCityFromModal! = AddCityFromModal(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var detailWeatherView: WeatherDetailView?

    @IBOutlet weak var cityCollectionView: UICollectionView!
    @IBOutlet weak var navigationItemView: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCitys()
        self.configureView()
        self.detailWeatherView = WeatherDetailView(frame: CGRect(x: 0, y: 0, width: self.scrennSize.width, height: self.scrennSize.height))

    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.scrennSize = UIScreen.main.bounds.size
        self.detailWeatherView?.frame = CGRect(x: 0, y: 0, width: self.scrennSize.width, height: self.scrennSize.height)
        self.addCityView = AddCityFromModal(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
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
        
        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ViewController.handleTapAddCityNavButton(_:)))
        
        self.navigationItemView.setRightBarButton(item, animated: true)
        
        self.cityCollectionView.setCollectionViewLayout(layout, animated: true)
        self.cityCollectionView.reloadData()
    }


}

// MARK: CoreData Stack,

extension ViewController : NSFetchedResultsControllerDelegate {
    
    func loadCitys() -> Void {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<City> = City.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "isCurrentPosition", ascending: false)]
        
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
            fatalError("error in index path")
        }
        
        let city = self.cityFRC?.object(at: indexPath)
        let weathers = city?.weather
        
        let weather = Weather.findGoodWeatherForDate(date: Date(), weathers: weathers?.allObjects as! [Weather])
        
        cell.isReadyForShow = (weather == nil) ? false : true
        cell.city = city?.name
        if let weather = weather {
            cell.weather = weather
            cell.temperature = String(weather.temperature.rounded()) + "°C"
            cell.wind = "Vent " + String(weather.wind_average) + " Km/h"
            if weather.nebulocite < 25 {
                cell.image = UIImage(named: "sun")
            }
            if weather.nebulocite > 25 && weather.nebulocite < 75 {
                cell.image = UIImage(named: "cloud")
            }
            if weather.nebulocite > 75 {
                cell.image = UIImage(named: "rain")
            }
        }
        cell.reloadView()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width
        let height = (collectionView.frame.size.height/3 - 30)
        
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CityCollectionViewCell else {
            fatalError("error in index path")
        }
        
        if let weather = cell.weather, let detailWeatherView = self.detailWeatherView {
            self.detailWeatherView?.currentWeather = weather
            self.detailWeatherView?.reloadData()
            self.view.addSubview(detailWeatherView)
        }
    }
}

// MARK: Selector

extension ViewController {
    @objc func handleTapAddCityNavButton(_ sender:Any) -> Void {
        self.addCityView.delegate = self
        self.addCityView.cityTextFild.text = ""
        self.view.addSubview(self.addCityView)
    }
}

extension ViewController : AddCityDelegate {
    func handleTapAddCityButton(_ cityName: String, _ view: AddCityFromModal) {
        view.removeFromSuperview()
        GeolocManager.sharedManager.getCoordinate(addressString: cityName) { (latitude, longitude) in
            
            if latitude != 0 && longitude != 0 {
                let coordonate = Coordinate(latitude: latitude, longitude: longitude, findedDate: Date())
                _ = City.createNewCity(cityName: cityName, location: coordonate)
            }
            
        }
    }
    
    func handleTapCloseViewButton(_ view: AddCityFromModal) {
        view.removeFromSuperview()
    }
}

