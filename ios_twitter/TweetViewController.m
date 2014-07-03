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

@interface TweetViewController ()
- (void)customizeRightBarButton;
- (void)customizeTitleView;
- (void)setupTweet;
- (void)handleFavorite;
- (void)handleReply;
- (void)createFavoriteWithParam:(NSMutableDictionary *)params
                        success:(void(^)(Tweet *tweet))success
                        failure:(void(^)(NSError *error))failure;
- (void)destroyFavoriteWithParam:(NSMutableDictionary *)params
                        success:(void(^)(Tweet *tweet))success
                        failure:(void(^)(NSError *error))failure;
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
    [self setupTweet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self setupTweet];
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

- (void)setupTweet
{
    NSLog(@"setup tweet: %@", self.tweet);
}

- (void)handleFavorite
{
    NSLog(@"handle favorite");
    /*
     NSLog(@"tweet.favorited: %@", self.tweet.favorited);
     NSMutableDictionary *params =
     [@{
     @"id": self.tweet.id
     } mutableCopy];
     
     if ([self.tweet.favorited isEqualToNumber:[NSNumber numberWithInt:0]]) {
     NSLog(@"create favorite");
     
     [self createFavoriteWithParam:params success:^(Tweet *tweet) {
     NSLog(@"[FAVORITE] tweets: %@", tweet);
     self.tweet = tweet;
     
     } failure:nil];
     }
     else {
     NSLog(@"destory favorite");
     
     [self destroyFavoriteWithParam:params success:^(Tweet *tweet) {
     NSLog(@"[UNFAVORITE] tweets: %@", tweet);
     self.tweet = tweet;
     
     } failure:nil];
     }
     */
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

- (void)createFavoriteWithParam:(NSMutableDictionary *)params
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

- (void)destroyFavoriteWithParam:(NSMutableDictionary *)params
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


#pragma ComposeViewControllerDelegate methods

- (void)updateFromComposeView:(ComposeViewController *)controller update:(Tweet *)tweet
{
    NSLog(@"update from compose view: %@", tweet);
}

@end
