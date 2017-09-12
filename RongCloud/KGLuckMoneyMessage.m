//
//  KGLuckMoneyMessage.m
//  RongCloud
//
//  Created by GongXiang on 7/26/16.
//  Copyright © 2016 Kevin.Gong. All rights reserved.
//

#import "KGLuckMoneyMessage.h"

@implementation KGLuckMoneyMessage

- (instancetype)initWith:(double)amount description:(NSString *)desc {
    if ([super init]) {
        _amount = amount;
        _desc = desc;
    }

    return self;
}

// RCMessageCoding
- (NSData *)encode {
    return [NSJSONSerialization dataWithJSONObject:@{@"amount": @(_amount), @"desc": _desc} options:NSJSONWritingPrettyPrinted error:nil];
}

- (void)decodeWithData:(NSData *)data {

    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    _amount =  [(NSNumber *)dic[@"amount"] doubleValue];
    _desc = (NSString *)dic[@"desc"];
}

+ (NSString *)getObjectName {
    return NSStringFromClass([self class]);
}

//RCMessagePersistentCompatible
+ (RCMessagePersistent)persistentFlag {
    return  MessagePersistent_ISCOUNTED;
}

//RCMessageContentView
- (NSString *)conversationDigest {
    return  @"[RongCloud 红包]";
}

@end
