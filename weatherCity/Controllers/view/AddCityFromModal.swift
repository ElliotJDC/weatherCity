//
//  AddCityFromModal.swift
//  weatherCity
//
//  Created by Elliot Cunningham on 27/10/2018.
//  Copyright © 2018 Elliot Cunningham. All rights reserved.
//

import UIKit

protocol AddCityDelegate {
    func handleTapAddCityButton(_ cityName:String, _ view: AddCityFromModal)
    func handleTapCloseViewButton(_ view: AddCityFromModal)
}

class AddCityFromModal: UIView {
    
    private let backGroundButton:UIButton! = UIButton(type: .custom)
    private let validateButton:UIButton! = UIButton(type: .custom)
    public let cityTextFild:UITextField! = UITextField()
    private let contentView:UIView! = UIView()
    
    public var delegate:AddCityDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureView()
    }
    
    func configureView() {
        let screenSize = UIScreen.main.bounds.size
        self.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        self.accessibilityIdentifier = "AddModalAccessID"
        self.backGroundButton.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        self.backGroundButton.accessibilityIdentifier = "AddModelCloseButtonID"
        self.backGroundButton.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.backGroundButton.addTarget(self, action: #selector(AddCityFromModal.handleTapBackGroundButton(_:)), for: .touchUpInside)
        self.addSubview(self.backGroundButton)
        
        self.contentView.frame = CGRect(x: screenSize.width/2 - 200, y: 100, width: 400, height: 400)
        self.contentView.backgroundColor = UIColor.white
        self.contentView.layer.cornerRadius = 10.0
        self.addSubview(self.contentView)
        
        self.cityTextFild.frame = CGRect(x: 20, y: 40, width: 400 - 40, height: 60)
        self.cityTextFild.accessibilityIdentifier = "AddCityTextFieldId"
        self.cityTextFild.layer.cornerRadius = 10.0
        self.cityTextFild.layer.borderColor = UIColor.darkGray.cgColor
        self.cityTextFild.layer.borderWidth = 1.5
        self.cityTextFild.backgroundColor = UIColor.clear
        self.cityTextFild.textAlignment = .center
        self.cityTextFild.placeholder = "Saisissez le nom de la ville que vous souhaiter rajouter"
        self.cityTextFild.delegate = self
        self.contentView.addSubview(self.cityTextFild)
        
        self.validateButton.frame = CGRect(x: 150, y: 300, width: 100, height: 50)
        self.validateButton.accessibilityIdentifier = "AddCityValidateButtonID"
        self.validateButton.backgroundColor = UIColor.clear
        self.validateButton.layer.cornerRadius = 10.0
        self.validateButton.layer.borderColor = UIColor.black.cgColor
        self.validateButton.layer.borderWidth = 1.5
        self.validateButton.setTitleColor(UIColor.darkText, for: .normal)
        self.validateButton.setTitle("Valider", for: .normal)
        self.validateButton.addTarget(self, action: #selector(AddCityFromModal.handleTapValidateButton(_:)), for: .touchUpInside)
        self.contentView.addSubview(self.validateButton)
    }
}

extension AddCityFromModal {
    
    @objc func handleTapBackGroundButton(_ sender:Any) -> Void {
        guard let delegate = self.delegate else {
            self.removeFromSuperview()
            return
        }
        delegate.handleTapCloseViewButton(self)
    }
    
    @objc func handleTapValidateButton(_ sender:Any) -> Void {
        guard let delegate = self.delegate,
            let city = self.cityTextFild.text else {
                self.removeFromSuperview()
                return
        }
        delegate.handleTapAddCityButton(city, self)
    }
    
}

extension AddCityFromModal : UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}


