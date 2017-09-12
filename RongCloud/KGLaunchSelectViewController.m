//
//  KGLaunchSelectViewController.m
//  RongCloud
//
//  Created by GongXiang on 7/25/16.
//  Copyright © 2016 Kevin.Gong. All rights reserved.
//

#import "KGLaunchSelectViewController.h"
#import "KGConversationListViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "KGLoginViewController.h"

@interface KGLaunchSelectViewController () <RCIMConnectionStatusDelegate>

@property (nonatomic, assign) BOOL needShowLoginVC;

@end

@implementation KGLaunchSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:@"com.kevin.token"];

    if ([token length] > 0 && [[RCIM sharedRCIM] getConnectionStatus] == ConnectionStatus_Unconnected) {
        [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {

        } error:^(RCConnectErrorCode status) {
            [self showLoginVC];
        } tokenIncorrect:^{
            [self showLoginVC];
        }];
    } else {
        _needShowLoginVC = true;
    }
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (_needShowLoginVC) {
        _needShowLoginVC = NO;
        [self showLoginVC];
    }
}

- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {

    if (status != ConnectionStatus_Connected) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showConversationVC];
        });
    }
}

- (void)showConversationVC {

    KGConversationListViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ConversationListVC"];

    vc.displayConversationTypeArray = @[@(ConversationType_PRIVATE)];

    [self.navigationController setViewControllers:@[vc]];
}

- (void)showLoginVC {
    [self performSegueWithIdentifier:@"ShowLoginVC" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {

    NSLog(@"KGLaunchSelectViewController dealloced !!");
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowLoginVC"]) {

        KGLoginViewController *vc = segue.destinationViewController;
        [vc setRootNavigationController:self.navigationController];
    }
}


@end
