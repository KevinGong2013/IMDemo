//
//  KGRecallMessage.h
//  RongCloud
//
//  Created by GongXiang on 7/26/16.
//  Copyright © 2016 Kevin.Gong. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface KGRecallMessage : RCMessageContent

@property (nonatomic, strong) NSString *beRecalledMessageUId;

- (instancetype)initWithBeRecalledUId:(NSString *)uid;

@end
