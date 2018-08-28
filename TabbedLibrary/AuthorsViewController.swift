//
//  AuthorsViewController.swift
//  BookAuthorsNavController
//
//  Created by Kastel, Lynette on 9/26/17.
//  Copyright © 2017 Kastel, Lynette. All rights reserved.
//

import UIKit

class AuthorsViewController: UITableViewController {
    
    var authors = [AnyObject]()
    // Constant for the cell reuse identifier
    let CellIdentifier = "Cell Identifier"
    // Constant for identifier given the Show segue from AuthorsViewController to BooksViewController
    let SegueBooksViewController = "BooksViewController"

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // initialize Tab Bar item
        tabBarItem = UITabBarItem(title: "Authors", image: UIImage(named: "icon-authors"), tag: 0)
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let filePath = Bundle.main.path(forResource: "Books", ofType: "plist")
        
        if let path = filePath {
            // Initialize authors array with the contents of the file
            authors = NSArray(contentsOfFile: path)! as [AnyObject]
            // Uncomment new line to test authors array contents
            //print(authors)
        }
        
        // UITableView's register(forClass:forCellReuseIdentifier:)
        // registers a new class for use in creating a new table cells
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellIdentifier)
        
        // Uncomment next line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment next line to display an Edit button in the nav bar for this view controller
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }


    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return authors.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
        // Configure the cell
        //
        // Ask authors array for its element at the indexPath.row & downcast it to a dictionary, type [String: AnyObject]
        // Ask author dictionary for the "Author" key's value & downcast to a string
        // Note: Chaining optional bindings with a comma allows avoidance of nested "if statements"
        if let author = authors[indexPath.row] as? [String: AnyObject], let name = author["Author"] as? String {
            // Populate this row's cell
            cell.textLabel?.text = name
        }
        return cell
    }
 
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }*/

    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }*/

    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    }*/

    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }*/
    
    
    // The following method is defined in the UITableViewDelegate protocol and is
    //    required to use the show segue from AuthorsViewController to BooksViewController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Perform the Show (push) segue
        //
        // Initiate it with the specified identifier from the current (self) vc's storyboard file
        performSegue(withIdentifier: SegueBooksViewController, sender: self)
        
        // De-select the given row ID'd by indexPath w/an option to animate the de-selection.
        // Reset the selection after performing the segue.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Navigation

    // Prep before navigation (in a storyboard-based app)
    //
    // Get the new VC (using segue.destinationViewController) & pass the selected object to it.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Check if the segue's identifier is what you expect it to be
        if segue.identifier == SegueBooksViewController {
            
            // Ask the table view for the index path of the current row selected using optional binding (if-let).
            // If a row has been selected, obtain the author (dictionary) that corresponds to it (from authors array)
            if let indexPath = tableView.indexPathForSelectedRow, let author = authors[indexPath.row] as? [String: AnyObject] {
                
                // Get a reference to the destination VC for this segue (BooksViewController).
                // Set its author property to the author currently selected in the table view (from 2nd part of binding chain)
                (segue.destination as! BooksViewController).author = author
                
                // Longhand alt code to above task...
                // let destinationViewController = segue.destination as! BooksViewController
                // destinationViewController.author = author
            }
        }
    }
}
