//
//  TimerManager.m
//  Timer
//
//  Created by gaomin on 2021/1/27.
//

#import <UIKit/UIKit.h>
#import "TimerManager.h"
#import "GCDTimer.h"
#import "TimerHelper.h"


@interface TimerManager ()

@property (nonatomic, strong, readwrite) TimerOptions *options;
@property (nonatomic, strong) GCDTimer *timer;
@property (nonatomic, strong) NSHashTable *timerHelpers;
@property (nonatomic, assign) BOOL isInit;

@end

@implementation TimerManager

+ (instancetype)sharedManager {
    static TimerManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TimerManager alloc] init];
    });
    return instance;
}



- (void)doInit {
    
    if (!_isInit) {
        _isInit = YES;
        _timerHelpers = [NSHashTable weakObjectsHashTable];
        _timer = [GCDTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(GCDTimer * _Nonnull timer) {
            [self timerThrob];
        }];
        [self checkManagerHelpersCount];
    }
}

- (void)checkManagerHelpersCount {
    if (!_isInit) return;
    NSHashTable *timerHelpers = self.timerHelpers.copy;
    BOOL finish = YES;
    for (id <TimerHelper> helper in timerHelpers) {
        if (!helper.finish) {
            finish = NO;
            break;
        }
    }
    if (finish) {
        [self.timer suspend];
    }else {
        [self.timer resume];
    }
    
    __weak typeof(self) _self = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_self checkManagerHelpersCount];
    });
}


- (void)timerThrob {
    NSHashTable *timerHelpers = self.timerHelpers.copy;
    for (id <TimerHelper> helper in timerHelpers) {
        if (helper && [helper respondsToSelector:@selector(timerHelperThrob)] && !helper.finish) {
            [helper timerHelperThrob];
        }
    }
}



- (void)addTimerHelper:(id<TimerHelper>)timerHelper {
    if (!timerHelper) return;
    [self doInit];
    @synchronized (self) {
        if (![self.timerHelpers containsObject:timerHelper]) {
            [self.timerHelpers addObject:timerHelper];
        }
    }
    [self.timer resume];
}

- (void)removeTimerHelper:(id<TimerHelper>)timerHelper {
    if (!timerHelper) return;
    @synchronized (self) {
        [self.timerHelpers removeObject:timerHelper];
    }
}

- (void)removeAllTimerHelper {
    @synchronized (self) {
        [self.timerHelpers removeAllObjects];
    }
    [self.timer suspend];
}


@end
