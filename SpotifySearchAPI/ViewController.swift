//
//  ViewController.swift
//  SpotifySearchAPI
//
//  Created by Brandon Rich2 on 10/31/15.
//  Copyright © 2015 Infinite Donuts. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var jsonOutputLabel: UILabel!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var artists : [String] = []  // model for table view
    var resultJSON : String = "" {
        didSet {
            print("setting output as \(resultJSON)")
            jsonOutputLabel.text = resultJSON
        }
    }
    
    func parseJSONResponse( data : NSData ) -> Void {
        let json = JSON(data: data)
        artists.removeAll()
        for (_, artist) in json["artists"]["items"] {   // using _ in place of key because I don't care about the key (actually the index)
            artists.append(artist["name"].stringValue)
        }
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArtistCell", forIndexPath: indexPath)
        cell.textLabel?.text = artists[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // See https://medium.com/swift-programming/learn-nsurlsession-using-swift-ebd80205f87c#.unry3xlo6
    @IBAction func search(sender: AnyObject) {
        if let searchTerm = searchText.text {
            
            let url = NSURL(string: "https://api.spotify.com/v1/search?type=artist&q=\(searchTerm)")
            let request = NSMutableURLRequest(URL: url!)
            
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request){
                (data, responseText, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    let result = NSString(data: data!, encoding:
                        NSASCIIStringEncoding)!
                    dispatch_async(dispatch_get_main_queue(), {
                        self.resultJSON = result as String
                        self.parseJSONResponse(data!)
                    })
                    
                }
            }
            task.resume()
            
        }
    }
    
    
   
}

