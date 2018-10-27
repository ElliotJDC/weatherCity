//
//  WeatherDetailView.swift
//  weatherCity
//
//  Created by Elliot Cunningham on 27/10/2018.
//  Copyright © 2018 Elliot Cunningham. All rights reserved.
//

import UIKit

class WeatherDetailView: UIView {
    
    var currentWeather:Weather?
    var currentCity:City?

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var deletteButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var nebuliteLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var pressionLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var warningSnowLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadNibView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibView()
    }
    
    func loadNibView() {
        Bundle.main.loadNibNamed("WeatherDetailView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.deletteButton.layer.cornerRadius = 10
        self.deletteButton.layer.borderWidth = 1.5
        self.deletteButton.layer.borderColor = self.deletteButton.titleLabel?.textColor.cgColor
        
        self.closeButton.layer.cornerRadius = 10
        self.closeButton.layer.borderWidth = 1.5
        self.closeButton.layer.borderColor = self.closeButton.titleLabel?.textColor.cgColor
        
    }
    
    public func reloadData() -> Void {
        guard let weather = self.currentWeather else {
            self.cityNameLabel.text = ""
            self.nebuliteLabel.text  = ""
            self.temperatureLabel.text  = ""
            self.pressionLabel.text  = ""
            self.humidityLabel.text  = ""
            self.precipitationLabel.text  = ""
            self.windLabel.text  = ""
            self.warningSnowLabel.text  = ""
            
            return
        }
        
        let nebulite = String(weather.nebulocite.rounded())
        let temperature = String(weather.temperature.rounded())
        let pression = String(weather.pression.rounded())
        let rain = String(weather.rain.rounded())
        let humidity = String(weather.humidity.rounded())
        let wind_average = String(weather.wind_average.rounded())
        let wind_rafale = String(weather.wind_rafale.rounded())
        let snow = (weather.snow_alerte) ? "Oui" : "NON"
        
        
        self.cityNameLabel.text = weather.city?.name
        self.nebuliteLabel.text = "Couverture nuageuse : " + nebulite + " %"
        self.temperatureLabel.text = "Temperature : " + temperature + " °C"
        self.pressionLabel.text = "Pression : " + pression + " Pascal"
        self.humidityLabel.text = "Humidité : " + humidity + " %"
        self.precipitationLabel.text = "Précipitacion" + rain + " mm"
        self.windLabel.text = "vent moyen " + wind_average + ", vent rafale " + wind_rafale
        self.warningSnowLabel.text = "rique de neige " + snow
        
    }

    @IBAction func handleTapDeletteButton(_ sender: Any) {
        guard let city = self.currentCity else {
            return
        }
        
        CoreDataManager.sharedManager.persistentContainer.viewContext.delete(city)
        CoreDataManager.sharedManager.saveContext()
        self.removeFromSuperview()
    }
    
    @IBAction func handleTapCloseButton(_ sender: Any) {
        self.removeFromSuperview()
    }
    
}
