//
//  KGConversationViewController.m
//  RongCloud
//
//  Created by GongXiang on 7/25/16.
//  Copyright © 2016 Kevin.Gong. All rights reserved.
//

#import "KGConversationViewController.h"
#import <ChameleonFramework/Chameleon.h>
#import "KGLuckMoneyMessage.h"
#import "KGLuckMoneyMessageCell.h"
#import "KGRecallMessage.h"
#import "KGRecallMessageCell.h"
#import <RongIMLib/RongIMLib.h>

@interface KGConversationViewController(ReceiveMessageDelegate) <RCIMReceiveMessageDelegate>

@end

@implementation KGConversationViewController (ReceiveMessageDelegate)

- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {

    if ([message.objectName isEqualToString:[KGRecallMessage getObjectName]]) {
        KGRecallMessage *rm = (KGRecallMessage *)message.content;
        RCMessage *rcmessage = [[RCIMClient sharedRCIMClient] getMessageByUId:rm.beRecalledMessageUId];

        [self.conversationDataRepository enumerateObjectsUsingBlock:^(RCMessageModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {

            if (obj.messageId == rcmessage.messageId) {
                *stop = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self deleteMessage:obj];
                });
            }
        }];
    }
}

@end

@interface KGConversationViewController ()

@property (nonatomic, strong) RCMessageModel *longSelectModel;

@end

@implementation KGConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"luck-money"] title:@"红包" tag:2000];

    [self registerClass:[KGLuckMoneyMessageCell class] forCellWithReuseIdentifier:[KGLuckMoneyMessageCell identifier]];
    [self registerClass:[KGRecallMessageCell class] forCellWithReuseIdentifier:[KGRecallMessageCell identifier]];

    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
}

- (void)pluginBoardView:(RCPluginBoardView *)pluginBoardView clickedItemWithTag:(NSInteger)tag {

    if (tag == 2000) {
// TODO: 这里应该弹出发红包的页面，以及处理红包逻辑
        [[RCIM sharedRCIM] sendMessage:self.conversationType targetId:self.targetId content:[[KGLuckMoneyMessage alloc] initWith:200 description:@"学业有成～"] pushContent:@"您一条新的红包消息" pushData:@"{\"cid\": 1234567 }" success:^(long messageId) {

        } error:^(RCErrorCode nErrorCode, long messageId) {

        }];

    } else {
        [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    }
}

- (RCMessageBaseCell *)rcConversationCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    RCMessageModel *m = self.conversationDataRepository[indexPath.item];

    if ([m.objectName isEqualToString:[KGLuckMoneyMessage getObjectName]]) {
        KGLuckMoneyMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[KGLuckMoneyMessageCell identifier] forIndexPath:indexPath];
        [cell setDataModel:m];
        cell.conversationViewController = self;
        return cell;
    } else if ([m.objectName isEqualToString:[KGRecallMessage getObjectName]]) {

        KGRecallMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[KGRecallMessageCell identifier] forIndexPath:indexPath];
        [cell setDataModel:m];
        return cell;
    } else {
        return [self rcUnkownConversationCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
}

- (CGSize)rcConversationCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    RCMessageModel *m = self.conversationDataRepository[indexPath.item];

    if ([m.objectName isEqualToString:[KGLuckMoneyMessage getObjectName]]) {
        CGFloat h = 130 + (m.isDisplayNickname ? 20 : 0) + (m.isDisplayMessageTime ? 20 : 0);
        return CGSizeMake(collectionView.frame.size.width, h);
    } else if ([m.objectName isEqualToString:[KGRecallMessage getObjectName]]) {
        return  CGSizeMake(collectionView.frame.size.width, 40 + (m.isDisplayMessageTime ? 20 : 0));
    } else {
        return [self rcUnkownConversationCollectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
}

//- (void)didTapMessageCell:(RCMessageModel *)model {
//
//    if ([model.objectName isEqualToString:[KGLuckMoneyMessage getObjectName]]) {
//        UIViewController *vc = [UIViewController new];
//        vc.view.backgroundColor = [UIColor randomFlatColor];
//        [self.navigationController pushViewController:vc animated:YES];
//    } else {
//        [super didTapMessageCell:model];
//    }
//}
//
- (void)didLongTouchMessageCell:(RCMessageModel *)model inView:(UIView *)view {
    _longSelectModel = nil;
    [super didLongTouchMessageCell:model inView:view];

    UIMenuController *mvc = [UIMenuController sharedMenuController];
    UIMenuItem *recallItem = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(recall:)];

    if (mvc.menuVisible) {
        NSMutableArray *items = [NSMutableArray arrayWithArray:mvc.menuItems];
        [items addObject:recallItem];
        [mvc setMenuItems:items];
    } else {
        [mvc setMenuItems:@[recallItem]];
    }
    [mvc setMenuVisible:YES animated:YES];
    _longSelectModel = model;
}

- (void)recall:(id)sender {
    if (self.longSelectModel) {

        RCMessage *rm = [[RCIMClient sharedRCIMClient] getMessage:self.longSelectModel.messageId];

        [[RCIM sharedRCIM] sendMessage:self.conversationType targetId:self.targetId content:[[KGRecallMessage alloc] initWithBeRecalledUId:rm.messageUId] pushContent:@"" pushData:@"" success:^(long messageId) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self deleteMessage:self.longSelectModel];
            });
        } error:^(RCErrorCode nErrorCode, long messageId) {

        }];
    }
}

@end
