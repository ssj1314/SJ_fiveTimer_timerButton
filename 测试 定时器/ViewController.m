//
//  ViewController.m
//  测试 定时器
//
//  Created by ssj on 2017/3/20.
//  Copyright © 2017年 jiteng. All rights reserved.
//

#import "ViewController.h"
#import "SSJTimeBtn.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet SSJTimeBtn *begin;
@property (nonatomic,strong)CADisplayLink * displayLink;
//@property (nonatomic,weak)NSTimer *timer;

/** 定时器(这里不用带*，因为dispatch_source_t就是个类，内部已经包含了*) */
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //CADisplayLink 有两种模式注册到 runloop
   // NSDefaultRunLoopMode当进行其他 UI 刷新操作会停止定时器
   // NSRunLoopCommonModes当进行其他 UI 刷新操作不会停止定时器
    //1. CADisplayLink 定时器
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(CADtest)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    // 2 延迟调用
    //[self performSelector:@selector(CADtest) withObject:nil afterDelay:10];
    
    // 3 定时器 NSTimer
  //self.timer =  [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(CADtest) userInfo:nil repeats:YES];
   // [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
   // 4 GCD   定时器
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 
    });
    
    
    
    //5 GCD 中 非常精确的定时器  因为比较少用,比较消耗性能
    // 创建一个队列
    dispatch_queue_t quene = dispatch_get_global_queue(0, 0);
    // 创建一个 GCD 的定时器
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    
    // 设置定时器的开始时间 间隔时间 以及 精确度
    //设置开始时间 三秒钟之后调用
    /* 关键词解释：
    
    • NSEC：纳秒。
    
    • USEC：微妙。
    
    • SEC：秒
    
    • PER：每
    
    所以：
    
    1.NSEC_PER_SEC，每秒有多少纳秒。
    
    2.USEC_PER_SEC，每秒有多少毫秒。（注意是指在纳秒的基础上）
    
    3.NSEC_PER_USEC，每毫秒有多少纳秒。
    
    1 秒可以写成如下几种： 
    
    1 * NSEC_PER_SEC
    
    1000 * USEC_PER_SEC
    
*/
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 3.0 *NSEC_PER_SEC);
    //设置定时器的间隔时间
    uint64_t intevel = 1.0 *NSEC_PER_SEC;
    /*
      第一个参数 : 要给哪个定时器设置
      第二个参数 : 定时器的开始时间 DISPATCH_TIME_NOW 标识从当前开始
      第三个参数 : 定时器的调用方法的间隔时间
      第四个参数 : 定时器的精准度,如果传 0 则表示采用最精准的方式计算,如果传 大于 0 的数值,则表示该定时切换 i 可以接收 该值范围内的误差 , 通常传 0
      该参数的意思 : 可以适当的提高程序的性能
     注意点 : GCD 行使其中的时间 以纳秒 为单位 (面试点)
     
     
     */
    dispatch_source_set_timer(timer, start, intevel, 0*NSEC_PER_SEC);
    
    // 设置定时器开启后 回调的方法
    /*
     第一个参数 : 要给哪个定时器设置
     第二个参数 : 回调 block
     */
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"------%@",[NSThread currentThread]);
    });
    //执行定时器
    dispatch_resume(timer);
    
    //注意 : dispatch_source_t 本质上是 OC 类 ,在这里是个局部变量 , 需要强引用
    self.timer = timer;
}



- (IBAction)定时器测试:(SSJTimeBtn *)sender {
    
    [sender setSJTimeButtonWithDuration:50 runingColor:[UIColor grayColor] runingTextColor:[UIColor whiteColor] runingImgName:nil formatStr:@"还剩%zd秒了" buStatus:^(ssjStatus status) {
       
        if (status == ssjStatusRuning){
            NSLog(@"计时中!!!");
        }else if (status == ssjStatusCancel){
            NSLog(@"🐔时 手动结束了 ,没有超时");
        
        }else if (status == ssjStatusFinish){
            NSLog(@"计时结束了 没有超时");
        
        }
        if (status==ssjStatusRuning) {
            //计时中
        }else if (status==ssjStatusCancel){
            //结束了（手动结束了，没有超时）
        }else if (status==ssjStatusFinish){
            //计时结束了 超时了
        }
       
    }];
    
    [sender beginTimes];
}

- (IBAction)stop:(UIButton *)sender {
    
    [_begin stopTimes];
    self.displayLink.paused = NO;
    [self.displayLink invalidate];
}
- (void)CADtest{

    NSLog(@"CADone11111");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
