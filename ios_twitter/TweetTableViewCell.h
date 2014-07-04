//
//  TweetTableViewCell.h
//  ios_twitter
//
//  Created by Stanley Ng on 7/3/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusTextLabel;

@end
