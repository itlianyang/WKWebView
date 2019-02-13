//
//  LYCWebView+JSNativeJSSDK.m
//  WKWebView
//
//  Created by lianyangyang on 2019/2/12.
//  Copyright © 2019年 lianyangyang. All rights reserved.
//

#import "LYCWebView+JSNativeJSSDK.h"

@implementation LYCWebView (JSNativeJSSDK)

- (NSDictionary *)getNativeNetStatus
{
    return @{ @"nativeNetStatus" : @(1) };
}
#pragma mark - 8.  显示播放器控件
- (void)showVideoPlayer:(NSDictionary *)aDicParams
{
    if ([self.delegateJSContext respondsToSelector:@selector(mndOptional_showVideoPlayer:)]) {
        [self.delegateJSContext mndOptional_showVideoPlayer:aDicParams];
    }
}
@end
