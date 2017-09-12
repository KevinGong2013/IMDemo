//
//  KGUserDataSource.m
//  RongCloud
//
//  Created by GongXiang on 7/26/16.
//  Copyright © 2016 Kevin.Gong. All rights reserved.
//

#import "KGUserDataSource.h"

@interface KGUserDataSource()

@property (nonatomic, strong) RCUserInfo *icey;
@property (nonatomic, strong) RCUserInfo *kevin;

@end

@implementation KGUserDataSource

- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion {

    if ([[userId lowercaseString] isEqualToString:@"icey"]) {
        completion(self.icey);
    } else {
        completion(self.kevin);
    }
}

- (RCUserInfo *)icey {
    if (!_icey) {
        _icey = [[RCUserInfo alloc] initWithUserId:@"Icey" name:@"Icey.Test" portrait:@"http://touxiang.qqzhi.com/uploads/2012-11/1111104151660.jpg"];
    }
    return _icey;
}

- (RCUserInfo *)kevin {
    if (!_kevin) {
        _kevin = [[RCUserInfo alloc] initWithUserId:@"Kevin" name:@"Kevin.Test" portrait:@"http://touxiang.qqzhi.com/uploads/2012-11/1111014928675.jpg"];
    }
    return _kevin;
}

@end
