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

@interface ViewController ()

- (void)hideUserInfo:(BOOL)shouldHide;
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
    
    self.imgProfilePicture.layer.masksToBounds = YES;
    self.imgProfilePicture.layer.cornerRadius = 30.0;
    self.imgProfilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imgProfilePicture.layer.borderWidth = 1.0;
    
    [self hideUserInfo:NO];
    self.activityIndicator.hidden = YES;
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleLoginState:(id)sender {
    
}

-(void)hideUserInfo:(BOOL)shouldHide{
    self.imgProfilePicture.hidden = shouldHide;
    self.lblFullname.hidden = shouldHide;
    self.lblEmail.hidden = shouldHide;
}

@end
