//
//  ViewController.m
//  FlutterDemo
//
//  Created by 张毅 on 2019/3/11.
//  Copyright © 2019 com.fang. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <Flutter/Flutter.h>
#import "ThirdViewController.h"

@interface ViewController ()<FlutterStreamHandler>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(handleButtonAction)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Press me" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blueColor]];
    button.frame = CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds) - 160) / 2.0, 210.0, 160.0, 40.0);
    [self.view addSubview:button];
}

- (void)handleButtonAction
{
//    [self pushFlutterViewController_Normal];
//    [self pushFlutterViewController];
    [self pushFlutterViewController_EventChannel];
    
}

#pragma mark - 1.跳转到普通flutter
- (void)pushFlutterViewController_Normal
{
    FlutterEngine *flutterEngine = [(AppDelegate *)[[UIApplication sharedApplication] delegate] flutterEngine];
    FlutterViewController *fvc = [[FlutterViewController alloc] initWithEngine:flutterEngine nibName:nil bundle:nil];
    
    [self presentViewController:fvc animated:YES completion:nil];
}


#pragma mark - 2.跳转到和native交互flutter
- (void)pushFlutterViewController
{
    FlutterViewController* flutterViewController = [[FlutterViewController alloc] initWithProject:nil nibName:nil bundle:nil];
    flutterViewController.navigationItem.title = @"Flutter Demo";
    __weak __typeof(self) weakSelf = self;
    
    // 要与main.dart中一致
    NSString *channelName = @"com.pages.your/native_get";
    
    FlutterMethodChannel *messageChannel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:flutterViewController];
    
    [messageChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        // call.method 获取 flutter 给回到的方法名，要匹配到 channelName 对应的多个 发送方法名，一般需要判断区分
        // call.arguments 获取到 flutter 给到的参数，（比如跳转到另一个页面所需要参数）
        // result 是给flutter的回调， 该回调只能使用一次
        NSLog(@"flutter 给到我：\nmethod=%@ \narguments = %@",call.method,call.arguments);
        
        if ([call.method isEqualToString:@"toNativeSomething"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"flutter回调" message:[NSString stringWithFormat:@"%@",call.arguments] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            
            // 回调给flutter
            if (result) {
                result(@1000);
            }
        } else if ([call.method isEqualToString:@"toNativePush"]) {
            ThirdViewController *testVC = [[ThirdViewController alloc] init];
//            testVC.parames = call.arguments;
            [weakSelf.navigationController pushViewController:testVC animated:YES];
        } else if ([call.method isEqualToString:@"toNativePop"]) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    [self.navigationController pushViewController:flutterViewController animated:YES];
}


#pragma mark - 3.跳转到native主动
- (void)pushFlutterViewController_EventChannel
{
    FlutterViewController* flutterViewController = [[FlutterViewController alloc] initWithProject:nil nibName:nil bundle:nil];
    flutterViewController.navigationItem.title = @"EventChannel Demo";
    // 要与main.dart中一致
    NSString *channelName = @"com.pages.your/native_post";
    
    FlutterEventChannel *evenChannal = [FlutterEventChannel eventChannelWithName:channelName binaryMessenger:flutterViewController];
    // 代理
    [evenChannal setStreamHandler:self];
    
    [self.navigationController pushViewController:flutterViewController animated:YES];
}

#pragma mark  <FlutterStreamHandler>
// // 这个onListen是Flutter端开始监听这个channel时的回调，第二个参数 EventSink是用来传数据的载体。
- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(FlutterEventSink)events {
    
    // arguments flutter给native的参数
    // 回调给flutter， 建议使用实例指向，因为该block可以使用多次
    if ([arguments isKindOfClass:[NSNumber class]]) {
        CGFloat typeF = ((NSNumber *)arguments).floatValue;
        if (typeF == 12345) {
            if (events) {
                events(@"我是标题");
            }
        } else if (typeF == 12306) {
            if (events) {
                events(@"该代码是在native中写的");
            }
        }
    }
    
    return nil;
}

/// flutter不再接收
- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    // arguments flutter给native的参数
    return nil;
    
}



@end
