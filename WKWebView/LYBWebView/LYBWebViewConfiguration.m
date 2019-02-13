//
//  LYBWebViewConfiguration.m
//  WKWebView
//
//  Created by lianyangyang on 2019/2/12.
//  Copyright © 2019年 lianyangyang. All rights reserved.
//

#import "LYBWebViewConfiguration.h"

@implementation LYBWebViewConfiguration

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userContentController = [[WKUserContentController alloc] init];
        // 允许视频播放
        self.allowsAirPlayForMediaPlayback = YES;
        // 允许在线播放
        self.allowsInlineMediaPlayback = YES;
        // 允许与网页交互
        self.selectionGranularity = YES;
        ///允许长按
        self.isAllowLongPress = YES;
    }
    return self;
}

- (void)setIsAllowLongPress:(BOOL)isAllowLongPress
{
    _isAllowLongPress = isAllowLongPress;
    if (isAllowLongPress == NO) {
        //／ 禁止长按
        NSMutableString *mStringJS = [NSMutableString string];
        [mStringJS appendString:@"document.documentElement.style.webkitTouchCallout='none';"];
        WKUserScript *scriptNoneSelect = [[WKUserScript alloc] initWithSource:mStringJS injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [self.userContentController addUserScript:scriptNoneSelect];
    } else {
        [self.userContentController removeAllUserScripts];
    }
}


@end
