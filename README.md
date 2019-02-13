# WKWebView

<p align="center" >
<img src="https://github.com/itlianyang/WKWebView/blob/master/WKWebView/LYWebViewDemo/jianjie.png" width="430" height="232"/>
</p>

 ## 介绍
 LYBWebView 是WKWebView 子类，对常用方法进行封装。
 * 获取加载URL的title，
 * 加载本地HTML页面
 * 加载一个链接，同时将本地cookie添加在链接的请求中
 * 调用JS方法
 
 LYBWebViewConfiguration 对WKWebView 初始化的一些参数进行设置（例：allowsAirPlayForMediaPlayback 允许视频播放）
 

 LYCWebView 是 LYBWebView的子类
 
 LYCJSNativeMessageHandel 遵循 WKScriptMessageHandler 实现JS调用原生的方法，这个类是 JS交互协议的关键
 通过iOS的反射机制将JS传来的将要调用原生的方法，生成原生的方法 NSSelectorFromString
 使用方法签名来调用原生的方法 NSMethodSignature NSInvocation
 
 LYCWebView+JSNativeJSSDK 里面实现可以实现一些原生的方法来供JS交互使用
 
 LYPJSSDKContext 将一些WebView无法处理的交互，交给WebView的代理来处理。
  
 ## 介绍
 1. 学会JSNative交互
 2. WKWebView 怎么获取cookie，加载一个网络链接添加cookie
 3. 通过runtime 反射机制方法签名 协作 调取Native 方法。
 4. 通过protocol 协议巧妙的传给应该响应实现该原生方法的VC 或者其他对象

 
