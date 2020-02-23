//
//  JKDispatchTimer.h
//  JKDisPatchTimer
//
//  Created by Qingqing on 2020/2/22.
//  Copyright © 2020 Qingqing. All rights reserved.
//
/// 当计时器被启动之后，必须调用`suspend`或者`cancel`方法  `JKDispatchTimer`对象才能正常的被释放。
#import <Foundation/Foundation.h>

@class JKDispatchTimer;

typedef void(^TimerBlock)(JKDispatchTimer *timer);

@interface JKDispatchTimer : NSObject
/// 计时器的便利构造器
/// @param seconds 计时秒数
/// @param handler 回调***这个回调是在子线程执行的
+ (instancetype)dispatchTimerSeconds:(NSTimeInterval)seconds handler:(TimerBlock)handler;
/// 启动
- (void)start;
/// 暂停
- (void)suspend;
/// 销毁
- (void)cancel;
@end
