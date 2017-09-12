//
//  KGConversationListViewController.m
//  RongCloud
//
//  Created by GongXiang on 7/25/16.
//  Copyright © 2016 Kevin.Gong. All rights reserved.
//

#import "KGConversationListViewController.h"
#import "KGConversationViewController.h"
#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>

@interface KGConversationListViewController ()

@end

@implementation KGConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.conversationListTableView.tableFooterView = [UIView new];
    self.showConnectingStatusOnNavigatorBar = YES;
    self.isShowNetworkIndicatorView = NO;
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath {

    KGConversationViewController *vc = [[KGConversationViewController alloc] initWithConversationType:model.conversationType targetId:model.targetId];
    vc.title = model.targetId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onTapSwitchAccount:(id)sender {

    [[RCIM sharedRCIM] logout];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"com.kevin.token"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LaunchSelectVC"];
    [self.navigationController setViewControllers:@[vc] animated:YES];
}

- (IBAction)onTapAddItem:(id)sender {

    NSString *targetId = @"Icey";

    if ([[[RCIMClient sharedRCIMClient] currentUserInfo].userId isEqualToString:targetId]) {
        targetId = @"Kevin";
    }

    KGConversationViewController *vc = [[KGConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:targetId];
    vc.title = targetId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
