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
    
    var resultJSON : String = "" {
        didSet {
            print("setting output")
            jsonOutputLabel.text = resultJSON
            parseJSONResponse(resultJSON)
        }
    }
    
    func parseJSONResponse( json : String ) -> Void {
        artists.append("Foo Fighters")
        artists.append("The Beatles")
        tableView.reloadData()
    }
    
    var artists : [String] = []
    
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

    @IBAction func search(sender: AnyObject) {
        if let searchTerm = searchText.text {
            
            let url = NSURL(string: "https://ws.spotify.com/search/1/album.json?q=\(searchTerm)")
            
            let request = NSMutableURLRequest(URL: url!)
            
            httpGet(request){
                (data, error) -> Void in
                if error != nil {
                    //self.jsonOutputLabel.text = error
                    print(error)
                } else {
                    // SUPER IMPORTANT!
                    dispatch_async(dispatch_get_main_queue(), {
                        self.resultJSON = data
                    })
                    //self.jsonOutputLabel.text = data
                    //print(data)
                }
            }
            
        }
    }
    
    func httpGet(request: NSURLRequest!, callback: (String, String?) -> Void) {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if error != nil {
                callback("", error!.localizedDescription)
            } else {
                let result = NSString(data: data!, encoding:
                    NSASCIIStringEncoding)!
                callback(result as String, nil)
            }
        }
        task.resume()
    }

}

