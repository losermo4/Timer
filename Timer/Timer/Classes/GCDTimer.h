//
//  GCDTimer.h
//  Timer
//
//  Created by gaomin on 2021/1/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface GCDTimer : NSObject

+ (GCDTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(GCDTimer *timer))block;

- (void)resume;

- (void)suspend;

@end

NS_ASSUME_NONNULL_END
