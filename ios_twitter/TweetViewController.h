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

@class TweetViewController;

@protocol TweetViewControllerDelegate <NSObject>
- (void)updateFromTweetView:(TweetViewController *)controller update:(Tweet *)tweet index:(NSInteger)index;
@end

@interface TweetViewController : UIViewController<ComposeViewControllerDelegate>
@property (nonatomic, weak) id <TweetViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) Tweet* tweet;
@end
