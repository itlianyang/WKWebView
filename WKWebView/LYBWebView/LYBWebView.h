//
//  LYBWebView.h
//  WKWebView
//
//  Created by lianyangyang on 2019/2/12.
//  Copyright © 2019年 lianyangyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface LYBWebView : WKWebView

/**
 进度条
 */
@property (strong, nonatomic) UIProgressView *progressView;

/**
 webView的标题、如果navigationItemTitle需要和webView保持一致、直接getter方法即可
 */
@property (nonatomic, copy) NSString *stringWebViewtitle;

/// 子类来重写这个方法
- (void)setDefaultValue;
/**
 *  加载本地HTML页面
 *
 *  @param stringHtmlName html页面文件名称
 */
- (void)loadLocalHTMLWithFileName:(NSString *)stringHtmlName;

/**
 加载一个链接
 
 @param aStringUrl 要加载URL
 */
- (void)loadRequestWithUrl:(NSString *)aStringUrl;

/**
 *  调用JS方法（无返回值）
 *
 *  @param stringJsMethodName JS方法名称
 */
- (void)callJavaScript:(NSString *)stringJsMethodName;

/**
 *  调用JS方法（可处理返回值）
 *
 *  @param stringJsMethodName JS方法名称
 *  @param blockHandler  回调block
 */
- (void)callJavaScript:(NSString *)stringJsMethodName
               handler:(void (^_Nullable)(id response))blockHandler;


@end

NS_ASSUME_NONNULL_END
