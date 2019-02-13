//
//  LYPJSSDKContext.h
//  WKWebView
//
//  Created by lianyangyang on 2019/2/12.
//  Copyright © 2019年 lianyangyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LYPJSSDKContext <NSObject>

@optional

/// 播放视频
- (void)mndOptional_showVideoPlayer:(NSDictionary *)aDicData;

@end

NS_ASSUME_NONNULL_END
