//
//  TimerHelper.h
//  Timer
//
//  Created by gaomin on 2021/1/27.
//

#import <Foundation/Foundation.h>
#import "TimerOptions.h"

NS_ASSUME_NONNULL_BEGIN

@class TimerManager;
@protocol TimerCallBack;

typedef NS_ENUM(NSInteger, TimerHelperCommonTypeStatus) {
    TimerHelperCommonTypeStatusRunning = 1,
    TimerHelperCommonTypeStatusFinish
};

@protocol TimerHelper <NSObject>

- (void)timerHelperThrob;

- (instancetype)initWithTimerType:(TimerType)timerType interval:(NSTimeInterval)interval;


- (void)updateInterval:(NSTimeInterval)interval;

@property (nonatomic, assign, readonly) TimerType timerType;
@property (nonatomic, assign, readonly) TimerHelperCommonTypeStatus commonTypeStatus;
@property (nonatomic, assign, readonly) NSTimeInterval runningInterval;
@property (nonatomic, assign, readonly) BOOL finish;


@property (nonatomic, assign, readonly) NSInteger day;
@property (nonatomic, assign, readonly) NSInteger hour;
@property (nonatomic, assign, readonly) NSInteger minute;
@property (nonatomic, assign, readonly) NSInteger second;
@property (nonatomic, assign, readonly) NSInteger msec;


- (void)addCallBack:(id <TimerCallBack>)callBack;

- (void)removeCallBack:(id <TimerCallBack>)callBack;

- (void)removeAllCallBacks;

@end


@interface TimerHelper : NSObject <TimerHelper>

@end


NS_ASSUME_NONNULL_END
