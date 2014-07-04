//
//  TweetTableViewCell.h
//  ios_twitter
//
//  Created by Stanley Ng on 7/3/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class TweetTableViewCell;

@protocol TweetTableViewCellDelegate <NSObject>
- (void)updateFromTweetTableViewCell:(TweetTableViewCell *)cell update:(Tweet *)tweet index:(NSInteger)index;
@end

@interface TweetTableViewCell : UITableViewCell
@property (nonatomic, weak) id <TweetTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetedViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetedViewMarginTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIImageView *retweetedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusTextLabel;
@property (weak, nonatomic) IBOutlet UIView *retweetedView;
@property (assign, atomic) NSInteger index;
@property (strong, atomic) Tweet* tweet;
- (void)configure;
@end
