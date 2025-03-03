//
//  TweetViewController.m
//  ios_twitter
//
//  Created by Stanley Ng on 6/29/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "TweetViewController.h"
#import "ComposeViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <DateTools.h>
#import "AVHexColor.h"

@interface TweetViewController ()

@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *retweetedImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetedLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetedViewMarginTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetedViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusTextHeightConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *retweetedView;

- (void)configure;
- (void)customizeRightBarButton;
- (void)customizeTitleView;
- (void)handleFavorite;
- (void)handleReply;
- (void)handleRetweet;
- (void)createFavoriteWithParams:(NSMutableDictionary *)params
                        success:(void(^)(Tweet *tweet))success
                        failure:(void(^)(NSError *error))failure;
- (void)destroyFavoriteWithParams:(NSMutableDictionary *)params
                        success:(void(^)(Tweet *tweet))success
                        failure:(void(^)(NSError *error))failure;
- (void)retweetStatusWithParams:(NSMutableDictionary *)params
                        success:(void(^)(Tweet *tweet))success
                        failure:(void(^)(NSError *error))failure;
- (void)destroyStatusWithParams:(NSMutableDictionary *)params
                        success:(void(^)(Tweet *tweet))success
                        failure:(void(^)(NSError *error))failure;
- (void)setupReplyButton;
- (void)setupRetweetButton;
- (void)setupFavoriteButton;
- (void)setupProfileImageView;
- (void)setupRetweetImageView;
- (void)setupDateLabel;
- (void)setupFavoriteCountLabel;
- (void)setupNameLabel;
- (void)setupRetweetCountLabel;
- (void)setupScreenNameLabel;
- (void)setupStatusTextLabel;
- (void)setupRetweetView;
@end

@implementation TweetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self customizeTitleView];
        [self customizeRightBarButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configure];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    CGSize rect = self.scrollView.frame.size;
    NSLog(@"scrollview: did rotate w%f h%f", rect.width, rect.height);
    
    [self configure];
}

- (void)configure
{
    if (self.tweet == nil) {
        return;
    }
    
    [self setupProfileImageView];
    [self setupNameLabel];
    [self setupScreenNameLabel];

    [self setupStatusTextLabel];

    [self setupDateLabel];

    [self setupRetweetCountLabel];
    [self setupFavoriteCountLabel];

    [self setupReplyButton];
    [self setupRetweetButton];
    [self setupFavoriteButton];

    [self setupRetweetView];
}

- (void)customizeRightBarButton
{
    UIBarButtonItem *barButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Reply"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(handleReply)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)customizeTitleView
{
    self.title = @"Tweet";
}

- (void)handleFavorite
{
    NSLog(@"handle favorite");
    NSLog(@"tweet.favorited: %@", self.tweet.favorited);
    
    NSMutableDictionary *params =
    [@{
       @"id": self.tweet.id
    } mutableCopy];
     
    if ([self.tweet.favorited isEqualToNumber:[NSNumber numberWithInt:0]]) {
        NSLog(@"create favorite");
     
        [self createFavoriteWithParams:params success:^(Tweet *tweet) {
            NSLog(@"[FAVORITE] tweets: %@", tweet);

            self.tweet = tweet;
            self.favoriteButton.tintColor = [AVHexColor colorWithHexString:@"#FFAC33"];
            self.favoriteCountLabel.text = [tweet.favoriteCount stringValue];

            [self.delegate updateFromTweetView:self update:tweet index:self.index];

        } failure:nil];
    }
    else {
        NSLog(@"destory favorite");
     
        [self destroyFavoriteWithParams:params success:^(Tweet *tweet) {
            NSLog(@"[UNFAVORITE] tweets: %@", tweet);
            
            self.tweet = tweet;
            self.favoriteButton.tintColor = [UIColor lightGrayColor];
            self.favoriteCountLabel.text = [tweet.favoriteCount stringValue];
            
            [self.delegate updateFromTweetView:self update:tweet index:self.index];
            
        } failure:nil];
     }
}

- (void)handleReply
{
    NSLog(@"handle reply");
    
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.delegate = self;
    vc.tweet = self.tweet;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)handleRetweet
{
    NSLog(@"handle retweet");
    
    NSLog(@"tweet.retweeted: %@", self.tweet.retweeted);
    NSMutableDictionary *params =
    [@{
       @"id": self.tweet.id
       } mutableCopy];
    
    if ([self.tweet.retweeted isEqualToNumber:[NSNumber numberWithInt:0]]) {
        NSLog(@"retweet status");
        
        [self retweetStatusWithParams:params success:^(Tweet *tweet) {
            NSLog(@"[RETWEET] tweets: %@", tweet);
            
            self.tweet = tweet;
            self.retweetButton.tintColor = [AVHexColor colorWithHexString:@"#5C9138"];
            self.retweetCountLabel.text = [tweet.retweetCount stringValue];
            
            [self.delegate updateFromTweetView:self update:tweet index:self.index];
            
        } failure:nil];
    }
    else {
        NSLog(@"destroy status");
        
        [self destroyStatusWithParams:params success:^(Tweet *tweet) {
            NSLog(@"[UNRETWEET] tweets: %@", tweet);
            
            self.tweet = tweet;
            self.retweetButton.tintColor = [UIColor lightGrayColor];
            
            [self.delegate updateFromTweetView:self update:tweet index:self.index];
            
        } failure:nil];
    }
}

- (void)createFavoriteWithParams:(NSMutableDictionary *)params
                         success:(void(^)(Tweet *tweet))success
                         failure:(void(^)(NSError *error))failure
{
    [[TwitterClient instance] createFavoriteWithParams:params
                                               success:^(AFHTTPRequestOperation *operation, Tweet *tweet) {
                                                   NSLog(@"success: %@", tweet);
                                                   success(tweet);
                                               }
                                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                   NSLog(@"failure: %@", error);
                                                   if (failure != nil) {
                                                       failure(error);
                                                   }
                                               }];
}

- (void)destroyFavoriteWithParams:(NSMutableDictionary *)params
                          success:(void(^)(Tweet *tweet))success
                          failure:(void(^)(NSError *error))failure
{
    [[TwitterClient instance] destroyFavoriteWithParams:params
                                                success:^(AFHTTPRequestOperation *operation, Tweet *tweet) {
                                                    NSLog(@"success: %@", tweet);
                                                    success(tweet);
                                                }
                                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                    NSLog(@"failure: %@", error);
                                                    if (failure != nil) {
                                                        failure(error);
                                                    }
                                                }];
}

- (void)retweetStatusWithParams:(NSMutableDictionary *)params
                        success:(void(^)(Tweet *tweet))success
                        failure:(void(^)(NSError *error))failure
{
    [[TwitterClient instance] retweetStatusWithParams:params
                                              success:^(AFHTTPRequestOperation *operation, Tweet *tweet) {
                                                  NSLog(@"success: %@", tweet);
                                                  success(tweet);
                                              }
                                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                  NSLog(@"failure: %@", error);
                                                  if (failure != nil) {
                                                      failure(error);
                                                  }
                                              }];
}

- (void)destroyStatusWithParams:(NSMutableDictionary *)params
                        success:(void(^)(Tweet *tweet))success
                        failure:(void(^)(NSError *error))failure
{
    [[TwitterClient instance] destroyStatusWithParams:params
                                              success:^(AFHTTPRequestOperation *operation, Tweet *tweet) {
                                                  NSLog(@"success: %@", tweet);
                                                  success(tweet);
                                              }
                                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                  NSLog(@"failure: %@", error);
                                                  if (failure != nil) {
                                                      failure(error);
                                                  }
                                              }];
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
    
    [self.favoriteButton addTarget:self action:@selector(handleFavorite) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupReplyButton
{
    UIImage *image = [UIImage imageNamed:@"icon-reply"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.replyButton setImage:image forState:UIControlStateNormal];
    self.replyButton.tintColor = [UIColor lightGrayColor];
    
    [self.replyButton addTarget:self action:@selector(handleReply) forControlEvents:UIControlEventTouchUpInside];
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
    
    [self.retweetButton addTarget:self action:@selector(handleRetweet) forControlEvents:UIControlEventTouchUpInside];
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
    
    self.dateLabel.font = [UIFont systemFontOfSize:13.0f];
    self.dateLabel.textColor = [UIColor lightGrayColor];
    self.dateLabel.text = [createdDate formattedDateWithFormat:@"MM/dd/yyyy hh:mm a"];
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

- (void)setupFavoriteCountLabel
{
    Tweet *tweet = self.tweet;
    if (tweet.retweetedStatus != nil) {
        tweet = tweet.retweetedStatus;
    }
    
    NSNumber *count = tweet.favoriteCount;
    self.favoriteCountLabel.font = [UIFont boldSystemFontOfSize:13.0f];
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
}

- (void)setupRetweetLabel
{
    User *user = self.tweet.user;
    
    self.retweetedLabel.font = [UIFont systemFontOfSize:13.0f];
    self.retweetedLabel.text = [user.name stringByAppendingString:@" retweeted"];
    self.retweetedLabel.textColor = [UIColor lightGrayColor];
}

- (void)setupRetweetCountLabel
{
    Tweet *tweet = self.tweet;
    if (tweet.retweetedStatus != nil) {
        tweet = tweet.retweetedStatus;
    }
    
    NSNumber *count = tweet.retweetCount;
    
    self.retweetCountLabel.font = [UIFont boldSystemFontOfSize:13.0f];
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
    
    self.statusTextLabel.font = [UIFont systemFontOfSize:18.0f];
    self.statusTextLabel.text = text;

    CGRect frame;
    frame = self.statusTextLabel.frame;
    NSLog(@"status text: %f %f", frame.size.width, frame.size.height);
    [self.statusTextLabel sizeToFit];
    frame = self.statusTextLabel.frame;
    NSLog(@"status text: %f %f", frame.size.width, frame.size.height);
    
    self.statusTextHeightConstraint.constant = frame.size.height;
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


#pragma ComposeViewControllerDelegate methods

- (void)updateFromComposeView:(ComposeViewController *)controller update:(Tweet *)tweet
{
    NSLog(@"update from compose view: %@", tweet);
}


@end
