//
//  SSJTimeBtn.m
//  测试 定时器
//
//  Created by ssj on 2017/3/20.
//  Copyright © 2017年 jiteng. All rights reserved.
//

#import "SSJTimeBtn.h"
#import <objc/runtime.h>

@interface SSJTimeBtn ()

/**
 控件的状态
 */
@property (nonatomic,assign)ssjStatus statusType;

/**
 计时的时间
 */
@property (nonatomic,assign)NSInteger timeCount;

/**
 计时的原始时间
 */
@property (nonatomic,assign)NSInteger oldTimeCount;

/**
 计时器
 */
@property (nonatomic,weak) NSTimer *timer;

/**
 按钮的初始背景色
 */
@property (nonatomic,strong)UIColor *normalBgColor;

/**
 按钮的初始背景图片
 */
@property (nonatomic,strong)UIImage* normalBgImg;

/**
 按钮默认情况下的文字颜色
 */
@property (nonatomic,strong)UIColor *normaltextColor;

/**
 按钮默认情况下的文字
 */
@property (nonatomic,copy)NSString *normalText;
@end

// 用于关联 Block
static void *statusBlockKey = @"statusBlockKey";
@implementation SSJTimeBtn

// 重写 buttonWithType 方法 UIButtonTypeCustom 按钮计时改变的时候不会闪动
+ (instancetype)buttonWithType:(UIButtonType)buttonType{

    return [super buttonWithType:UIButtonTypeCustom];
}

/**
 设置计时按钮的时长和状态的回调

 @param durtaion 时间 单位秒
 @param bustatus 状态的回调
 */
- (void)setSJTimerButtonWithDuration:(NSInteger)durtaion buStatus:(void (^)(ssjStatus))bustatus{
    _timeCount      = durtaion;
    _oldTimeCount   = durtaion;
    _statusType     = ssjStatusNone;
    
    objc_setAssociatedObject(self, statusBlockKey, bustatus, OBJC_ASSOCIATION_COPY);
    
    bustatus(ssjStatusNone);

}

- (void)setSJTimeButtonWithDuration:(NSInteger)duration runingColor:(UIColor *)runingColor runingTextColor:(UIColor *)runingTextColr runingImgName:(NSString *)runingImgName formatStr:(NSString *)formatStr buStatus:(void (^)(ssjStatus))bustatus{


    _runningImageName = runingImgName;
    _runningColor     = runingColor;
    _runningTextColor = runingTextColr;
    _formatStr        = formatStr;
    
    [self setSJTimerButtonWithDuration:duration buStatus:^(ssjStatus status) {
        bustatus(status);
    }];

    
    
}

- (void)beginTimes{

    if (!self.timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(next) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
        self.timer = timer;
    }
    // 更新时间
    _timeCount = _oldTimeCount;
    // 记录按钮的原始状态
    _normalBgColor = self.backgroundColor;
    _normalBgImg   = self.currentBackgroundImage;
    _normaltextColor = self.currentTitleColor;
    _normalText      = self.currentTitle;
    
    // 设置按钮计时时的样式
    if (_runningColor) {
        [self setBackgroundColor:_runningColor];
    }
    if (_runningImageName.length > 0) {
        [self setBackgroundImage:[UIImage imageNamed:_runningImageName] forState:UIControlStateNormal];
    }
    if (_runningTextColor) {
        [self setTitleColor:_runningTextColor forState:UIControlStateNormal];
    }
    
    // 让按钮不可以点击
    self.userInteractionEnabled = NO;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self next];
    
    void (^statusBlock)(NSUInteger) = objc_getAssociatedObject(self, statusBlockKey);
    statusBlock(ssjStatusRuning);
    
}

/**
 结束计时
 */
-(void)stopTimes{

    [self.timer invalidate];
    self.timer = nil;
    
    void(^statusBlock)(NSInteger) = objc_getAssociatedObject(self, statusBlockKey);
    
    if (_timeCount == 0) {
        // 超时了
        statusBlock(ssjStatusFinish);
    }else{
    // 结束了 但是没有超时
        statusBlock(ssjStatusCancel);
    
    }

    // 还原按钮的样式
    [self setBackgroundImage:_normalBgImg forState:UIControlStateNormal];
    [self setBackgroundColor:_normalBgColor];
    [self setTitleColor:_normaltextColor forState:UIControlStateNormal];
    [self setTitle:_normalText forState:UIControlStateNormal];
    
    self.userInteractionEnabled = YES;
    
}
- (void)next{
    
    
    if (_timeCount < 1) {
        //计时结束 超时了
        [self stopTimes];
    }else{
        // 改文字
        if (_formatStr.length > 0) {
            [self setTitle:[NSString stringWithFormat:_formatStr,_timeCount] forState:UIControlStateNormal];
        }else{
        
            [self setTitle:[NSString stringWithFormat:@"%zdS",_timeCount] forState:UIControlStateNormal];
        
        }
        _timeCount --;
    
    }

}
@end
