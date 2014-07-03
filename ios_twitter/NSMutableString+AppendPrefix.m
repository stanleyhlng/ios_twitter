//
//  NSMutableString+AppendPrefix.m
//  ios_twitter
//
//  Created by Stanley Ng on 7/3/14.
//  Copyright (c) 2014 Stanley Ng. All rights reserved.
//

#import "NSMutableString+AppendPrefix.h"

@implementation NSMutableString (AppendPrefix)

- (void)appendPrefix:(NSString *)prefix {
    NSLog(@"prefix: %@", prefix);
    [self insertString:prefix atIndex:0];
}

@end
