//
//  EntryCell.swift
//  Swagslist
//
//  Created by Aidan Brady on 9/24/16.
//  Copyright © 2016 Aidan Brady. All rights reserved.
//

import UIKit

class EntryCell:UITableViewCell
{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var promotedIcon: UIImageView!
    
    @IBOutlet weak var apparelIcon: UIImageView!
    @IBOutlet weak var foodIcon: UIImageView!
    @IBOutlet weak var trinketsIcon: UIImageView!
    
    var controller:MapController?
    
    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        if controller != nil && selected
        {
            controller!.navigationController!.popViewControllerAnimated(true)
            controller!.newController!.setList(list!)
        }
    }
}
