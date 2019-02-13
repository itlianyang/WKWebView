//
//  LYCWebView+JSNativeJSSDK.h
//  WKWebView
//
//  Created by lianyangyang on 2019/2/12.
//  Copyright © 2019年 lianyangyang. All rights reserved.
//

#import "LYCWebView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LYCWebView (JSNativeJSSDK)
/// 1.  获取客户端网络状态
- (NSDictionary *)getNativeNetStatus;
/// 1.  显示播放器控件
- (void)showVideoPlayer:(NSDictionary *)aDicParams;

@end

NS_ASSUME_NONNULL_END
