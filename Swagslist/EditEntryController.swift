//
//  EditEntryController.swift
//  Swagslist
//
//  Created by Aidan Brady on 9/25/16.
//  Copyright © 2016 Aidan Brady. All rights reserved.
//

import UIKit
import MapKit

class EditEntryController : UIViewController
{
    let isNew = true
    
    @IBOutlet weak var premiumControl: UISegmentedControl!
    @IBOutlet weak var eventNameField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var apparelSwitch: UISwitch!
    @IBOutlet weak var foodSwitch: UISwitch!
    @IBOutlet weak var trinketsSwitch: UISwitch!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let coords = CLLocationCoordinate2D(latitude: 33.77586305, longitude: -84.39651936)
        let region = MKCoordinateRegionMake(coords, MKCoordinateSpanMake(self.mapView.region.span.longitudeDelta/8192, self.mapView.region.span.latitudeDelta/8192))
        
        self.mapView.setRegion(region, animated: false)
        self.mapView.isScrollEnabled = true
    }
    
    @IBAction func savePressed(_ sender: AnyObject)
    {
        let eventEntry = EventEntry()
        eventEntry.name = eventNameField.text
        eventEntry.description = descriptionField.text
        eventEntry.premium = premiumControl.selectedSegmentIndex == 1
        eventEntry.ownerUsername = SharedData.sessionUsername
        
        if apparelSwitch.isOn
        {
            eventEntry.swagSet.append("APPAREL")
        }
        if foodSwitch.isOn
        {
            eventEntry.swagSet.append("FOOD")
        }
        if trinketsSwitch.isOn
        {
            eventEntry.swagSet.append("TRINKETS")
        }
        
        eventEntry.latitude = mapView.centerCoordinate.latitude
        eventEntry.longitude = mapView.centerCoordinate.longitude
        
        eventEntry.endTime = UInt64(timePicker.date.timeIntervalSince1970*1000)
        
        let response = NetHandler.addEvent(entry: eventEntry)
        
        if response.getAccept()
        {
            self.navigationController!.popViewController(animated: true)
            (self.navigationController!.topViewController as! MapController).doRefresh()
        }
        else {
            let alertMsg = response.message != nil ? response.message! : "Unable to connect."
            Utilities.displayAlert(controller: self, title: "Couldn't add event", msg: alertMsg, action: nil)
        }
    }
    
    @IBAction func cancelPressed(_ sender: AnyObject)
    {
        self.navigationController!.popViewController(animated: true)
    }
}
