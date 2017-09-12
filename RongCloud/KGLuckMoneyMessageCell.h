//
//  KGLuckMoneyMessageCell.h
//  RongCloud
//
//  Created by GongXiang on 7/26/16.
//  Copyright © 2016 Kevin.Gong. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@class KGConversationViewController;

@interface KGLuckMoneyMessageCell : RCMessageCell

@property (nonatomic, weak) KGConversationViewController *conversationViewController;

+ (NSString *)identifier;

@end
