//
//  ComposeViewController.h
//  ios_twitter
//
//  Created by Stanley Ng on 6/29/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class ComposeViewController;

@protocol ComposeViewControllerDelegate <NSObject>
- (void)updateFromComposeView:(ComposeViewController *)controller update:(Tweet *)tweet;
@end

@interface ComposeViewController : UIViewController
@property (nonatomic, weak) id <ComposeViewControllerDelegate> delegate;
@end
