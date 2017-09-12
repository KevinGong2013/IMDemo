//
//  KGRecallMessage.m
//  RongCloud
//
//  Created by GongXiang on 7/26/16.
//  Copyright © 2016 Kevin.Gong. All rights reserved.
//

#import "KGRecallMessage.h"

@implementation KGRecallMessage

- (instancetype)initWithBeRecalledUId:(NSString *)uid {
    self = [super init];
    if (self) {
        _beRecalledMessageUId = uid;
    }
    return self;
}

// RCMessageCoding
- (NSData *)encode {
    return [NSJSONSerialization dataWithJSONObject:@{@"uid": _beRecalledMessageUId} options:NSJSONWritingPrettyPrinted error:nil];
}

- (void)decodeWithData:(NSData *)data {

    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    _beRecalledMessageUId = (NSString *)dic[@"uid"];
}

+ (NSString *)getObjectName {
    return NSStringFromClass([self class]);
}

//RCMessagePersistentCompatible
+ (RCMessagePersistent)persistentFlag {
    return  MessagePersistent_ISPERSISTED;
}

//RCMessageContentView
- (NSString *)conversationDigest {
    return  @"[撤回消息]";
}

@end
