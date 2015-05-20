//
//  PugTableViewController.swift
//  Pugs Life
//
//  Created by Yuttana Kungwon on 5/19/2558 BE.
//  Copyright (c) 2558 E-Commerce Solution Co., Ltd. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import ImageLoader

class PugTableViewController: PFQueryTableViewController {
    
    let cellIdentifier:String = "pugCell"
    
    override init(style: UITableViewStyle, className: String?) {
        
        super.init(style: style, className: className)
        
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.objectsPerPage = 10
        self.parseClassName = className
        self.tableView.rowHeight = 350
        self.tableView.allowsSelection = false
    }

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.registerNib(UINib(nibName: "PugTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func queryForTable() -> PFQuery {
        var query: PFQuery = PFQuery(className: self.parseClassName!)
        
        if(objects?.count == 0) {
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
        }
        
        query.orderByDescending("createdAt")
        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {

        var cell:PugTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PugTableViewCell
        
        // send parse object reference
        // from tableview to tableview cell
        cell.parseObject = object

        if let pfObject = object {
            cell.lblAuthor.text = pfObject["cc_by"] as? String
            
            var captionStr:String! = pfObject["caption"] as? String
            if captionStr != nil {
                cell.lblCaption.text = "\" \(captionStr) \""
            }
            
            var votes:Int! = pfObject["votes"] as! Int
            if votes == nil {
                votes = 0
            }
            cell.lblVotes.text = "\(votes!) votes"
            
            cell.pugImageView.image = nil
            
            if var urlString:String? = pfObject["image_url"] as? String {
                
                /* 
                // Use GCD
                var url:NSURL! = NSURL(string: urlString!)
                var imageData:NSData!

                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
                    imageData = NSData(contentsOfURL: url!)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        cell?.pugImageView?.image = UIImage(data: imageData!)
                    })
                })
                */
                cell.pugImageView.load(urlString!)
            }
        }
        
        return cell;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
