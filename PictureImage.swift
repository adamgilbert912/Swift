//
//  PictureImage.swift
//  Project10
//
//  Created by macbook on 1/9/20.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class PictureImage: UIViewController {
    let imageView = UIImageView()
    
    override func loadView() {
        
        view = imageView
    }
    
    override func viewDidLoad() {
        navigationController?.hidesBarsOnTap = true
    }

}
