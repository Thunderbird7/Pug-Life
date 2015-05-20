//
//  PugTableViewCell.swift
//  Pugs Life
//
//  Created by Yuttana Kungwon on 5/19/2558 BE.
//  Copyright (c) 2558 E-Commerce Solution Co., Ltd. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PugTableViewCell: PFTableViewCell {

    @IBOutlet weak var pugImageView: UIImageView!
    @IBOutlet weak var lblCaption: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblVotes: UILabel!
    @IBOutlet weak var pawLikeIcon: UIImageView!
    
    var parseObject: PFObject?
    var voted: Bool? = false
    
    override func awakeFromNib() {
        
        pawLikeIcon.hidden = true
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: Selector("onDoubleTap:"))
        doubleTapGesture.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(doubleTapGesture)
        
        super.awakeFromNib()
        // Initialization code
    }

    func onDoubleTap(sender:AnyObject) {
        
        if(parseObject != nil) {
            if(voted == false) {
                if var votesCount:Int? = parseObject!.objectForKey("votes") as? Int {
                    votesCount!++
                    
                    parseObject!.setObject(votesCount!, forKey: "votes")
                    parseObject!.saveInBackground()
                    
                    lblVotes.text = "\(votesCount!) votes"
                    
                    voted = true
                }
                
                pawLikeIcon.hidden = false
                pawLikeIcon.alpha = 1.0
                
                UIView.animateWithDuration(1.0, delay: 0.5, options: nil, animations: { () -> Void in
                    self.pawLikeIcon.alpha = 0.0
                    }) { (Bool) -> Void in
                        self.pawLikeIcon.hidden = true
                }
                
            } else {
                if var votesCount:Int? = parseObject!.objectForKey("votes") as? Int {
                    votesCount!--
                    
                    parseObject!.setObject(votesCount!, forKey: "votes")
                    parseObject!.saveInBackground()
                    
                    lblVotes.text = "\(votesCount!) votes"
                    
                    voted = false
                }
            }
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
