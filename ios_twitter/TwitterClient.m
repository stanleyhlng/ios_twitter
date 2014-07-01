//
//  TwitterClient.m
//  ios_twitter
//
//  Created by Stanley Ng on 6/29/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "TwitterClient.h"

@implementation TwitterClient

+ (TwitterClient *)instance {
    static TwitterClient *instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"]
                                                  consumerKey:@"L82BdXwfdKHIQL036NO12qwpx"
                                               consumerSecret:@"zbBxQNTLry6add284m8AecDf5VRdIpuUpuuVu0TM41tci8a0Jd"];
        }
    });
    
    return instance;
}

// GET statuses/home_timeline
// https://dev.twitter.com/docs/api/1.1/get/statuses/home_timeline
- (AFHTTPRequestOperation *)homeTimelineWithSuccess:(void(^)(AFHTTPRequestOperation *operation, id response))success
                                            failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    return [self GET:@"statuses/home_timeline"
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id response) {
                 success(operation, response);
             }
             failure:failure];
};

- (void)login
{
    [self fetchRequestTokenWithPath:@"oauth/request_token"
                             method:@"POST"
                        callbackURL:[NSURL URLWithString:@"http://demo.stanleyhlng.com/ios-twitter/oauth.php"]
                              scope:nil
                            success:^(BDBOAuthToken *requestToken) {
                                NSLog(@"Got the request token.");
                                
                                NSString *authUrl = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
                                
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authUrl]];
                            }
                            failure:^(NSError *error) {
                                NSLog(@"Fail to get the request token.");
                            }];
}

@end