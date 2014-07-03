//
//  TweetViewController.m
//  ios_twitter
//
//  Created by Stanley Ng on 6/29/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "TweetViewController.h"
#import "ComposeViewController.h"

@interface TweetViewController ()
- (void)customizeRightBarButton;
- (void)customizeTitleView;
- (void)setupTweet;
- (void)handleReply;
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

- (void)handleReply
{
    NSLog(@"handle reply");
    
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.delegate = self;
    vc.tweet = self.tweet;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nvc animated:YES completion:nil];
}


#pragma ComposeViewControllerDelegate methods

- (void)updateFromComposeView:(ComposeViewController *)controller update:(Tweet *)tweet
{
    NSLog(@"update from compose view: %@", tweet);
}

@end
