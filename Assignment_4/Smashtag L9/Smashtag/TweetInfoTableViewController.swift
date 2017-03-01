//
//  TweetInfoTableViewController.swift
//  Smashtag
//
//  Created by Nikita Litvinov on 27.02.17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class TweetInfoTableViewController: UITableViewController {
    
    enum Section {
        case Image (count : Int, images: [Twitter.MediaItem])
        case Hashtag (count : Int, items : [String])
        case User (count : Int, items : [String])
        case URL (count : Int, items : [String])
        
        var count : Int {
            switch self {
            case .Image(let count, _),
                 .URL(let count, _),
                 .Hashtag(let count, _),
                 .User(let count, _): return count
            }
        }
        
        var name : String {
            switch self {
            case .Image: return "Images"
            case .URL: return "URLs"
            case .Hashtag: return "Hashtags"
            case .User: return "Users"
            }
        }
        
        var cellIdentifier : String {
            switch self {
            case .Image: return Storyboard.ImageCellIdentifier
            case .URL: return Storyboard.URLCellIdentifier
            case .Hashtag: return Storyboard.HashtagCellIdentifier
            case .User: return Storyboard.UserCellIdentifier
            }
        }
    }
    
    private var dataModel = [Section]()
    
    var tweet : Twitter.Tweet? {
        get { return nil }
        
        set {
            if let tweet = newValue {
                self.navigationItem.title = tweet.user.name
                
                if tweet.media.count > 0 { dataModel.append(.Image(count: tweet.media.count, images: tweet.media)) }
                if tweet.urls.count > 0 { dataModel.append(.URL(count: tweet.urls.count, items: getItems(tweetText: tweet.text, byMentions: tweet.urls))) }
                if tweet.hashtags.count > 0 { dataModel.append(.Hashtag(count: tweet.hashtags.count, items: getItems(tweetText: tweet.text, byMentions: tweet.hashtags))) }
                if tweet.userMentions.count > 0 { dataModel.append(.User(count: tweet.userMentions.count, items: getItems(tweetText: tweet.text, byMentions: tweet.userMentions))) }
            }
            tableView.reloadData()
        }
    }
    
    func getItems(tweetText tweet: String, byMentions mentions: [Mention]) -> [String] {
        var result = [String]()
        
        for mention in mentions {
            result.append(mention.keyword)
        }
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = tableView.rowHeight
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataModel.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: dataModel[indexPath.section].cellIdentifier, for: indexPath)
        
        switch dataModel[indexPath.section] {
        case .Hashtag(_, let items),
             .URL(_, let items),
             .User(_, let items):
            cell.textLabel?.text = items[indexPath.row]
            return cell
        case .Image (_, let images):
            if let imageCell = cell as? TweetImageTableViewCell {
                imageCell.mediaItem = images[indexPath.row]
                return imageCell
            }
        }
        
        // Configure the cell...
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataModel[section].name
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch dataModel[indexPath.section] {
        case .Image(_, let images):
            return tableView.bounds.size.width / CGFloat(images[indexPath.row].aspectRatio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    
    // MARK: Constants
    
    private struct Storyboard {
        static let ImageCellIdentifier = "Image"
        static let UserCellIdentifier = "User"
        static let HashtagCellIdentifier = "Hashtag"
        static let URLCellIdentifier = "URL"
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension NSRange {
    func range(for str: String) -> Range<String.Index>? {
        guard location != NSNotFound else { return nil }
        
        guard let fromUTFIndex = str.utf16.index(str.utf16.startIndex, offsetBy: location, limitedBy: str.utf16.endIndex) else { return nil }
        guard let toUTFIndex = str.utf16.index(fromUTFIndex, offsetBy: length, limitedBy: str.utf16.endIndex) else { return nil }
        guard let fromIndex = String.Index(fromUTFIndex, within: str) else { return nil }
        guard let toIndex = String.Index(toUTFIndex, within: str) else { return nil }
        
        return fromIndex ..< toIndex
    }
}
