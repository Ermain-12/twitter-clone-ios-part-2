//
//  HomeTableTableViewController.swift
//  Twitter
//
//  Created by Ermain Paul on 2/23/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
	
	var tweetArray = [NSDictionary]()
	var numberOfTweets: Int!
	let myRefreshControl = UIRefreshControl()
	

    override func viewDidLoad() {
        super.viewDidLoad()
		loadTweets()
		myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
		tableView.refreshControl = myRefreshControl
		self.tableView.rowHeight = UITableView.automaticDimension
		self.tableView.estimatedRowHeight = 200
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.loadTweets()
	}
	
	@objc func loadTweets() -> Void {
		numberOfTweets = 20
		let apiURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
		let myParams = ["count": numberOfTweets]
		
		TwitterAPICaller.client?.getDictionariesRequest(url: apiURL, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in
			self.tweetArray.removeAll()
			
			for tweet in tweets {
				self.tweetArray.append(tweet)
			}
			self.tableView.reloadData()
			self.myRefreshControl.endRefreshing()
		}, failure: { (Error) in
			print("Error: Unable to retrieve tweets.")
		})
	}
	
	func loadMoreTweets() -> Void {
		let apiURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
		numberOfTweets = numberOfTweets + 20

		let myParams = ["count": numberOfTweets]
		TwitterAPICaller.client?.getDictionariesRequest(url: apiURL, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in
			self.tweetArray.removeAll()

			for tweet in tweets {
				self.tweetArray.append(tweet)
			}
			self.tableView.reloadData()
			// self.myRefreshControl.endRefreshing()
		}, failure: { (Error) in
			print("Error: Unable to retrieve tweets.")
		})
	}


	@IBAction func onLogOut(_ sender: Any) {
		TwitterAPICaller.client?.logout()
		self.dismiss(animated: true, completion: nil)
		UserDefaults.standard.set(false, forKey: "userLoggedIn")
	}
	
}

extension HomeTableViewController {
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
		
		let user = tweetArray[indexPath.row]["user"] as! NSDictionary
		
		
		cell.usernameLabel.text = user["name"] as? String
		cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
		
		// Setting the user image
		let imageURL = URL(string: (user["profile_image_url_https"] as? String)!)
		let data = try? Data(contentsOf: imageURL!)
		if let imageData = data {
			cell.profileImageView.image = UIImage(data: imageData)
		}
		
		cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
		cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
		cell.setRetweet(tweetArray[indexPath.row]["retweeted"] as! Bool)
		return cell
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return tweetArray.count
	}

	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.row + 1 == tweetArray.count {
			loadMoreTweets()
		}
	}
}
