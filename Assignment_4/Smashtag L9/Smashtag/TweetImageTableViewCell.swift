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
    
    /*
    private func updateUI() {
        myImageView.image = nil
        if let url = mediaItem?.url {
            DispatchQueue.global(qos: .userInitiated).async {
                let contentOfURL = NSData(contentsOf: url)
                DispatchQueue.main.async { weak weakSelf = self
                    if url == mediaItem?.url {
                        if let imageData = contentOfURL {
                            weakSelf.anImage = UIImage(data: imageData as Data)
                        }
                    } else {
                        print("Ignored data from returned url \(url)")
                    }
                }
                
            }
            
            
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
 
 */
    
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
