//
//  ViewController.m
//  WKWebView
//
//  Created by lianyangyang on 2019/2/12.
//  Copyright © 2019年 lianyangyang. All rights reserved.
//

#import "ViewController.h"

#import "LYCWebView.h"
#import "LYBWebViewConfiguration.h"

@interface ViewController ()<LYPJSSDKContext,WKNavigationDelegate>
/// webView控件
@property (nonatomic, strong) LYCWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testWebView];
    // Do any additional setup after loading the view, typically from a nib.
}

/// 业务类的webView 使用
- (void)testWebView
{
    [self.view addSubview:self.webView];
    [self.webView loadLocalHTMLWithFileName:@"webViewTestDemo"];
}
- (void)mndOptional_showVideoPlayer:(NSDictionary *)aDicData
{
    NSLog(@"JS调原生的方法 %@",aDicData);
}

#pragma mark - 在收到响应时调用，让调用方决定是否允许加载数据

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    // 获取cookie,并设置到本地
    NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields]
                                                              forURL:response.URL];
    /// 将WKWebview的cookie保存到 NSHTTPCookie
    for (NSHTTPCookie *cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
    decisionHandler(WKNavigationResponsePolicyAllow);
}


- (LYCWebView *)webView
{
    if (_webView == nil) {
        LYBWebViewConfiguration *config = [[LYBWebViewConfiguration alloc] init];
        CGRect rect = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds));
        _webView = [[LYCWebView alloc] initWithFrame:rect
                                          configuration:config];
        ///在有H5与js交互的时候一定要设置这个属性
        _webView.delegateJSContext = self;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

@end
