//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by CS193p Instructor.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell
{
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI()
    {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet
        {
            let myAttributedString = NSMutableAttributedString(string: tweet.text)
            
            for hashtag in tweet.hashtags {
                myAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.orange, range: hashtag.nsrange)
            }
            
            for url in tweet.urls {
                myAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue, range: url.nsrange)
            }
            
            for user in tweet.userMentions {
                myAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.green, range: user.nsrange)
            }
            tweetTextLabel?.attributedText = myAttributedString
            
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            
            
            
            if let profileImageURL = tweet.user.profileImageURL {
                if let imageData = try? Data(contentsOf: profileImageURL) { // blocks main thread!
                    tweetProfileImageView?.image = UIImage(data: imageData)
                }
            }
            
            
            let formatter = DateFormatter()
            if  Date().timeIntervalSince(tweet.created) > 24*60*60 {
                formatter.dateStyle = DateFormatter.Style.short
            } else {
                formatter.timeStyle = DateFormatter.Style.short
            }
            tweetCreatedLabel?.text = formatter.string(from: tweet.created)
        }
        
    }
    
}
