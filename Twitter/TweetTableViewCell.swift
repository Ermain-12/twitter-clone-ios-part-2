//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Ermain Paul on 2/24/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var retweetButton: UIButton!
	@IBOutlet weak var tweetContent: UILabel!
	@IBOutlet weak var favoriteButton: UIButton!
	
	var favorite: Bool = false
	var tweetId: Int = -1
	var retweeted: Bool = false
	
	func setFavorite(_ isFavorite: Bool) -> Void {
		favorite = isFavorite
		if (favorite) {
			favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
		}
		else {
			favoriteButton.setImage(UIImage(named: "favor-icon 2"), for: UIControl.State.normal)
		}
	}
	
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	@IBAction func favoriteTweet(_ sender: Any) {
		let toBeFavorited = !favorite
		if (toBeFavorited) {
			TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
				self.setFavorite(true)
			}, failure: { (error) in
				print("Error: \(error)")
			})
		} else {
			TwitterAPICaller.client?.unfavorite(tweetId: tweetId, success: {
				self.setFavorite(false)
			}, failure: { (Error) in
				print("Error: \(Error)")
			})
		}
	}
	
	@IBAction func retweet(_ sender: Any) {
		TwitterAPICaller.client?.rewteet(tweetId: tweetId, success: {
			self.setRetweet(true)
		}, failure: { (error) in
			print("Error: \(error)")
		})
	}
	
	func setRetweet(_ isRetweeted: Bool) {
		if (isRetweeted) {
			retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
			retweetButton.isEnabled = false
		} else {
			retweetButton.isEnabled = true
		}
	}
	override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
