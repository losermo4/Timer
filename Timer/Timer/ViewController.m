//
//  ViewController.m
//  Timer
//
//  Created by gaomin on 2021/1/26.
//

#import "ViewController.h"

#import "Timer.h"


@interface ViewController ()<TimerCallBack>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) GCDTimer *gcdTimer;
@property (nonatomic, strong) NSTimer *nsTimer;

@property (nonatomic, strong) TimerHelper *helper;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.helper = [[TimerHelper alloc] initWithTimerType:TimerTypeSecondCommon interval:50000];
    [self.helper addCallBack:self];
    [self helperCallBack:self.helper];
    
    
}

- (void)helperCallBack:(id<TimerHelper>)helper {
    NSLog(@"helper %ld天:%02ld:%02ld:%02ld:%02ld", helper.day, (long)helper.hour, helper.minute, helper.second, helper.msec);
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.label.frame = self.view.bounds;
}


@end
