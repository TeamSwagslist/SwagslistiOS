//
//  File.swift
//  Swagslist
//
//  Created by Aidan Brady on 9/24/16.
//  Copyright © 2016 Aidan Brady. All rights reserved.
//

import UIKit
import MapKit

class ViewEntryController: UIViewController
{
    var eventEntry: EventEntry!
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var apparelIcon: UIImageView!
    @IBOutlet weak var foodIcon: UIImageView!
    @IBOutlet weak var trinketsIcon: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func backPressed(_ sender: AnyObject)
    {
        self.navigationController!.popViewController(animated: true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navItem.title = eventEntry.name
        descriptionText.text = eventEntry.description
        apparelIcon.isHidden = !eventEntry.swagSet.contains("APPAREL")
        foodIcon.isHidden = !eventEntry.swagSet.contains("FOOD")
        trinketsIcon.isHidden = !eventEntry.swagSet.contains("TRINKETS")
        
        let coords = CLLocationCoordinate2D(latitude: eventEntry.latitude, longitude: eventEntry.longitude)
        let region = MKCoordinateRegionMake(coords, MKCoordinateSpanMake(self.mapView.region.span.longitudeDelta/8192, self.mapView.region.span.latitudeDelta/8192))
        
        let point = MKPointAnnotation()
        
        point.coordinate = coords
        point.title = eventEntry.name
        
        self.mapView.setRegion(region, animated: false)
        self.mapView.addAnnotation(point)
        self.mapView.isScrollEnabled = true
    }
}
