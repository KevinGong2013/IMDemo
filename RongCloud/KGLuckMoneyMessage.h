//
//  KGLuckMoneyMessage.h
//  RongCloud
//
//  Created by GongXiang on 7/26/16.
//  Copyright © 2016 Kevin.Gong. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface KGLuckMoneyMessage : RCMessageContent

@property (nonatomic, assign) double amount;
@property (nonatomic, strong) NSString *desc;

- (instancetype)initWith:(double)amount description:(NSString *)desc;

@end
