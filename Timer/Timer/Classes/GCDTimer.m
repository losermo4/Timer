//
//  GCDTimer.m
//  Timer
//
//  Created by gaomin on 2021/1/27.
//

#import "GCDTimer.h"

typedef NS_ENUM(NSInteger, GCDTimerStatus) {
    GCDTimerStatusResume,
    GCDTimerStatusSuspend
};

static dispatch_queue_t gcdTimerQueue(void) {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.gcd.timer.queue", DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}

@interface GCDTimer ()

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) GCDTimerStatus status;



@end

@implementation GCDTimer

- (void)dealloc {
    NSLog(@"%@", @"GCDTimer dealloc");
}

+ (GCDTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(GCDTimer *))block {
    return [[self alloc] initWithTimeInterval:interval repeats:repeats block:block];
}

- (instancetype)initWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(GCDTimer *))block {
    self = [super init];
    if (self) {
        [self doInitWithTimeInterval:interval repeats:repeats block:block];
    }
    return self;
}

- (void)doInitWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(GCDTimer *))block {
    dispatch_queue_t queue = gcdTimerQueue();
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer,dispatch_walltime(NULL, 0),interval*NSEC_PER_SEC, 0);
    __block BOOL isFirst = YES;
    __weak typeof(self) _self = self;
    dispatch_source_set_event_handler(self.timer, ^{
        if (isFirst) {
            isFirst = NO; /// 第一次不回调
            return;
        }
        __strong typeof(_self) self = _self;
        if (!self) return;
        if (block) {
            block(self);
        }
        if (!repeats) {
            [self suspend];
        }
    });
    dispatch_resume(self.timer);
    _status = GCDTimerStatusResume;
}


- (void)resume {
    if (_status == GCDTimerStatusResume) return;
    dispatch_resume(self.timer);
    _status = GCDTimerStatusResume;
}

- (void)suspend {
    if (_status == GCDTimerStatusSuspend) return;
    dispatch_suspend(self.timer);
    _status = GCDTimerStatusSuspend;
}




@end
