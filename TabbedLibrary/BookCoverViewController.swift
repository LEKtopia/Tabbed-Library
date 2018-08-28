//
//  BookCoverViewController.swift
//  BookAuthorsNavController
//
//  Created by Kastel, Lynette on 10/12/17.
//  Copyright © 2017 Kastel, Lynette. All rights reserved.
//

import UIKit

class BookCoverViewController: UIViewController {

    @IBOutlet var bookCoverView: UIImageView!
    
    var book: [String: String]?
    
    lazy var bookCoverImage: UIImage? = {
        var image: UIImage?
        
        // If the book property is nil, select a random book from the books stored in Books.plist
        if self.book == nil {
            
            // Initialize a buffer
            var buffer = [AnyObject]()
            let filePath = Bundle.main.path(forResource: "Books", ofType: "plist")
            
            if let path = filePath {
                let authors = NSArray(contentsOfFile: path)! as [AnyObject]
                
                for author in authors {
                    if let books = author["Books"] as? [AnyObject] {
                        buffer += books
                    }
                }
            }
            
            if buffer.count > 0 {
                let random = Int(arc4random()) % buffer.count
                
                if let book = buffer[random] as? [String: String] {
                    self.book = book 
                }
            }
        }
        
        // If the book property has a value, display its book cover
        if let book = self.book, let fileName = book["Cover"] {
            image = UIImage(named: fileName)
        }
        return image
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // initialize Tab Bar item
        tabBarItem = UITabBarItem(title: "Cover", image: UIImage(named: "icon-cover"), tag: 2)
    }
    
     
    override func viewDidLoad() {
        super.viewDidLoad()

        // FIXME: shouldn't crash when switching tabs in tab bar
        // FIXME: should highlight tabs on click and switch to associated table views
        /*
        // Configure the Image View
        //
        // Ask the book property for the value stored in the element whose key is "Cover"
        if let fileName = book?["Cover"] {
            
            // Instantiate a UIImage object by invoking the init(name:) initializer passing it the file name of the image.
            // Then, assign the UIImage instance to the image property of the UIImageView bookCoverView.
            bookCoverView.image = UIImage(named: fileName)
            
            // Access the contentMode property, which is of type UIViewContentMode (enumeration)
            // Set it to a value that tells the image view to stretch the image as much as possible while respecting its aspect ratio.
            bookCoverView.contentMode = .scaleAspectFit
            
            if let bookTitle = book?["Title"] {
                title = bookTitle
            }
        }*/
        
        // Update the image view of book cover view controller
        if let bookCoverImage = bookCoverImage {
            bookCoverView.image = bookCoverImage
            bookCoverView.contentMode = .scaleAspectFill
        }
    }
}
