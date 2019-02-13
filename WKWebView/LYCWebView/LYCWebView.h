//
//  LYCWebView.h
//  WKWebView
//
//  Created by lianyangyang on 2019/2/12.
//  Copyright © 2019年 lianyangyang. All rights reserved.
//

#import "LYBWebView.h"

#import "LYPJSSDKContext.h"

NS_ASSUME_NONNULL_BEGIN

@interface LYCWebView : LYBWebView
/// wkWebView JSNative 的代理对象
@property (nonatomic, weak) id<LYPJSSDKContext> delegateJSContext;

@end

NS_ASSUME_NONNULL_END
