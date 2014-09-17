//
//  ViewController.swift
//  Rotten Tomatoes
//
//  Created by Kumar, Chandaraprakash on 9/13/14.
//  Copyright (c) 2014 chantech. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {

    @IBOutlet weak var movieSearch: UISearchBar!
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var moviesArray : [NSDictionary] = []
    var searchArray : [NSDictionary] = []
    var hud = MBProgressHUD()
    var refreshControl: UIRefreshControl!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.movieTableView.dataSource = self;
        self.movieTableView.delegate = self;
        
        
        
        hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.show(true)

        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.movieTableView!.addSubview(refreshControl)
        
        self.loadData(self)
        
        self.hud.hide(true)
     
    }
    
    func loadData(sender: AnyObject) {
        self.hud.show(true)
        let manager = AFHTTPRequestOperationManager()
        manager.GET(
            "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=cc5uyf9hm283kaawm2xvgevw",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                
                let YourApiKey = "cc5uyf9hm283kaawm2xvgevw"
                let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=" + YourApiKey
                let request = NSMutableURLRequest(URL: NSURL.URLWithString(RottenTomatoesURLString))
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
                    var errorValue: NSError? = nil
                    let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
                    print("error:::: \(error)")
                    self.moviesArray = dictionary["movies"] as [NSDictionary]
                    
                    
                    self.movieTableView.reloadData()
                    
                    self.refreshControl.endRefreshing()
                    self.hud.hide(true)
                    
                })
                
                
            },
            failure: { (operation: AFHTTPRequestOperation!,
                err: NSError!) in
                println("Error: " + err.localizedDescription)
                
                TSMessage.showNotificationInViewController(
                    self,
                    title: "Network Error",
                    subtitle: "",
                    type: TSMessageNotificationType.Error,
                    duration: NSTimeInterval(2.0),
                    canBeDismissedByUser: false
                )
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = movieTableView.dequeueReusableCellWithIdentifier("MovieCell") as MovieTableViewCell
        var movie = moviesArray[indexPath.row] as NSDictionary
        
        cell.movieTitleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String

        var poster = movie["posters"] as NSDictionary
        var posterUrl = poster["thumbnail"] as String
        cell.posterView.setImageWithURL(NSURL(string: posterUrl))
        

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailsScene" {
            let indexPath = self.movieTableView.indexPathForSelectedRow()
            (segue.destinationViewController as MovieDetailsViewController).detailItem = moviesArray[indexPath!.row]
        }
    }

}

