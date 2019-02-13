//
//  LYCWebView.m
//  WKWebView
//
//  Created by lianyangyang on 2019/2/12.
//  Copyright © 2019年 lianyangyang. All rights reserved.
//

#import "LYCWebView.h"
#import "LYCJSNativeMessageHandel.h"


@interface LYCWebView ()

/// 处理JS交互
@property (nonatomic, strong) LYCJSNativeMessageHandel *JSNativeMessageHandel;

@end

@implementation LYCWebView

#pragma mark - 重写父类的方法
///  设置webView默认属性
- (void)setDefaultValue
{
    [super setDefaultValue];
    
    /// jssdk的处理类
    _JSNativeMessageHandel = [[LYCJSNativeMessageHandel alloc] init];
    _JSNativeMessageHandel.webView = self;
    
    [self.configuration.userContentController addScriptMessageHandler:_JSNativeMessageHandel
                                                                 name:lykMTCJSNativeEventHandlerIdentifier];
}

@end
