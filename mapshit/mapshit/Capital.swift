//
//  Capital.swift
//  mapshit
//
//  Created by juran_k on 4/8/17.
//  Copyright © 2017 juran_k. All rights reserved.
//

import UIKit
import MapKit
class Capital: NSObject, MKAnnotation {
    var title: String?
    
    var coordinate: CLLocationCoordinate2D
    var info: String
    var isFavorited: Bool
    init(title: String, coordinate: CLLocationCoordinate2D, info: String, isFavorited: Bool) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.isFavorited = isFavorited
    }
    

}
