//
//  LoginViewController.m
//  ios_twitter
//
//  Created by Stanley Ng on 6/29/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "LoginViewController.h"
#import "TimelineViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "Session.h"
#import "AVHexColor.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

- (void)handleSignIn;
- (void)getCredentialsWithParams:(NSMutableDictionary *)params
                         success:(void(^)(User *user))success
                         failure:(void(^)(NSError *error))failure;
- (void)presentTimeline;
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self customizeLeftBarButton];
        [self customizeRightBarButton];
        [self customizeTitleView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // present timeline if it is authorized
    NSLog(@"is_authorized: %d", [[TwitterClient instance] isAuthorized]);
    if ([[TwitterClient instance] isAuthorized] == 1) {

        // set user in session
        [self getCredentialsWithParams:nil success:^(User *user) {
            
            [[Session instance] setUser:user];
            
        } failure:nil];

        [self presentTimeline];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customizeLeftBarButton
{
    UIImage *image = [[UIImage imageNamed:@"twitter-white"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, 28, 28);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
 
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageView];
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)customizeRightBarButton
{
    UIBarButtonItem *barButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Sign in"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(handleSignIn)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)customizeTitleView
{
    self.title = @"";
}

- (void)handleSignIn
{
    NSLog(@"handle sign in");
    
    [[TwitterClient instance] connectWithSuccess:^{
        NSLog(@"Login view controller: connect ok!");
    } failure:^(NSError *error) {
        NSLog(@"Login view controller: connect fail!");
    }];
}

- (void)getCredentialsWithParams:(NSMutableDictionary *)params
                         success:(void(^)(User *user))success
                         failure:(void(^)(NSError *error))failure;
{
    NSLog(@"get credentials with params: %@", params);
    
    [[TwitterClient instance] verifyCredentialsWithParams:nil
                                                  success:^(AFHTTPRequestOperation *operation, User *user) {
                                                      NSLog(@"success: %@", user);
                                                      success(user);
                                                  }
                                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                      NSLog(@"failure: %@", error);
                                                      if (failure != nil) {
                                                          failure(error);
                                                      }
                                                  }];
}

- (void)presentTimeline
{
    NSLog(@"Load timeline view");
    TimelineViewController *vc = [[TimelineViewController alloc] init];
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    nvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:nvc animated:NO completion:nil];
}

@end
