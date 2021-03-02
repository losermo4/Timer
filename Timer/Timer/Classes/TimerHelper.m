//
//  TimerHelper.m
//  Timer
//
//  Created by gaomin on 2021/1/27.
//

#import <UIKit/UIKit.h>
#import "TimerHelper.h"
#import "TimerManager.h"
#import "TimerCallBack.h"

static double currentDate(void) {
    return [NSProcessInfo processInfo].systemUptime;
}


@interface TimerHelper ()
@property (nonatomic, assign, readwrite) TimerType timerType;
@property (nonatomic, assign, readwrite) TimerHelperCommonTypeStatus commonTypeStatus;
@property (nonatomic, assign, readwrite) NSTimeInterval runningInterval;
@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, strong) NSHashTable *callBacks;
@property (nonatomic, assign) BOOL stop;
@property (nonatomic, assign) NSTimeInterval initializeDate;

@property (nonatomic, assign) NSTimeInterval enterTime;


@end

@implementation TimerHelper
@synthesize timerType = _timerType;
@synthesize commonTypeStatus = _commonTypeStatus;
@synthesize runningInterval = _runningInterval;
@synthesize day = _day, hour = _hour, minute = _minute, second = _second, msec = _msec;



- (instancetype)initWithTimerType:(TimerType)timerType interval:(NSTimeInterval)interval {
    return [self initWithTimerType:timerType manager:TimerManager.sharedManager interval:interval];
}

- (instancetype)initWithTimerType:(TimerType)timerType manager:(TimerManager *)manager interval:(NSTimeInterval)interval {
    self = [super init];
    if (self) {
        self.timerType = timerType;
        self.interval = interval;
        _callBacks = [NSHashTable weakObjectsHashTable];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        _initializeDate = currentDate();
        [self doInit];
        [manager addTimerHelper:self];
    }
    return self;
}

- (void)updateInterval:(NSTimeInterval)interval {
    self.interval = interval;
    [self doInit];
}

- (void)doInit {
    [self calculate];
    [self callback];
}

- (void)run {
    self.runningInterval ++;
}


- (BOOL)calculate {
    if ((self.timerType & TimerTypeHelperMaskCommon) && (self.timerType & TimerTypeFrequencySecond)) {
        if (self.commonTypeStatus == TimerHelperCommonTypeStatusFinish) return NO;
        if (self.interval <= 0 || self.runningInterval >= self.interval * 10) {
            self.commonTypeStatus = TimerHelperCommonTypeStatusFinish;
        }else {
            self.commonTypeStatus = TimerHelperCommonTypeStatusRunning;
        }
        NSTimeInterval residue = MAX(self.interval - self.runningInterval/10, 0);
        NSInteger time = (NSInteger)floor(residue);
        _day = time / 3600 / 24;
        _hour = (time - _day * 24 * 3600) / 3600;
        _minute = (time - _day*24*3600- _hour*3600)/60;
        _second = time-_day*24*3600-_hour*3600-_minute*60;
//        _msec = (residue - time) * 10;
    }else if ((self.timerType & TimerTypeHelperMaskCommon) && (self.timerType & TimerTypeFrequencyTenthOfSecond)) {
        if (self.commonTypeStatus == TimerHelperCommonTypeStatusFinish) return NO;
        if (self.interval <= 0 || self.interval*10 <= self.runningInterval) {
            self.commonTypeStatus = TimerHelperCommonTypeStatusFinish;
        }else {
            self.commonTypeStatus = TimerHelperCommonTypeStatusRunning;
        }
        NSTimeInterval interval = self.interval * 10;
        NSTimeInterval runningInterval = self.runningInterval;
        NSTimeInterval residue = MAX(interval - runningInterval, 0);
        _day = (NSInteger)(residue/10/(3600*24));
        _hour = (NSInteger)((residue-_day*24*36000)/10/3600);
        _minute = (NSInteger)(residue-_day*24*36000-_hour*36000)/10/60;
        _second = (residue-_day*24*36000-_hour*36000-_minute*600)/10;
        _msec = residue-_day*24*36000-_hour*36000-_minute*600 - _second*10;
        
    }
    return YES;
}

- (void)callback {
    NSHashTable *callBacks = self.callBacks.copy;
    for (id <TimerCallBack> callBack in callBacks) {
        if (callBack && [callBack respondsToSelector:@selector(helperCallBack:)]) {
            [callBack helperCallBack:self];
        }
    }
}



- (void)timerHelperThrob {
    if (self.stop) return;
    [self run];
    BOOL callback = NO;
    if (self.timerType & TimerTypeFrequencySecond) {
        NSInteger runningInterval = (NSInteger)self.runningInterval;
        if (runningInterval % 10 == 0) {
            callback = YES;
        }
    }else {
        callback = YES;
    }
    if (!callback) return;
    if ([self calculate]) {
        [self callback];
    }
}



- (void)applicationWillEnterForeground:(NSNotification *)notify {
    if ([self finish]) return;

    NSTimeInterval interval = currentDate() - self.enterTime;
    self.runningInterval = self.runningInterval + floor(interval*10);
    self.stop = NO;
    [self calculate];
    [self callback];
 
}


- (void)applicationDidEnterBackground:(NSNotification *)notify {
    if ([self finish]) return;
    self.enterTime = currentDate();
    self.stop = YES;
}


- (void)addCallBack:(id<TimerCallBack>)callBack {
    if (!callBack) return;
    @synchronized (self) {
        if (![self.callBacks containsObject:callBack]) {
            [self.callBacks addObject:callBack];
        }
    }
}

- (void)removeCallBack:(id<TimerCallBack>)callBack {
    if (!callBack) return;
    @synchronized (self) {
        [self.callBacks removeObject:callBack];
    }
}

- (void)removeAllCallBacks {
    @synchronized (self) {
        [self.callBacks removeAllObjects];
    }
}

- (BOOL)finish {
    if ((self.timerType & TimerTypeHelperMaskCommon) && ((self.timerType & TimerTypeFrequencySecond) || (self.timerType & TimerTypeFrequencyTenthOfSecond))) {
        if (self.commonTypeStatus == TimerHelperCommonTypeStatusFinish) return YES;
    }
    return NO;
}


@end
