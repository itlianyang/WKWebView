//
//  LYBWebView.m
//  WKWebView
//
//  Created by lianyangyang on 2019/2/12.
//  Copyright © 2019年 lianyangyang. All rights reserved.
//

#import "LYBWebView.h"

@implementation LYBWebView

#pragma mark - ******************************************* Init and Uninit *************************

- (instancetype)initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration
{
    self = [super initWithFrame:frame configuration:configuration];
    if (self) {
        [self setDefaultValue];
    }
    return self;
}

#pragma mark - ******************************************* Delegate Event **************************

#pragma mark - 长按预览
- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo
{
    return NO;
}

#pragma mark - ******************************************* 私有方法 **********************************

#pragma mark - 设置webView默认属性

- (void)setDefaultValue
{
    ///打开左划回退功能
    self.scrollView.showsVerticalScrollIndicator = NO;
}


#pragma mark - ******************************************* 对外方法 **********************************

#pragma mark - 调用JS方法

- (void)callJavaScript:(NSString *)stringJsMethodName
{
    [self callJavaScript:stringJsMethodName handler:nil];
}

- (void)callJavaScript:(NSString *)stringJsMethodName handler:(void (^)(id))blockHandler
{
    [self evaluateJavaScript:stringJsMethodName
           completionHandler:^(id response, NSError *error) {
               if (blockHandler) {
                   blockHandler(response);
               }
           }];
}

#pragma mark - 从文件中加载HTML

- (void)loadLocalHTMLWithFileName:(NSString *)stringHtmlName
{
    NSString *stingPath = [[NSBundle mainBundle] bundlePath];
    
    NSURL *URL = [NSURL fileURLWithPath:stingPath];
    
    NSString *stringHtmlPath = [[NSBundle mainBundle] pathForResource:stringHtmlName
                                                               ofType:@"html"];
    /// 判断是否加载文件
    if (stringHtmlPath == NULL) {
        [self loadHTMLString:stringHtmlName
                     baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    } else {
        NSString *stringHtmlPath = [[NSBundle mainBundle] pathForResource:stringHtmlName
                                                                   ofType:@"html"];
        
        NSString *stringHtmlContent = [NSString stringWithContentsOfFile:stringHtmlPath
                                                                encoding:NSUTF8StringEncoding
                                                                   error:nil];
        
        [self loadHTMLString:stringHtmlContent baseURL:URL];
    }
}

#pragma mark - 加载一个链接

- (void)loadRequestWithUrl:(NSString *)aStringUrl
{
    NSURL *url = [NSURL URLWithString:aStringUrl];
    if (url == nil) {
        return;
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:15];
    NSString *stringCookie = [self getCookiesFromHttpCookieStorage:aStringUrl];
    [request addValue:stringCookie forHTTPHeaderField:@"Cookie"];
    
    [self loadRequest:request];
}

#pragma mark - 读取参数指定的url在HTTPCookieStorage中的cookie

- (NSString *)getCookiesFromHttpCookieStorage:(NSString *)aStringUrl
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSURL *url = [NSURL URLWithString:aStringUrl];
    NSArray *arrayCookies = [cookieJar cookiesForURL:url];
    
    NSMutableString *mStringCookie = [[NSMutableString alloc] init];
    for (NSHTTPCookie *cookie in arrayCookies) {
        [mStringCookie appendFormat:@"%@=%@;", cookie.name, cookie.value];
    }
    
    if (mStringCookie.length > 0) {
        /// 删除最后一个“；”
        [mStringCookie deleteCharactersInRange:NSMakeRange(mStringCookie.length - 1, 1)];
        return mStringCookie;
    } else {
        return @"";
    }
}


@end
