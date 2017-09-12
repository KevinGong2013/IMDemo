//
//  KGLoginViewController.m
//  RongCloud
//
//  Created by GongXiang on 7/25/16.
//  Copyright © 2016 Kevin.Gong. All rights reserved.
//

#import "KGLoginViewController.h"
#import <ChameleonFramework/Chameleon.h>
#import <RongIMKit/RongIMKit.h>
#import "KGConversationListViewController.h"

@interface KGLoginViewController ()

@property (nonatomic, weak) IBOutlet UIButton *iceyButton;
@property (nonatomic, weak) IBOutlet UIButton *kevinButton;

@end

@implementation KGLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _iceyButton.layer.borderColor = FlatPink.CGColor;
    _kevinButton.layer.borderColor = FlatBlueDark.CGColor;

}

- (IBAction)selectIcey:(UIButton *)sender {

    [self connectWithToken:@"MI90XgL0Ohpgdd64Z+C2/T1KO/OEY3APmsRs1FTVl+ZIG2Q+0Qm7YrxmkmVsRSqLWe6WPgpFl7su0JlKLOT29A==" sender:sender];
}

- (IBAction)selectKevin:(UIButton *)sender {

    [self connectWithToken:@"JWvTKVio0weoiq9h8Heq+WaHbSvHuLAAuiEzPGZAiDIIgL5Rz+rmMuV6l8dH7djeUMp/6WI1Z41eh9406qLzzg==" sender:sender];
}

- (void)connectWithToken:(NSString *)token sender:(UIButton *)sender {

    sender.enabled = false;
    [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
        sender.enabled = true;
        [self loginSuccess:token];
    } error:^(RCConnectErrorCode status) {
        sender.enabled = true;
        if (status == RC_CONNECTION_EXIST) {
            [self loginSuccess:token];
        } else {
            NSLog(@"[Error] RCConnectErrorCode %ld", (long)status);
        }
    } tokenIncorrect:^{
        sender.enabled = true;
        NSLog(@"[Error] tokenIncorrect");
    }];
}

- (void)loginSuccess:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"com.kevin.token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion: nil];
    });
}

@end
