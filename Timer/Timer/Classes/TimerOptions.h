//
//  TimerOptions.h
//  Timer
//
//  Created by gaomin on 2021/1/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN






typedef NS_OPTIONS(NSUInteger, TimerType) {
    /// 倒计时 秒/0.1秒
    TimerTypeFrequencySecond                = 1 << 0,
    TimerTypeFrequencyTenthOfSecond         = 1 << 1,
    
    /// 倒计时样式
    TimerTypeHelperMaskCommon               = 1 << 10,
    
    /// 初始化倒计时样式
    TimerTypeSecondCommon           = TimerTypeFrequencySecond | TimerTypeHelperMaskCommon,
    TimerTypeTenthOfSecondCommon    = TimerTypeFrequencyTenthOfSecond | TimerTypeHelperMaskCommon
};


@interface TimerOptions : NSObject



@end

NS_ASSUME_NONNULL_END
