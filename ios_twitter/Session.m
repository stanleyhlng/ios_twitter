//
//  Session.m
//  ios_twitter
//
//  Created by Stanley Ng on 7/2/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "Session.h"

@implementation Session

static User* currentUser = nil;

+ (Session *)instance {
    static Session *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[Session alloc] init];
        }
    });
    
    return instance;
}

- (User *)getUser {
    return currentUser;
}

- (void)setUser:(User *)user {
    currentUser = user;
}

@end
