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
#import "TweetTableViewCell.h"

@interface TimelineViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tweetsTableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) TweetTableViewCell *prototypeCell;

- (void)customizeLeftBarButton;
- (void)customizeRightBarButton;
- (void)customizeTitleView;
- (void)handleCompose;
- (void)handleLoadMore;
- (void)handleRefresh;
- (void)handleSignOut;
- (void)handleTweetWithIndex:(NSInteger)index;
- (void)getTimelineWithParams:(NSMutableDictionary *)params
                      success:(void(^)(NSArray *tweets))success
                      failure:(void(^)(NSError *error))failure;
- (void)setupTableView;
- (TweetTableViewCell *)prototypeCell;
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

        self.tweets = [[NSMutableArray alloc] initWithCapacity:0];

        [self getTimelineWithParams:nil success:^(NSArray *tweets) {
            
            self.tweets = [tweets mutableCopy];
            NSLog(@"[INIT] tweets.count: %d / %d", tweets.count, self.tweets.count);
            
            [self.tweetsTableView reloadData];
            
        } failure:nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupTableView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
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
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)handleLoadMore
{
    NSLog(@"handle load more");
    
    Tweet *tweet = [self.tweets lastObject];
    NSLog(@"last tweet: %@", tweet);
    
    NSMutableDictionary *params =
    [@{
      @"max_id": tweet.id
    } mutableCopy];
    
    [self getTimelineWithParams:params success:^(NSArray *tweets) {

        NSLog(@"[RELAOD] tweets.count: %d", tweets.count);

        if ((tweets.count == 1 && ![((Tweet *)tweets[0]).id isEqualToNumber:tweet.id]) || tweets.count > 1) {
        
            [self.tweets addObjectsFromArray:tweets];
            NSLog(@"[RELOAD] tweets.count: %d / %d", tweets.count, self.tweets.count);
        }

        if (tweets.count > 0) {
            [self.tweetsTableView reloadData];
        }

        [self.tweetsTableView finishInfiniteScrollWithCompletion:^(UIScrollView *scrollView) {
            [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(handleLoadMoreDone) userInfo:nil repeats:NO];
        }];
        
    } failure:nil];
}

- (void)handleLoadMoreDone
{
    [self.tweetsTableView finishInfiniteScroll];
}

- (void)handleRefresh
{
    NSLog(@"handle refresh");
    
    [self.refreshControl endRefreshing];

    [self getTimelineWithParams:nil success:^(NSArray *tweets) {
        self.tweets = [tweets mutableCopy];
        NSLog(@"[REFERSH] tweets.count: %d / %d", tweets.count, self.tweets.count);
    
        [self.tweetsTableView reloadData];
        
    } failure:nil];
}

- (void)handleSignOut
{
    NSLog(@"handle sign out");

    [[TwitterClient instance] removeAccessToken];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleTweetWithIndex:(NSInteger)index
{
    NSLog(@"handle tweet with index: %d", index);
    
    TweetViewController *vc = [[TweetViewController alloc] init];
    vc.delegate = self;
    vc.index = index;
    vc.tweet = [self.tweets objectAtIndex:index];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getTimelineWithParams:(NSMutableDictionary *)params
                      success:(void(^)(NSArray *tweets))success
                      failure:(void(^)(NSError *error))failure;
{
    NSLog(@"get timeline with params: %@", params);
    
    [[TwitterClient instance] homeTimelineWithParams:params
                                             success:^(AFHTTPRequestOperation *operation, NSArray *tweets) {
                                                 //NSLog(@"success: %@", tweets);
                                                 success(tweets);
                                             }
                                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                 NSLog(@"failure: %@", error);
                                                 if (failure != nil) {
                                                     failure(error);
                                                 }
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
        NSLog(@"add infinite scroll with handler");
        [self handleLoadMore];
    }];
    
    // Table View Cell
    UINib *nib = [UINib nibWithNibName:@"TweetTableViewCell" bundle:nil];
    [self.tweetsTableView registerNib:nib
               forCellReuseIdentifier:@"TweetTableViewCell"];
}

#pragma UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"cell for row at index path: %d", indexPath.row);
    
    /*
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = @"Tweet";
    return cell;
     */
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell"];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[TweetTableViewCell class]])
    {
        TweetTableViewCell *c = (TweetTableViewCell *)cell;
        
        c.delegate = self;
        c.index = indexPath.row;
        c.tweet = self.tweets[indexPath.row];
        [c configure];
    }
}


#pragma UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did select row at index path: %d", indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self handleTweetWithIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"height for row at index path: %d", indexPath.row);
    
    if (!self.prototypeCell) {
        self.prototypeCell = [self.tweetsTableView dequeueReusableCellWithIdentifier:@"TweetTableViewCell"];
    }
    
    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
    self.prototypeCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tweetsTableView.bounds), CGRectGetHeight(self.prototypeCell.bounds));
    [self.prototypeCell layoutIfNeeded];

    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];

    return size.height + 1;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewAutomaticDimension;
//}


#pragma ComposeViewControllerDelegate methods

- (void)updateFromComposeView:(ComposeViewController *)controller update:(Tweet *)tweet
{
    NSLog(@"update from compose view: %@", tweet);
    
    [self.tweets insertObject:tweet atIndex:0];
    NSLog(@"[UPDATE] tweets.count: 1 / %d", self.tweets.count);
    
    [self.tweetsTableView reloadData];
}


#pragma TweetTableViewCell methods

- (void)updateFromTweetTableViewCell:(TweetTableViewCell *)cell update:(Tweet *)tweet index:(NSInteger)index
{
    NSLog(@"update from tweet table view cell: %d %@", index, tweet);
    
    [self.tweetsTableView reloadData];
}


#pragma TweetViewDelegate methods

- (void)updateFromTweetView:(TweetViewController *)controller update:(Tweet *)tweet index:(NSInteger)index
{
    NSLog(@"update from tweet view: %d %@", index, tweet);

    self.tweets[index] = tweet;
    [self.tweetsTableView reloadData];
}

@end
