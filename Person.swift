//
//  Person.swift
//  Project10
//
//  Created by macbook on 1/9/20.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String?
    var imageID: String
    
    init(name: String?, imageID: String) {
        self.name = name
        self.imageID = imageID
    }
}
