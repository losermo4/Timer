//
//  TimerManager.h
//  Timer
//
//  Created by gaomin on 2021/1/27.
//

#import <Foundation/Foundation.h>
#import "TimerOptions.h"


NS_ASSUME_NONNULL_BEGIN

@protocol TimerHelper;

@interface TimerManager : NSObject

+ (instancetype)sharedManager;


- (void)addTimerHelper:(id <TimerHelper>)timerHelper;
- (void)removeTimerHelper:(id <TimerHelper>)timerHelper;
- (void)removeAllTimerHelper;

@end

NS_ASSUME_NONNULL_END
