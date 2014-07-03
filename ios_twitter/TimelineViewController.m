//
//  TimelineViewController.m
//  ios_twitter
//
//  Created by Stanley Ng on 6/29/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "TimelineViewController.h"
#import "ComposeViewController.h"
#import "TweetViewController.h"
#import "AVHexColor.h"
#import "UIScrollView+InfiniteScroll.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "User.h"

@interface TimelineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tweetsTableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

- (void)customizeLeftBarButton;
- (void)customizeRightBarButton;
- (void)customizeTitleView;
- (void)handleCompose;
- (void)handleLoadMore;
- (void)handleRefresh;
- (void)handleSignOut;
- (void)handleTweet;
- (void)loadCredentialsData;
- (void)loadTimelineDataWithParams:(NSDictionary *)params;
- (void)setupTableView;
@end

@implementation TimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {       
        // Custom initialization
        [self customizeLeftBarButton];
        [self customizeRightBarButton];
        [self customizeTitleView];
        
        [self loadTimelineDataWithParams:nil];
        
        //[self loadCredentialsData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customizeLeftBarButton
{
    UIBarButtonItem *barButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Sign out"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(handleSignOut)];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)customizeRightBarButton
{
    UIBarButtonItem *barButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"New"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(handleCompose)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)customizeTitleView
{
    self.title = @"Home";
}

- (void)handleCompose
{
    NSLog(@"handle compose");
    
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)handleLoadMore
{
    NSLog(@"handle load more");
}

- (void)handleRefresh
{
    NSLog(@"handle refresh");
    
    [self.refreshControl endRefreshing];

    [self loadTimelineDataWithParams:nil];

    [self.tweetsTableView reloadData];
}

- (void)handleSignOut
{
    NSLog(@"handle sign out");

    [[TwitterClient instance] removeAccessToken];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleTweet
{
    NSLog(@"handle tweet");
    
    TweetViewController *vc = [[TweetViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadCredentialsData
{
    NSLog(@"load credentials data");

    [[TwitterClient instance] verifyCredentialsWithParams:nil
                                                  success:^(AFHTTPRequestOperation *operation, User *user) {
                                                      NSLog(@"success: %@", user);
                                                  }
                                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                      NSLog(@"failure: %@", error);
                                                }];
}

- (void)loadTimelineDataWithParams:(NSDictionary *)params
{
    NSLog(@"load timeline data");
    
    [[TwitterClient instance] homeTimelineWithParams:params
                                             success:^(AFHTTPRequestOperation *operation, NSArray *tweets) {
                                                 NSLog(@"success: %@", tweets);
                                                 NSLog(@"tweets.count: %d", tweets.count);
                                             }
                                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                 NSLog(@"failure: %@", error);
                                             }];
}

- (void)setupTableView
{
    NSLog(@"setup table view");
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tweetsTableView addSubview:self.refreshControl];
    
    self.tweetsTableView.dataSource = self;
    self.tweetsTableView.delegate = self;
    [self.tweetsTableView addInfiniteScrollWithHandler:^(UIScrollView *scrollView) {
        [self handleLoadMore];
        [self.tweetsTableView finishInfiniteScroll];
    }];
}

#pragma UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell for row at index path: %d", indexPath.row);
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = @"Tweet";
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

#pragma UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did select row at index path: %d", indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self handleTweet];
}

@end
