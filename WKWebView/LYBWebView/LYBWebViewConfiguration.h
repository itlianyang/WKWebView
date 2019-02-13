//
//  LYBWebViewConfiguration.h
//  WKWebView
//
//  Created by lianyangyang on 2019/2/12.
//  Copyright © 2019年 lianyangyang. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYBWebViewConfiguration : WKWebViewConfiguration

/// 是否允许长按 defaul YES
@property (nonatomic, assign) BOOL isAllowLongPress;

@end

NS_ASSUME_NONNULL_END
