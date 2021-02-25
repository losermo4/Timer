
1.需求 
https://dashen.zhuanspirit.com/pages/viewpage.action?pageId=71408561 
2.记录
https://dashen.zhuanspirit.com/pages/viewpage.action?pageId=71408561 

一、背景
1、每次从后台切会前台都要进行网络请求
2、app启动就开启了定时器，刷新频率毫秒级别
3、倒计时跟项目耦合
4、当项目里面没用到计时器的时候，计时器还是在运行

二、追求
1、从后台切会前台不需要进行网络请求，时间要尽量准确
2、系统改变不影响倒计时时间（追求）
3、控制器或是UI组件能够控制倒计时，当控制器或是UI组件销毁的时候能够释放掉计时器
4、当计时器队里里面没有任务时，不要计时
5、研究系统有没有绝对时间，不受息屏或是应用挂起影响

========================================================================================================

一、iOS系统中的获取时间方式
1. 受系统时间影响的方式; 受系统时间影响，表示用户修改设备时间这些获取时间方式返回的值会发生变化
1.1 NSDate
1.2 CFAbsoluteTimeGetCurrent()
1.3 gettimeofday（）
1.4 sysctl

2.受设备重启影响的方式; 用户修改设备时间这些获取时间方式返回的值不会发生变化，但是设备重启和休眠会影响
1.1 mach_absolute_time()
1.2 CACurrentMediaTime()

3. 获取系统累计开机时间
[NSProcessInfo processInfo].systemUptime 

二、iOS 中的定时器
1. NSTimer  (存在误差)
2. CADisplayLink (存在误差)
3. GCD 


三、Timer特性
1.整个倒计时只创建一个GCD倒计时
2.倒计时支持1s和0.1s跳动
3.TimerManager 会检测所有倒计时，当没有倒计时或者倒计时全部完成了 GCDTimer暂停
4.用户修改系统时间不影响整个倒计时的准确性
5.前后台切换 基本不影响倒计时准确性



四、Timer类详解
1. GCDTimer :基于GCD封装的倒计时 可暂停 可继续
2.TimerHelper :倒计时类，支持1s倒计时 和 0.1s倒计时
3.TimerManager : 倒计时管理类，管理所有的倒计时TimerHelper对象; 
4.TimerOptions : 倒计时配置项 
5.TimerCallBack: 倒计时回调
