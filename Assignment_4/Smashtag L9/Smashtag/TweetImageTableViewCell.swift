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
    
    var anImage : UIImage? {
        get { return myImageView?.image }
        
        set {
            myImageView.image = newValue
            //myImageView.sizeToFit()
            self.frame.size.height = (myImageView.image?.size.height)!
            print("image height = \(myImageView.image?.size.height), width = \(myImageView.image?.size.width)")
            print("cell height = \(self.frame.height), width = \(self.frame.width)")
        }
    }
    var mediaItem : MediaItem? {
        didSet {
            updateUI()
        }
    }
    
    
    private func updateUI() {
        myImageView.image = nil
        if let url = mediaItem?.url {
            if let imageData = NSData(contentsOf: url) {
                myImageView.image = UIImage(data: imageData as Data)
                print("cell height = \(self.frame.height), width = \(self.frame.width)")
                self.frame.size.height = (myImageView.image?.size.height)!
                print("image height = \(myImageView.image?.size.height), width = \(myImageView.image?.size.width)")
                print("cell height = \(self.frame.height), width = \(self.frame.width)")
                self.setNeedsDisplay()
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
