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
            instance = [[TwitterClient alloc] init];
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

@end