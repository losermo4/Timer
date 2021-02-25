//
//  TimerCallBack.h
//  Timer
//
//  Created by gaomin on 2021/1/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TimerHelper;

@protocol TimerCallBack <NSObject>

@optional

- (void)helperCallBack:(id <TimerHelper>)helper;

@end



NS_ASSUME_NONNULL_END
