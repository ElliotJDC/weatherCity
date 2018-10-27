//
//  WebView.swift
//  weatherCity
//
//  Created by Elliot Cunningham on 27/10/2018.
//  Copyright © 2018 Elliot Cunningham. All rights reserved.
//

import UIKit

class WebView: UIWebView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadRequest(URLRequest(url: URL(string: "https://www.infoclimat.fr")!))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadRequest(URLRequest(url: URL(string: "https://www.infoclimat.fr")!))
    }
    
}
