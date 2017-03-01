//
//  TweetImageTableViewCell.swift
//  Smashtag
//
//  Created by Nikita Litvinov on 28.02.17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class TweetImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var anImage : UIImage? {
        get { return myImageView?.image }
        
        set {
            myImageView.image = newValue
            myImageView.sizeToFit()
            spinner.stopAnimating()
        }
    }
    var mediaItem : MediaItem? {
        didSet {
            myImageView.image = nil
            if myImageView.window != nil {
                fetchImage()
                self.setNeedsDisplay()
            }
        }
    }

    
    func fetchImage() {
        if let url = mediaItem?.url {
            spinner?.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async {
                let contentsOfURL = NSData(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = contentsOfURL {
                        self.myImageView.image = UIImage(data: imageData as Data)
                    } else {
                        self.spinner?.stopAnimating()
                    }
                }
            }
        }
    }
    
    
    /*
     override func awakeFromNib() {
     super.awakeFromNib()
     // Initialization code
     }
     
     override func setSelected(_ selected: Bool, animated: Bool) {
     super.setSelected(selected, animated: animated)
     
     // Configure the view for the selected state
     }*/
    
}
