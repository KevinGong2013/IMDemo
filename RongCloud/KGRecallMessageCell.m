//
//  KGRecallMessageCell.m
//  RongCloud
//
//  Created by GongXiang on 7/26/16.
//  Copyright © 2016 Kevin.Gong. All rights reserved.
//

#import "KGRecallMessageCell.h"
#import <Masonry/Masonry.h>

@interface KGRecallMessageCell()

@property (nonatomic, weak) RCTipLabel *tipLabel;

@end

@implementation KGRecallMessageCell

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {

    RCTipLabel *l = [RCTipLabel greyTipLabel];

    [self.baseContentView addSubview:l];
    [l mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.equalTo(self.baseContentView.mas_centerX);
    }];
    
    _tipLabel = l;
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];

    // TODO 获取具体的名字
    if (model.messageDirection == MessageDirection_SEND) {
        self.tipLabel.text = @"你撤回了一条消息";
    } else {
        self.tipLabel.text = @"他撤回了一条消息";
    }
}

@end
