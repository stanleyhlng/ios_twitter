//
//  TimelineViewController.m
//  ios_twitter
//
//  Created by Stanley Ng on 6/29/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "TimelineViewController.h"

@interface TimelineViewController ()
- (void)customizeLeftBarButton;
- (void)customizeRightBarButton;
- (void)customizeTitleView;
- (void)handleSignOut;
- (void)handleCompose;
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (void)handleSignOut
{
    NSLog(@"handle sign out");
}

- (void)handleCompose
{
    NSLog(@"handle compose");
}

@end
