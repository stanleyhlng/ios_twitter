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

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

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
- (void)setupProfileImageView;
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
}

- (void)configure
{
    if (self.tweet == nil) {
        return;
    }
    
    [self setupProfileImageView];
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
        } failure:nil];
    }
    else {
        NSLog(@"destory favorite");
     
        [self destroyFavoriteWithParams:params success:^(Tweet *tweet) {
            NSLog(@"[UNFAVORITE] tweets: %@", tweet);
            self.tweet = tweet;
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
        } failure:nil];
    }
    else {
        NSLog(@"destroy status");
        
        [self destroyStatusWithParams:params success:^(Tweet *tweet) {
            NSLog(@"[UNRETWEET] tweets: %@", tweet);
            self.tweet = tweet;
            
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


#pragma ComposeViewControllerDelegate methods

- (void)updateFromComposeView:(ComposeViewController *)controller update:(Tweet *)tweet
{
    NSLog(@"update from compose view: %@", tweet);
}


@end
