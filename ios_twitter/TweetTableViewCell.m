//
//  TweetTableViewCell.m
//  ios_twitter
//
//  Created by Stanley Ng on 7/3/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "TweetTableViewCell.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TweetTableViewCell()
- (void)setupReplyButton;
- (void)setupRetweetButton;
- (void)setupFavoriteButton;
- (void)setupProfileImageView;
- (void)setupRetweetImageView;
- (void)setupNameLabel;
- (void)setupRetweetLabel;
- (void)setupScreenNameLabel;
- (void)setupStatusTextLabel;
- (void)setupRetweetView;
@end

@implementation TweetTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    self.statusTextLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.statusTextLabel.frame);
}

- (void)configure
{
    if (self.tweet == nil) {
        return;
    }
    
    //[self setupRetweetView];
    
    [self setupProfileImageView];
    
    [self setupNameLabel];
    [self setupScreenNameLabel];
    
    [self setupStatusTextLabel];
    
    [self setupReplyButton];
    [self setupRetweetButton];
    [self setupFavoriteButton];
}

- (void)setupReplyButton
{
    UIImage *image = [UIImage imageNamed:@"icon-reply"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.replyButton setImage:image forState:UIControlStateNormal];
    self.replyButton.tintColor = [UIColor lightGrayColor];
}

- (void)setupRetweetButton
{
    UIImage *image = [UIImage imageNamed:@"icon-retweet"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.retweetButton setImage:image forState:UIControlStateNormal];
    self.retweetButton.tintColor = [UIColor lightGrayColor];
}

- (void)setupFavoriteButton
{
    UIImage *image = [UIImage imageNamed:@"icon-favorite"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.favoriteButton setImage:image forState:UIControlStateNormal];
    self.favoriteButton.tintColor = [UIColor lightGrayColor];
}

- (void)setupProfileImageView
{
    User *user = self.tweet.user;
    if (self.tweet.retweetedStatus != nil) {
        user = self.tweet.retweetedStatus.user;
    }

    NSURL *url = user.profileImageUrl;
    UIImage *placeholder = [UIImage imageNamed:@"profile"];
    
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = 5.0f;
    self.profileImageView.alpha = 0.5f;
    
    [self.profileImageView setImageWithURL:url
                          placeholderImage:placeholder
                                   options:SDWebImageRefreshCached
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                                     // Fade in image
                                     [UIView beginAnimations:@"fade in" context:nil];
                                     [UIView setAnimationDuration:0.5];
                                     [self.profileImageView setAlpha:1.0f];
                                     [UIView commitAnimations];
                                 }
               usingActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
}

- (void)setupRetweetImageView
{
    UIImage *image = [UIImage imageNamed:@"icon-retweet"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.retweetedImageView.image = image;
    self.retweetedImageView.tintColor = [UIColor lightGrayColor];
}

- (void)setupNameLabel;
{
    User *user = self.tweet.user;
    if (self.tweet.retweetedStatus != nil) {
        user = self.tweet.retweetedStatus.user;
    }
    
    self.nameLabel.text = user.name;
}

- (void)setupRetweetLabel
{
    User *user = self.tweet.user;
    self.retweetLabel.text = [user.name stringByAppendingString:@" retweeted"];
    self.retweetLabel.textColor = [UIColor lightGrayColor];
}

- (void)setupScreenNameLabel
{
    User *user = self.tweet.user;
    if (self.tweet.retweetedStatus != nil) {
        user = self.tweet.retweetedStatus.user;
    }
    
    self.screenNameLabel.text = [@"@" stringByAppendingString:user.screenName];
}

- (void)setupStatusTextLabel
{
    NSString *text = self.tweet.text;
    if (self.tweet.retweetedStatus != nil) {
        text = self.tweet.retweetedStatus.text;
    }
    
    self.statusTextLabel.text = text;
}

- (void)setupRetweetView
{
    if (self.tweet.retweetedStatus != nil) {
        // RETWEETED STATUS
        [self setupRetweetImageView];
        [self setupRetweetLabel];
    }
    else {
        // RETWEETED STATUS
        self.retweetedView.hidden = YES;
        self.retweetedViewHeightConstraint.constant = 0.0f;
        self.retweetedViewMarginTopConstraint.constant = 5.0f;
    }
}

@end
