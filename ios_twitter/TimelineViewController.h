//
//  TimelineViewController.h
//  ios_twitter
//
//  Created by Stanley Ng on 6/29/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeViewController.h"
#import "TweetTableViewCell.h"

@interface TimelineViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate, TweetTableViewCellDelegate>

@end
