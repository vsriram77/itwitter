//
//  SignedOutVC.m
//  itwitter
//
//  Created by Sriram Varadarajan on 8/18/13.
//  Copyright (c) 2013 Y.CORP.YAHOO.COM\vsriram. All rights reserved.
//


#import "SignedOutVC.h"
#import "TwitterClient.h"

@interface SignedOutVC ()

- (IBAction)onSignInButton:(id)sender;
- (void)onError;

@end

@implementation SignedOutVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"%@", @"SignedOutVC: viewDidLoad called");

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (IBAction)onSignInButton:(id)sender {
    NSLog(@"SignedOutVS:onSignInButton called...");

    [[TwitterClient instance] authorizeWithCallbackUrl:[NSURL URLWithString:@"cp-twitter://success"] success:^(AFOAuth1Token *accessToken, id responseObject) {
        NSLog(@"SignedOutVS:success callback called...");
        [[TwitterClient instance] currentUserWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
            NSLog(@"SignedOutVS:success callback called...");
            NSLog(@"response: %@", response);
            [User setCurrentUser:[[User alloc] initWithDictionary:response]];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"SignedOutVS:error callback called...");
            [self onError];
        }];
        NSLog(@"success!");
    } failure:^(NSError *error) {
        [self onError];
    }];
    NSLog(@"SignedOutVS:onSignInButton to exit...");
    
}

- (void)onError {
    NSLog(@"SignedOutVS:onError called...");

    [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Couldn't log in with Twitter, please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end
