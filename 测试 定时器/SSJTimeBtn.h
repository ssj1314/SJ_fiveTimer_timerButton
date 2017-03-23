//
//  SSJTimeBtn.h
//  测试 定时器
//
//  Created by ssj on 2017/3/20.
//  Copyright © 2017年 jiteng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ssjStatus) {

    ssjStatusNone,//没开始
    ssjStatusRuning,// 进行中
    ssjStatusCancel,// 结束了 (计时没有结束,没有超时)
    ssjStatusFinish,//计时结束了 超时了


};



@interface SSJTimeBtn : UIButton


/**
    正在计时按钮的背景颜色
 */
@property (nonatomic,strong)UIColor *runningColor;

/**
 正在计时按钮的文字的颜色
 */
@property (nonatomic,strong)UIColor *runningTextColor;

/**
 正在计时时的图片
 */
@property (nonatomic,copy)NSString *runningImageName;

/**
 格式化文字 例如 (剩余时间 %zd 秒)
 */
@property (nonatomic,copy)NSString *formatStr;


/**
 设置计时按钮的时长 和 状态的回调 (和下面的方法只用一个就行)

 @param durtaion 时间 单位秒
 @param bustatus 状态的回调
 */

- (void)setSJTimerButtonWithDuration:(NSInteger)durtaion buStatus:(void(^)(ssjStatus status))bustatus;


/**
 初始化的方法 (和上面的方法只用一个就行)

 @param duration            时间
 @param runingColor         正在计时按钮的背景颜色
 @param runingTextColr      正在计时按钮的文字的颜色
 @param runingImgName       正在计时时的背景图片名
 @param formatStr           格式化的文字 (%zd 秒)
 @param bustatus            状态的回调
 */
- (void)setSJTimeButtonWithDuration:(NSInteger)duration runingColor:(UIColor *)runingColor runingTextColor:(UIColor *)runingTextColr runingImgName:(NSString *)runingImgName formatStr:(NSString *)formatStr buStatus:(void(^)(ssjStatus status))bustatus;
/**
 开始计时
 */
- (void)beginTimes;

/**
 结束结束
 */
- (void)stopTimes;
@end
