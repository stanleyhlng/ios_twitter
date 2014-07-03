//
//  TweetViewController.h
//  ios_twitter
//
//  Created by Stanley Ng on 6/29/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeViewController.h"
#import "Tweet.h"

@interface TweetViewController : UIViewController<ComposeViewControllerDelegate>
@property(strong, nonatomic) Tweet* tweet;
@end
