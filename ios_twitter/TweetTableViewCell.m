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
#import <DateTools.h>
#import "AVHexColor.h"

@interface TweetTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelWidthConstraint;
- (void)handleFavorite;
- (void)handleReply;
- (void)handleRetweet;
- (void)setupReplyButton;
- (void)setupRetweetButton;
- (void)setupFavoriteButton;
- (void)setupProfileImageView;
- (void)setupRetweetImageView;
- (void)setupDateLabel;
- (void)setupFavoriteCountLabel;
- (void)setupNameLabel;
- (void)setupRetweetLabel;
- (void)setupRetweetCountLabel;
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
    //self.statusTextLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.statusTextLabel.frame);
    //[self.contentView layoutIfNeeded];
}

- (void)configure
{
    if (self.tweet == nil) {
        return;
    }
    
    [self setupProfileImageView];

    [self setupNameLabel];
    [self setupScreenNameLabel];
    [self setupDateLabel];

    [self setupStatusTextLabel];

    [self setupReplyButton];
    [self setupRetweetButton];
    [self setupRetweetCountLabel];
    [self setupFavoriteButton];
    [self setupFavoriteCountLabel];

    [self setupRetweetView];
}

- (void)handleFavorite
{
    NSLog(@"handle favorite");
    
    Tweet *tweet = self.tweet;
    if (tweet.retweetedStatus != nil) {
        tweet = tweet.retweetedStatus;
    }
    
    if ([tweet.favorited intValue] == 0) {
        // FAVORITE
        int count = [tweet.favoriteCount intValue] + 1;
        tweet.favoriteCount = [NSNumber numberWithInt:count];
        tweet.favorited = [NSNumber numberWithInt:1];
    }
    else {
        // UNFAVORITE
        int count = [tweet.favoriteCount intValue] - 1;
        tweet.favoriteCount = [NSNumber numberWithInt:count];
        tweet.favorited = [NSNumber numberWithInt:0];
    }
    
    [self.delegate updateFromTweetTableViewCell:self update:tweet index:self.index];
}

- (void)handleReply
{
    NSLog(@"handle reply");
    [self.delegate updateFromTweetTableViewCell:self update:self.tweet index:self.index];
}

- (void)handleRetweet
{
    NSLog(@"handle retweet");

    Tweet *tweet = self.tweet;
    if (tweet.retweetedStatus != nil) {
        tweet = tweet.retweetedStatus;
    }
    
    if ([tweet.retweeted intValue] == 0) {
        // RETWEET
        int count = [tweet.retweetCount intValue] + 1;
        tweet.retweetCount = [NSNumber numberWithInt:count];
        tweet.retweeted = [NSNumber numberWithInt:1];
    }
    else {
        // UNRETWEET
        int count = [tweet.retweetCount intValue] - 1;
        tweet.retweetCount = [NSNumber numberWithInt:count];
        tweet.retweeted = [NSNumber numberWithInt:0];
    }
    
    [self.delegate updateFromTweetTableViewCell:self update:self.tweet index:self.index];
}

- (void)setupFavoriteButton
{
    Tweet *tweet = self.tweet;
    if (tweet.retweetedStatus != nil) {
        tweet = tweet.retweetedStatus;
    }
    
    UIColor *color = [UIColor lightGrayColor];
    if ([tweet.favorited intValue] == 1) {
        color = [AVHexColor colorWithHexString:@"#FFAC33"];
    }
    
    UIImage *image = [UIImage imageNamed:@"icon-favorite"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.favoriteButton setImage:image forState:UIControlStateNormal];
    self.favoriteButton.tintColor = color;
    
    //[self.favoriteButton addTarget:self action:@selector(handleFavorite) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupReplyButton
{
    UIImage *image = [UIImage imageNamed:@"icon-reply"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.replyButton setImage:image forState:UIControlStateNormal];
    self.replyButton.tintColor = [UIColor lightGrayColor];
    
    //[self.replyButton addTarget:self action:@selector(handleReply) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupRetweetButton
{
    Tweet *tweet = self.tweet;
    if (tweet.retweetedStatus != nil) {
        tweet = tweet.retweetedStatus;
    }
    
    UIColor *color = [UIColor lightGrayColor];
    if ([tweet.retweeted intValue] == 1) {
        color = [AVHexColor colorWithHexString:@"#5C9138"];
    }
    
    UIImage *image = [UIImage imageNamed:@"icon-retweet"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.retweetButton setImage:image forState:UIControlStateNormal];
    self.retweetButton.tintColor = color;
    
    //[self.retweetButton addTarget:self action:@selector(handleRetweet) forControlEvents:UIControlEventTouchUpInside];
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

    [self.profileImageView setImageWithURL:url placeholderImage:placeholder];
    /*
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
     */
}

- (void)setupRetweetImageView
{
    UIImage *image = [UIImage imageNamed:@"icon-retweet"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.retweetedImageView.image = image;
    self.retweetedImageView.tintColor = [UIColor lightGrayColor];
}

- (void)setupDateLabel
{
    NSDateFormatter *frm = [[NSDateFormatter alloc] init];
    [frm setDateStyle:NSDateFormatterLongStyle];
    [frm setFormatterBehavior:NSDateFormatterBehavior10_4];
    [frm setDateFormat: @"EEE MMM dd HH:mm:ss Z yyyy"];
    NSDate *createdDate = [frm dateFromString:self.tweet.createdAt];
    //NSLog(@"oldDate:%@", self.tweet.createdAt);
    //NSLog(@"newDate:%@", createdDate);

    NSDate *timeAgoDate = createdDate;
    
    self.dateLabel.font = [UIFont systemFontOfSize:13.0f];
    self.dateLabel.textColor = [UIColor lightGrayColor];
    self.dateLabel.text = [NSString stringWithFormat:@"%@", timeAgoDate.shortTimeAgoSinceNow];
}

- (void)setupFavoriteCountLabel
{
    Tweet *tweet = self.tweet;
    if (tweet.retweetedStatus != nil) {
        tweet = tweet.retweetedStatus;
    }
    
    UIColor *color = [UIColor lightGrayColor];
    if ([tweet.favorited intValue] == 1) {
        color = [AVHexColor colorWithHexString:@"#FFAC33"];
    }
    
    NSNumber *count = tweet.favoriteCount;
    self.favoriteCountLabel.font = [UIFont systemFontOfSize:13.0f];
    self.favoriteCountLabel.textColor = color;
    self.favoriteCountLabel.text = [count stringValue];
}

- (void)setupNameLabel
{
    User *user = self.tweet.user;
    if (self.tweet.retweetedStatus != nil) {
        user = self.tweet.retweetedStatus.user;
    }
    
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.nameLabel.text = user.name;
    [self.nameLabel sizeToFit];
    
    CGRect frame = self.nameLabel.frame;
    self.nameLabelWidthConstraint.constant = frame.size.width;
}

- (void)setupRetweetLabel
{
    User *user = self.tweet.user;
    
    self.retweetLabel.font = [UIFont systemFontOfSize:13.0f];
    self.retweetLabel.text = [user.name stringByAppendingString:@" retweeted"];
    self.retweetLabel.textColor = [UIColor lightGrayColor];
}

- (void)setupRetweetCountLabel
{
    Tweet *tweet = self.tweet;
    if (tweet.retweetedStatus != nil) {
        tweet = tweet.retweetedStatus;
    }
    
    UIColor *color = [UIColor lightGrayColor];
    if ([tweet.retweeted intValue] == 1) {
        color = [AVHexColor colorWithHexString:@"#5C9138"];
    }
    
    NSNumber *count = self.tweet.retweetCount;
    if (self.tweet.retweetedStatus != nil) {
        count = self.tweet.retweetedStatus.retweetCount;
    }
    
    self.retweetCountLabel.font = [UIFont systemFontOfSize:13.0f];
    self.retweetCountLabel.textColor = color;
    self.retweetCountLabel.text = [count stringValue];
}

- (void)setupScreenNameLabel
{
    User *user = self.tweet.user;
    if (self.tweet.retweetedStatus != nil) {
        user = self.tweet.retweetedStatus.user;
    }
    
    self.screenNameLabel.font = [UIFont systemFontOfSize:13.0f];
    self.screenNameLabel.text = [@"@" stringByAppendingString:user.screenName];
}

- (void)setupStatusTextLabel
{
    NSString *text = self.tweet.text;
    if (self.tweet.retweetedStatus != nil) {
        text = self.tweet.retweetedStatus.text;
    }
 
    self.statusTextLabel.font = [UIFont systemFontOfSize:14.0f];
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
