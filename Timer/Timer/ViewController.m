//
//  ViewController.m
//  Timer
//
//  Created by gaomin on 2021/1/26.
//

#import "ViewController.h"
#import "GCDTimer.h"
#import "Timer.h"

static NSString *key = @"key";


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
    NSMutableDictionary *cacheInfo = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSString *keys = [cacheInfo.allKeys componentsJoinedByString:@"&"];
    _label = [UILabel new];
    _label.textColor = [UIColor darkTextColor];
    [self.view addSubview:_label];
    _label.text = keys;
        

    self.helper = [[TimerHelper alloc] initWithTimerType:TimerTypeSecondCommon interval:5];
    [self.helper addCallBack:self];
    
}

- (void)helperCallBack:(id<TimerHelper>)helper {
    NSLog(@"helper %ld天:%02ld:%02ld:%02ld:%02ld", helper.day, (long)helper.hour, helper.minute, helper.second, helper.msec);
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.label.frame = self.view.bounds;
}


@end
