//
//  ComposeViewController.m
//  ios_twitter
//
//  Created by Stanley Ng on 6/29/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "ComposeViewController.h"
#import "Session.h"
#import "User.h"
#import "TwitterClient.h"
#import "NSMutableString+AppendPrefix.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AVHexColor.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

- (void)configure;
- (void)customizeLeftBarButton;
- (void)customizeRightBarButton;
- (void)customizeTitleView;
- (NSArray *)getScreenNames;
- (void)handleCancel;
- (void)handleTweet;
- (void)postUpdateWithParams:(NSMutableDictionary *)params
                     success:(void(^)(Tweet *tweet))success
                     failure:(void(^)(NSError *error))failure;
- (void)setupProfileImageView;
- (void)setupNameLabel;
- (void)setupScreenNameLabel;
- (void)setupStatusTextView;

@end

@implementation ComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self customizeTitleView];
        [self customizeLeftBarButton];
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

- (void)configure
{
    [self setupProfileImageView];
    [self setupNameLabel];
    [self setupScreenNameLabel];
    [self setupStatusTextView];
}

- (void)customizeLeftBarButton
{
    UIBarButtonItem *barButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(handleCancel)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)customizeRightBarButton
{
    UIBarButtonItem *barButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Tweet"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(handleTweet)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)customizeTitleView
{
    self.title = @"";
}

- (NSArray *)getScreenNames
{
    NSMutableArray *names = [@[] mutableCopy];
    
    if (self.tweet != nil) {
        if (self.tweet.retweetedStatus != nil) {
            // RETWEETED.USER + USER
            [names addObjectsFromArray:@[
                                         [NSMutableString stringWithFormat:@"@%@", self.tweet.retweetedStatus.user.screenName],
                                         [NSMutableString stringWithFormat:@"@%@", self.tweet.user.screenName]
                                        ]];
        }
        else if (self.tweet.inReplyToScreenName != nil) {
            // USER + REPLIED.USER
            [names addObjectsFromArray:@[
                                         [NSMutableString stringWithFormat:@"@%@", self.tweet.inReplyToScreenName],
                                         [NSMutableString stringWithFormat:@"@%@", self.tweet.user.screenName]
                                         ]];
        }
        else {
            // USER
            [names addObjectsFromArray:@[
                                         [NSMutableString stringWithFormat:@"@%@", self.tweet.user.screenName]
                                        ]];
        }
    }
    
    return names;
}

- (void)handleCancel
{
    NSLog(@"handle cancel");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleTweet
{
    NSLog(@"handle tweet");

    // required: status
    NSMutableDictionary *params =
    [@{
       @"status": self.textView.text
    } mutableCopy];
    
    // optional: in_reply_to_status_id
    if (self.tweet != nil) {
        params[@"in_reply_to_status_id"] = self.tweet.id;
    }
    
    [self postUpdateWithParams:params success:^(Tweet *tweet) {
        NSLog(@"[UPDATE] tweet: %@", tweet);
        [self.delegate updateFromComposeView:self update:tweet];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:nil];
}

- (void)postUpdateWithParams:(NSMutableDictionary *)params
                      success:(void(^)(Tweet *tweet))success
                      failure:(void(^)(NSError *error))failure;
{
    NSLog(@"post update with params with params: %@", params);
    
    [[TwitterClient instance] updateWithParams:params
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
    User *user = [[Session instance] getUser];
    
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

- (void)setupNameLabel
{
    User *user = [[Session instance] getUser];
    
    self.nameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    self.nameLabel.text = user.name;
}

- (void)setupScreenNameLabel
{
    User *user = [[Session instance] getUser];
    
    self.screenNameLabel.font = [UIFont systemFontOfSize:12.0f];
    self.screenNameLabel.text = [@"@" stringByAppendingString:user.screenName];
}

- (void)setupStatusTextView
{
    NSLog(@"setup tweet: %@", self.tweet);
    
    NSArray *names = [self getScreenNames];
    NSLog(@"names: %@", names);
    
    NSMutableString *namesList = [@"" mutableCopy];
    if (names.count != 0) {
        namesList = [NSMutableString stringWithFormat:@"%@ ", [names componentsJoinedByString:@" "]];
    }
    
    self.textView.text = [[NSString alloc] initWithFormat:@"%@%@", namesList, @"Hello World"];
    [self.textView becomeFirstResponder];
}

@end
