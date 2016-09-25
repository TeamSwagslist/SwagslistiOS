//
//  MapController.swift
//  Swagslist
//
//  Created by Aidan Brady on 9/24/16.
//  Copyright © 2016 Aidan Brady. All rights reserved.
//

import UIKit
import MapKit

class MapController : UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        
        let coords = CLLocationCoordinate2D(latitude: 33.77586305, longitude: -84.39651936)
        let region = MKCoordinateRegionMake(coords, MKCoordinateSpanMake(self.mapView.region.span.longitudeDelta/8192, self.mapView.region.span.latitudeDelta/8192))
        
        self.mapView.setRegion(region, animated: false)
        
        doRefresh()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return SharedData.eventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EntryCell
        let entry = SharedData.eventList[indexPath.row]
        
        cell.nameLabel.text = entry.name
        cell.distanceLabel.isHidden = true
        cell.apparelIcon.isHidden = !entry.swagSet.contains("APPAREL")
        cell.foodIcon.isHidden = !entry.swagSet.contains("FOOD")
        cell.trinketsIcon.isHidden = !entry.swagSet.contains("TRINKETS")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destController = mainStoryboard.instantiateViewController(withIdentifier: "ViewEntryController") as! ViewEntryController
        
        destController.eventEntry = SharedData.eventList[indexPath.row]
        self.navigationController!.pushViewController(destController, animated: true)
    }
    
    @IBAction func onRefresh(_ sender: AnyObject)
    {
        doRefresh()
    }
    
    func doRefresh()
    {
        if !Operations.refreshing
        {
            DispatchQueue.global(qos: .background).async {
                Operations.refreshing = true
                SharedData.eventList = NetHandler.getEvents()
                Operations.refreshing = false
                self.mapView.removeAnnotations(self.mapView.annotations)
                
                for entry in SharedData.eventList
                {
                    let coords = CLLocationCoordinate2D(latitude: entry.latitude, longitude: entry.longitude)
                    
                    let point = MKPointAnnotation()
                    
                    point.coordinate = coords
                    point.title = entry.name
                    
                    self.mapView.addAnnotation(point)
                }
            }
        }
    }
}
