//
//  ComposeViewController.m
//  ios_twitter
//
//  Created by Stanley Ng on 6/29/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "ComposeViewController.h"
#import "Session.h"
#import "AVHexColor.h"
#import "TwitterClient.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

- (void)customizeLeftBarButton;
- (void)customizeRightBarButton;
- (void)customizeTitleView;
- (void)handleCancel;
- (void)handleTweet;
- (void)postUpdateWithParams:(NSMutableDictionary *)params
                     success:(void(^)(Tweet *tweet))success
                     failure:(void(^)(NSError *error))failure;
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
    
    User *user = [[Session instance] getUser];
    NSLog(@"user: %@", user);

    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)handleCancel
{
    NSLog(@"handle cancel");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleTweet
{
    NSLog(@"handle tweet");

    NSMutableDictionary *params =
    [@{
       @"status": @"Hello World 1"
       } mutableCopy];
    
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

@end
