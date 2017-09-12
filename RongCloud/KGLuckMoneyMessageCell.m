//
//  KGLuckMoneyMessageCell.m
//  RongCloud
//
//  Created by GongXiang on 7/26/16.
//  Copyright © 2016 Kevin.Gong. All rights reserved.
//

#import "KGLuckMoneyMessageCell.h"
#import <ChameleonFramework/Chameleon.h>
#import <Masonry/Masonry.h>
#import "KGLuckMoneyMessage.h"
#import "KGConversationViewController.h"

@interface KGLuckMoneyMessageCell()

@property (nonatomic, assign) CGSize defaultSize;

@property (nonatomic, weak) UILabel *descLabel;
@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UILabel *amountLabel;

@end


@implementation KGLuckMoneyMessageCell

+ (NSString *)identifier {
    return NSStringFromClass([self class]);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _defaultSize = CGSizeMake(200, 90);
        [self commonInit];
    }
    return self;
}

- (void)commonInit {

    __weak typeof(&*self) weakSelf = self;

    [self.messageContentView setEventBlock:^(CGRect rect) {
        if (!CGSizeEqualToSize(rect.size, weakSelf.defaultSize)) { return; }
        if (!weakSelf.model) { return; }

        BOOL isOutgoing = weakSelf.model.messageDirection == MessageDirection_SEND;

        CGRect newRect = CGRectMake(isOutgoing ? 0 : 5, 0,
                                    rect.size.width - 5, rect.size.height);

        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:4];
        [path moveToPoint:CGPointMake(isOutgoing ? rect.size.width - 5 : 5, 10)];
        [path addLineToPoint:CGPointMake(isOutgoing ? rect.size.width : 0, 14)];
        [path addLineToPoint:CGPointMake(isOutgoing ? rect.size.width - 5 : 5, 18)];

        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.path = path.CGPath;

        weakSelf.messageContentView.layer.mask = layer;
    }];

    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];

    UILabel *descLabel = [UILabel new];
    [descLabel setFont:[UIFont systemFontOfSize:12]];
    [descLabel setTextColor:[UIColor darkGrayColor]];
    [descLabel setTextAlignment:NSTextAlignmentLeft];
    [bottomView addSubview:descLabel];
    _descLabel = descLabel;

    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(10);
    }];

    [self.messageContentView addSubview:bottomView];
    _bottomView = bottomView;

    UILabel *amountLabel = [UILabel new];
    [amountLabel setFont:[UIFont boldSystemFontOfSize:30]];
    [amountLabel setTextColor:[UIColor whiteColor]];
    [amountLabel setTextAlignment:NSTextAlignmentLeft];
    [self.messageContentView addSubview:amountLabel];
    _amountLabel = amountLabel;

    [self.messageContentView setBackgroundColor:[UIColor flatRedColor]];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMessageContentView:)];
    [self.messageContentView addGestureRecognizer:tap];
}

- (void)updateConstraints {

    BOOL isOutgoing = self.model.messageDirection == MessageDirection_SEND;
    // 更新bottomView 位置
    CGSize dSize = CGSizeMake(self.defaultSize.width - 5, 34);
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(dSize);
        make.bottom.mas_equalTo(0);
        make.left.mas_offset(isOutgoing ? 0 : 5);
    }];

    [self.amountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(isOutgoing ? 10 : 15);
    }];

    [super updateConstraints];
}

- (void)onTapMessageContentView:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [_conversationViewController didTapMessageCell:self.model];
    }
}

- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];

    CGRect frame = self.messageContentView.frame;
    frame.size = self.defaultSize;
    self.messageContentView.frame = frame;

    KGLuckMoneyMessage *m = (KGLuckMoneyMessage *) model.content;

    self.descLabel.text = m.desc;

    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];

    [nf setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
    [nf setNumberStyle:NSNumberFormatterCurrencyAccountingStyle];
    [nf setMinimumFractionDigits:2];

    self.amountLabel.text = [nf stringFromNumber:@(m.amount)];
}

@end

#if DEBUG

@interface UITextView(RCTextView)

@end

@implementation UITextView (RCTextView)

- (void)_firstBaselineOffsetFromTop { }
- (void)_baselineOffsetFromBottom { }

@end

#endif


