//
//  ViewRelated.swift
//  Country Observer
//
//  Created by Daniel Šuškevič on 2020-08-01.
//  Copyright © 2020 Daniel Šuškevič. All rights reserved.
//

import UIKit

class ViewRelated {
    func configureNavigationBarTitleFor(title: String?, countryFlagImage: UIImage) -> UIView {
        
        // Create a navView to add to the navigation bar
        let navView = UIView()

        // Create the label
        let label = UILabel()
        label.text = title
        label.sizeToFit()
        label.center = navView.center
        label.textAlignment = NSTextAlignment.center

        // Create the image view
        let image = UIImageView()
        image.image = countryFlagImage
        // To maintain the image's aspect ratio:
        let imageAspect = image.image!.size.width/image.image!.size.height
        // Setting the image frame so that it's immediately before the text:
        image.frame = CGRect(x: label.frame.origin.x-label.frame.size.height*imageAspect, y: label.frame.origin.y, width: label.frame.size.height*imageAspect, height: label.frame.size.height)
        image.contentMode = UIView.ContentMode.scaleAspectFit

        // Add both the label and image view to the navView
        navView.addSubview(label)
        navView.addSubview(image)
        
        return navView
    }
}
