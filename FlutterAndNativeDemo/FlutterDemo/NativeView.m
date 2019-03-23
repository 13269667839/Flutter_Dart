//
//  NativeView.m
//  FlutterDemo
//
//  Created by 张毅 on 2019/3/11.
//  Copyright © 2019 com.fang. All rights reserved.
//

#import "NativeView.h"
#import <Flutter/FlutterPlatformViews.h>
#import <Flutter/Flutter.h>

@interface NativeView  ()<FlutterPlatformView,FlutterPlatformViewFactory,FlutterBinaryMessenger>

@end

@implementation NativeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        
        NSString* channelName = [NSString stringWithFormat:@"com.pages.your/native_view"];
        FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:self];
        __weak __typeof__(self) weakSelf = self;
        [channel setMethodCallHandler:^(FlutterMethodCall *  call, FlutterResult  result) {
            [weakSelf onMethodCall:call result:result];
        }];
        
    }
    return self;
}

-(UIView *)view
{
    return self;
}

-(NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args
{
    
    self.frame = frame;
    NSLog(@"%@",args);
    return self;
}

- (void)setMessageHandlerOnChannel:(NSString*)channel
              binaryMessageHandler:(FlutterBinaryMessageHandler _Nullable)handler
{
    NSLog(@"%@",args);
}


-(void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result{
    
    if ([[call method] isEqualToString:@"start"]) {
        
    }else{
        if ([[call method] isEqualToString:@"stop"]){
            
        }
        else {
            result(FlutterMethodNotImplemented);
        }
    }
}


@end
