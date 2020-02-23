//
//  ViewController.m
//  JKDisPatchTimer
//
//  Created by Qingqing on 2020/2/22.
//  Copyright © 2020 Qingqing. All rights reserved.
//

#import "ViewController.h"
#import "JKDispatchTimer.h"

@interface ViewController ()
@property (nonatomic, strong) JKDispatchTimer *timer;
@property (nonatomic, strong) dispatch_source_t timers;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)start:(UIButton *)sender {
    [self.timer start];
}
- (IBAction)suppend:(UIButton *)sender {
    [self.timer suspend];
}
- (IBAction)cancel:(UIButton *)sender {
    [self.timer cancel];
}

- (JKDispatchTimer *)timer {
    if (!_timer) {
        _timer = [JKDispatchTimer dispatchTimerSeconds:0.2 handler:^(JKDispatchTimer *timer) {
            NSLog(@"timer");
        }];
    }
    return _timer;
}
- (void)dealloc {
    NSLog(@"%s", __func__);
}
@end
