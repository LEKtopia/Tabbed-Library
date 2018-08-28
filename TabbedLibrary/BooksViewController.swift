//
//  BooksViewController.swift
//  BookAuthorsNavController
//
//  Created by Kastel, Lynette on 9/28/17.
//  Copyright © 2017 Kastel, Lynette. All rights reserved.
//

import UIKit

class BooksViewController: UITableViewController {
    
    var author: [String: AnyObject]?
    let CellIdentifier = "Cell Identifier"
    let SegueBookCoverViewController = "BookCoverViewController"
    
    /*
    // Define a computed property named books. A computed property doesn't store a value. It defines a getter (and potentially a setter) for getting and setting the value of the property.
    var books: [AnyObject] {
        get {
            if let books = author["Books"] as? [AnyObject] {
                return books
            }
            // empty array of values of type AnyObject
            return [AnyObject]()
        }
    }*/
    
    // Assign a closure (computed property) to the books property (vs an ordinary value), which holds no value and ends with ()'s, indicating that it's executed when books is accessed for the first time.
    lazy var books: [AnyObject] = {
        
        // Create an empty buffer array of type [AnyObject]
        var buffer = [AnyObject]()
        
        // If author is NOT nil, load the author's books property to the buffer
        if let author = self.author, let books = author["Books"] as? [AnyObject] {
            buffer += books
        } else {
            // load Books.plist first, then add every book from every author to the buffer
            let filePath = Bundle.main.path(forResource: "Books", ofType: "plist")
            
            if let path = filePath {
                let authors = NSArray(contentsOfFile: path)! as [AnyObject]
                
                for author in authors {
                    if let books = author["Books"] as? [AnyObject] {
                        buffer += books
                    }
                }
            }
        }
        return buffer
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // initialize Tab Bar item
        tabBarItem = UITabBarItem(title: "Books", image: UIImage(named: "icon-books"), tag: 1)
        tabBarItem.badgeValue = "8"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set this vc's title to the name of the Author that was selected in the Authors VC table view.
        if let author = author, let name = author["Author"] as? String {
            title = name
        } else {
            title = "Books"
        }
        
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellIdentifier)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    //
    // MARK: - Table view Data Source
    //
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
        // Configure the cell
        if let book = books[indexPath.row] as? [String: String], let title = book["Title"] {
            cell.textLabel?.text = title
        }
        return cell
    }
    

    /*
    // Override to support table view conditional editing.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }*/

    
    /*
    // Override to support table view editing.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }*/

    
    /*
    // Override to support table view re-arranging.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    }*/

    /*
    // Override to support table view conditional rearranging.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }*/
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Perform segue & de-select the table row
        performSegue(withIdentifier: SegueBookCoverViewController, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Navigation
    
    // Prep before navigation (in a storyboard-based app)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Check if the segue's identifier is what you expect it to be
        if segue.identifier == SegueBookCoverViewController {
            
            // Ask the table view for the index path of the current row selected.
            // Get the book that corresponds with the selected row (from books array)
            if let indexPath = tableView.indexPathForSelectedRow, let book = books[indexPath.row] as? [String: String] {
                
                // Get the new VC (using segue.destinationViewController) & pass the selected object (book) to it.
                let destinationViewController = segue.destination as! BookCoverViewController
                destinationViewController.book = book
            }
        }
    }
}
