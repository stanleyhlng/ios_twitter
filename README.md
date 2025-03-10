ios_twitter
===========

Twitter iOS App

Build a simple Twitter client that supports viewing a Twitter timeline and composing a new tweet.

## Walkthrough of all user stories

[![image](https://raw.githubusercontent.com/wiki/stanleyhlng/ios_twitter/assets/ios_twitter.gif)](https://raw.githubusercontent.com/wiki/stanleyhlng/ios_twitter/assets/ios_twitter.gif)

## Completed user stories

 * [x] User can sign in using OAuth login flow
 * [x] User can view last 20 tweets from their home timeline
 * [x] The current signed in user will be persisted across restarts
 * [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp. In other words, design the custom cell with the proper Auto Layout settings. You will also need to augment the model classes.
 * [x] User can pull to refresh
 * [x] User can compose a new tweet by tapping on a compose button.
 * [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
 * [x] Optional: When composing, you should have a countdown in the upper right for the tweet limit.
 * [x] Optional: After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
 * [x] Optional: Retweeting and favoriting should increment the retweet and favorite count.
 * [x] Optional: User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
 * [x] Optional: Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
 * [x] Optional: User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

## Time spent
30 hours spent in total

## Libraries
```
platform :ios, '7.0'

pod 'AFNetworking', '~> 2.2.0'
pod 'GSProgressHUD', '~> 0.2'
pod 'Reveal-iOS-SDK', '~> 1.0.4'
pod 'SDWebImage', '~> 3.6'
pod 'UIActivityIndicator-for-SDWebImage', '~> 1.0.5'
pod 'AVHexColor', '~> 1.2.0'
pod 'BDBOAuth1Manager', '~> 1.2.1'
pod 'Mantle', '~> 1.5'
pod 'DateTools', '~> 1.3.0'
```
