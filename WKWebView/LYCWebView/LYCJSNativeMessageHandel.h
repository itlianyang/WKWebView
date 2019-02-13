//
//  LYCJSNativeMessageHandel.h
//  WKWebView
//
//  Created by lianyangyang on 2019/2/12.
//  Copyright © 2019年 lianyangyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@class LYCWebView;

FOUNDATION_EXTERN NSString *const lykMTCJSNativeEventHandlerIdentifier;

NS_ASSUME_NONNULL_BEGIN

@interface LYCJSNativeMessageHandel : NSObject <WKScriptMessageHandler>
/// 当前加载WebView
@property (nonatomic, weak) LYCWebView *webView;

@end

NS_ASSUME_NONNULL_END
