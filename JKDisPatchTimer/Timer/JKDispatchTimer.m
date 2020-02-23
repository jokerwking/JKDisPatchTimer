//
//  JKDispatchTimer.m
//  JKDisPatchTimer
//
//  Created by Qingqing on 2020/2/22.
//  Copyright © 2020 Qingqing. All rights reserved.
//

#import "JKDispatchTimer.h"

@interface JKDispatchTimer ()
@property (nonatomic, assign) NSTimeInterval seconds;
@property (nonatomic, copy) TimerBlock timerHandler;
@property (nonatomic, strong) dispatch_source_t source;
@end

struct StatusBool {
    BOOL runing: 1;
    BOOL suspend: 1;
} StatusBool;

@implementation JKDispatchTimer

+ (instancetype)dispatchTimerSeconds:(NSTimeInterval)seconds handler:(TimerBlock)handler {
    JKDispatchTimer *timer = [JKDispatchTimer new];
    timer.seconds = seconds;
    timer.timerHandler = handler;
    [timer setSource];
    return timer;
}

- (void)setSource {
    dispatch_queue_t queue = dispatch_queue_create("com.jkdispatchtimer.source", DISPATCH_QUEUE_CONCURRENT);
    self.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, queue);

    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.source, ^{
        __strong typeof(weakSelf) self = weakSelf;
        self.timerHandler(self);
    });
    
    dispatch_resume(self.source);
    StatusBool.runing = YES;
}

- (void)start {
    if (!StatusBool.runing) {
        dispatch_resume(self.source);
    }
    StatusBool.runing = YES;
    StatusBool.suspend = NO;
    dispatch_async(dispatch_queue_create("com.jkdispatchtimer.queue", NULL), ^{
        do {
            dispatch_source_merge_data(self.source, 1);
            sleep(self.seconds);
        } while (StatusBool.runing);
    });
}

- (void)suspend {
    dispatch_suspend(self.source);
    StatusBool.runing = NO;
    StatusBool.suspend = YES;
}

- (void)cancel {
    if (StatusBool.suspend) {
        dispatch_resume(self.source);
    }
    dispatch_source_cancel(self.source);
    StatusBool.runing = NO;
    StatusBool.suspend = NO;
}


- (void)dealloc {
    NSLog(@"%s", __func__);
    if (StatusBool.suspend) {
        dispatch_resume(self.source);
        dispatch_source_cancel(self.source);
    }
}
@end

