//
//  MovieDetailsViewController.swift
//  Rotten Tomatoes
//
//  Created by Kumar, Chandaraprakash on 9/16/14.
//  Copyright (c) 2014 chantech. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    
    @IBOutlet weak var synopsisDetailLabel: UILabel!
    @IBOutlet weak var posterDetailImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        if let dict = detailItem as? NSDictionary {
            self.title = dict["title"] as? String
            if let label =  synopsisDetailLabel {
                label.text = dict["synopsis"] as? String
                label.sizeToFit()
                scrollView.contentSize = CGSize(width: 320.0, height: CGRectGetMaxY(label.frame) + 144.0)
                
            }
            
            if let view = posterDetailImage {
                if let posters = dict["posters"] as? NSDictionary {
                    if let thumb = posters["thumbnail"] as? String {
                        view.image = UIImage(data: NSData(contentsOfURL: NSURL(string: thumb)))
                        let original = thumb.stringByReplacingOccurrencesOfString("tmb", withString: "ori", options: NSStringCompareOptions.LiteralSearch, range: nil)
                        let request = NSURLRequest(URL: NSURL(string: original))
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { response, data, error in
                            UIView.transitionWithView(view, duration: 1.0, options: .TransitionCrossDissolve, animations: {
                                view.image = UIImage(data: data)
                                }, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
