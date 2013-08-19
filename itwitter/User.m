//
//  User.m
//  itwitter
//
//  Created by Sriram Varadarajan on 8/17/13.
//  Copyright (c) 2013 Y.CORP.YAHOO.COM\vsriram. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"
#import "JSONKit.h"

NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";
NSString * const kCurrentUserKey = @"kCurrentUserKey";

@implementation User

static User *_currentUser;

+ (User *)currentUser {
    NSLog(@"User:currentUser called");
    if (!_currentUser) {
        NSLog(@"User:currentUser _currentUser is null");
        NSString *jsonString = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentUserKey];
        if (jsonString) {
            NSLog(@"User:currentUser jsonString is valid");
            _currentUser = [[User alloc] initWithDictionary:[jsonString objectFromJSONString]];
        }
    }
    
    return _currentUser;
}

+ (void)setCurrentUser:(User *)currentUser {
    NSLog(@"User:setCurrentUser called");
    if (currentUser) {
        NSLog(@"User:setCurrentUser currentUser valid");
        [[NSUserDefaults standardUserDefaults] setObject:[currentUser JSONString] forKey:kCurrentUserKey];
    } else {
        NSLog(@"User:setCurrentUser currentUser invalid");
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCurrentUserKey];
        [TwitterClient instance].accessToken = nil;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (!_currentUser && currentUser) {
        NSLog(@"User:setCurrentUser fire UserDidLoginNotification");
        _currentUser = currentUser; // Needs to be set before firing the notification
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLoginNotification object:nil];
    } else if (_currentUser && !currentUser) {
        NSLog(@"User:setCurrentUser fire UserDidLogoutNotification");
        _currentUser = currentUser; // Needs to be set before firing the notification
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
    }
}

@end
