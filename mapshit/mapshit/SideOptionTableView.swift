//
//  SideOptionTableView.swift
//  mapshit
//
//  Created by juran_k on 4/14/17.
//  Copyright © 2017 juran_k. All rights reserved.
//

import UIKit
import CoreData
class SideOptionTableView: UITableView {
    var locations : [Location] = []
    
    func addCellsToTable() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        fetchRequest.predicate = NSPredicate(format: "isFavorited == %@", argumentArray: ["true"])
        do {
            locations = try context.fetch(fetchRequest) as! [Location]
            //            print(locations)
            
            self.beginUpdates()
            self.insertRows(at: [IndexPath(row: locations.count-1, section: 0)], with: .automatic)
            self.endUpdates()
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
    
   
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locations.count
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
