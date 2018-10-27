//
//  CityCollectionViewCell.swift
//  weatherCity
//
//  Created by Elliot Cunningham on 26/10/2018.
//  Copyright © 2018 Elliot Cunningham. All rights reserved.
//

import UIKit

class CityCollectionViewCell: UICollectionViewCell {
    
    public var isReadyForShow:Bool = false
    public var city:String?
    public var temperature:String?
    public var wind:String?
    public var image:UIImage?
    public var weather:Weather?
    
    var activutyView:UIActivityIndicatorView?
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.city = nil
        self.temperature = nil
        self.wind = nil
        self.isReadyForShow = false
        self.image = nil
    }
    
    
    func configureView() {
        self.layer.cornerRadius = 10.0
        
        let frame = CGRect(x:0, y:0, width: 50, height: 50)
        self.activutyView = UIActivityIndicatorView(frame: frame)
        self.activutyView?.color = UIColor.darkText
    }
    
    func reloadView() {
        if isReadyForShow {
            self.backgroundImage.image = self.image
            self.cityLabel.isHidden = false
            self.temperatureLabel.isHidden = false
            self.windLabel.isHidden = false
            self.backgroundImage.isHidden = false
            
            self.cityLabel.text = self.city
            self.temperatureLabel.text = self.temperature
            self.windLabel.text = self.wind
        }
        else {
            if let activityView = self.activutyView {
                activityView.startAnimating()
                self.addSubview(activityView)
            }
            
            self.cityLabel.isHidden = true
            self.temperatureLabel.isHidden = true
            self.windLabel.isHidden = true
            self.backgroundImage.isHidden = true
        }
    }
    
    
}
