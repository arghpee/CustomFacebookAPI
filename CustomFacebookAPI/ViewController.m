//
//  ViewController.m
//  CustomFacebookAPI
//
//  Created by Rizza on 6/10/15.
//  Copyright (c) 2015 Rizza Corella Punsalan. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"

@interface ViewController ()

- (void)hideUserInfo:(BOOL)shouldHide;
- (BOOL)isUserLoggedIn;
- (void)setUserInfo;
- (void)logInUser;
- (void)logOutUser;

@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    /* Make the image view round */
    self.imgProfilePicture.layer.masksToBounds = YES;
    self.imgProfilePicture.layer.cornerRadius = 30.0;
    self.imgProfilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imgProfilePicture.layer.borderWidth = 1.0;
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    /* Check if user is logged in */
    if ([self isUserLoggedIn]) {
        [self.btnToggleLoginState setTitle:@"Log Out" forState:UIControlStateNormal];
        self.lblStatus.text = @"You are now logged in.";
        [self setUserInfo];
        [self hideUserInfo:NO];
    }
    else {
        [self.btnToggleLoginState setTitle:@"Log In" forState:UIControlStateNormal];
        self.lblStatus.text = @"You are not logged in.";
        [self hideUserInfo:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)toggleLoginState:(id)sender {
    if ([self isUserLoggedIn]) { // User wants to log out
        [self logOutUser];
    }
    else { // User wants to log in
        [self logInUser];
    }
}

-(void)hideUserInfo:(BOOL)shouldHide{
    self.imgProfilePicture.hidden = shouldHide;
    self.lblFullname.hidden = shouldHide;
    self.lblEmail.hidden = shouldHide;
    self.lblGender.hidden = shouldHide;
}

- (BOOL) isUserLoggedIn {
    return [FBSDKAccessToken currentAccessToken];
}

- (void) setUserInfo {
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             NSLog(@"fetched user:%@", result);
             [self hideUserInfo:NO];
             self.lblEmail.text = [result objectForKey:@"email"];
             self.lblFullname.text = [result objectForKey:@"name"];
             self.lblStatus.text = @"You are now logged in.";
             self.lblGender.text = [result objectForKey:@"gender"];
             [self.imgProfilePicture setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[result objectForKey:@"id"]]]
                                 placeholderImage:[UIImage imageNamed:@"unknownUser.png"]];
             
         }
     }];
}

- (void) logInUser {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"An error occured while logging in. Please try again."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
        } else if (result.isCancelled) {
            NSLog(@"Result was cancelled.");
        } else {
            if ([result.grantedPermissions containsObject:@"email"]) {
                [self.btnToggleLoginState setTitle:@"Log Out" forState:UIControlStateNormal];
                [self setUserInfo];
                [self hideUserInfo:NO];
            }
        }
    }];
}

- (void) logOutUser {
    [self.btnToggleLoginState setTitle:@"Log In" forState:UIControlStateNormal];
    [self hideUserInfo:YES];
    self.lblStatus.text = @"You are not logged in.";
    [FBSDKAccessToken setCurrentAccessToken:nil];
}

@end
