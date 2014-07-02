//
//  AppDelegate.m
//  ios_twitter
//
//  Created by Stanley Ng on 6/29/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TimelineViewController.h"
#import "AVHexColor.h"
#import "NSURL+DictionaryFromQueryString.h"
#import "TwitterClient.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"[DEBUG 1]");
    [self customizeStatusBar];
    [self customizeNavBarAppearance];
    [self customizeWindow];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)customizeStatusBar
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)customizeNavBarAppearance
{
    id navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setTitleTextAttributes:
     @{
       NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f]
       }];
    [navigationBarAppearance setTintColor:[AVHexColor colorWithHexString:@"#ffffff"]];
    [navigationBarAppearance setBarTintColor:[AVHexColor colorWithHexString:@"#55acee"]];
}

- (void)customizeWindow
{
    LoginViewController *vc = [[LoginViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = nvc;
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSLog(@"url.scheme: %@", url.scheme);
    NSLog(@"url.host: %@", url.host);
    
    NSLog(@"[DEBUG 2]");
    
    if ([url.scheme isEqualToString:@"oauth"])
    {
        if ([url.host isEqualToString:@"ios_twitter"])
        {
            [[TwitterClient instance] authorizeWithURL:url
                                               success:^{

                                                   NSLog(@"App Delegate: authorize ok!");

                                                   // OAuth authenticated successfully, launch primary authenticated view
                                                   // i.e Display application "timeline"
                                                   
                                                   LoginViewController *vc = [[LoginViewController alloc] init];
                                                   
                                                   UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
                                                   nvc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                                                   
                                                   self.window.rootViewController = nvc;
                                                   
                                                   //[self.window.view presentViewController:nvc animated:YES completion:nil];
                                                   
                                               }
                                               failure:^(NSError *error) {
                                                   NSLog(@"App Delegate: authorize fail!");
                                               }];

            /*
            NSDictionary *parameters = [url dictionaryFromQueryString];
            if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
                TwitterClient *client = [TwitterClient instance];
                [client fetchAccessTokenWithPath:@"/oauth/access_token"
                                          method:@"POST"
                                    requestToken:[BDBOAuthToken tokenWithQueryString:url.query]
                                         success:^(BDBOAuthToken *accessToken) {
                                             NSLog(@"access token: %@", accessToken);
                                         }
                                         failure:^(NSError *error) {
                                             NSLog(@"Fail to get the access token.");
                                         }];
            }
            */
        }
        return YES;
    }
    return NO;
}

@end
