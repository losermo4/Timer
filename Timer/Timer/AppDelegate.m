//
//  AppDelegate.m
//  Timer
//
//  Created by gaomin on 2021/1/26.
//

#import "AppDelegate.h"

static NSString *key = @"key";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    NSMutableDictionary *cacheInfo = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSLog(@"cacheInfo %@", cacheInfo);
    return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSMutableDictionary *cacheInfo = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!cacheInfo) {
        cacheInfo = [NSMutableDictionary dictionary];
    }
    CFAbsoluteTime time = CFAbsoluteTimeGetCurrent();
    [cacheInfo setObject:@"applicationWillTerminate" forKey:@(time)];
    [[NSUserDefaults standardUserDefaults] setObject:cacheInfo forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
