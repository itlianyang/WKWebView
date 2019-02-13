//
//  LYCJSNativeMessageHandel.m
//  WKWebView
//
//  Created by lianyangyang on 2019/2/12.
//  Copyright © 2019年 lianyangyang. All rights reserved.
//

#import "LYCJSNativeMessageHandel.h"

#import "LYMacroHeader.h"
#import "LYCWebView.h"

NSString *const lykMTCJSNativeEventHandlerIdentifier = @"nativeEventHandler";


/// js 传到原生的键名，这些字段名需要跟JS协商好来进行添加替换
NSString *const lykMTCJSNativeEventHandlerNativeMethodNameKey = @"methodName";
NSString *const lykMTCJSNativeEventHandlerNativeDataParamKey = @"data";
NSString *const lykMTCJSNativeEventHandlerNativeCallBackMethodKey = @"callBackMethod";
NSString *const lykMTCJSNativeEventHandlerNativeTokenKey = @"token";

/// native 回传给JS 的键名
NSString *const lykMTCJSNativeEventHandlerNativeCodeKey = @"code";

/// Native回调JS方法code
typedef NS_ENUM(NSUInteger, MNE_NativeCallBackCode) {
    /// 回调成功
    MNE_NativeCallBackCode_Success = 0,
    /// 方法不存在
    MNE_NativeCallBackCode_NoMethod,
};

@implementation LYCJSNativeMessageHandel

/**
 通过方法名，
 
 @param aDicJSParams JS传过来的字典，调取原生的方法，回调方法，参数
 */
- (void)mt_interactWithDictionary:(NSDictionary *)aDicJSParams
{
    /// 调用原生的方法
    NSString *stringMethodName = nil;
    if (aDicJSParams[lykMTCJSNativeEventHandlerNativeMethodNameKey]) {
        stringMethodName = aDicJSParams[lykMTCJSNativeEventHandlerNativeMethodNameKey];
    }
    
    /// JS调用原生方法要传的参数
    NSDictionary *dicParams = nil;
    if (aDicJSParams[lykMTCJSNativeEventHandlerNativeDataParamKey]) {
        dicParams = aDicJSParams[lykMTCJSNativeEventHandlerNativeDataParamKey];
    }
    
    /// 调取完原生方法需要回调JS的方法
    NSString *callBackName = nil;
    if (aDicJSParams[lykMTCJSNativeEventHandlerNativeCallBackMethodKey]) {
        callBackName = aDicJSParams[lykMTCJSNativeEventHandlerNativeCallBackMethodKey];
    }
    
    /// token
    NSString *stringToken = nil;
    if (aDicJSParams[lykMTCJSNativeEventHandlerNativeTokenKey]) {
        stringToken = aDicJSParams[lykMTCJSNativeEventHandlerNativeTokenKey];
    }
    
    /// 如果存在参数
    if (dicParams) {
        /// 方法名添加“:”
        stringMethodName = [NSString stringWithFormat:@"%@:", stringMethodName];
    }
    
    /// 通过方法名获取方法SEL
    SEL selectorNative = NSSelectorFromString(stringMethodName);
    
    NSArray *arrayParam = nil;
    /// 如果存在参数
    if (dicParams) {
        arrayParam = @[ dicParams ];
    }
    
    /// 如果SEL存在
    if ([self.webView respondsToSelector:selectorNative]) {
        id idReturnObejct = [self mt_JSNavtiePerformSelector:selectorNative withObjects:arrayParam];
        
        if ([idReturnObejct isKindOfClass:[NSDictionary class]]) {
            /// 如果存在回调方法
            if (callBackName) {
                NSString *stringJS = [self mt_getJSMethodWithCallBackName:callBackName params:idReturnObejct methodIsExist:YES token:stringToken];
                dispatch_async_on_main_queue(^{
                    [self.webView callJavaScript:stringJS];
                });
            }
        }
    } else /// 如果方法不存在
    {
        /// 如果存在回调方法
        if (callBackName) {
            NSString *stringJS = [self mt_getJSMethodWithCallBackName:callBackName params:nil methodIsExist:NO token:stringToken];
            dispatch_async_on_main_queue(^{
                [self.webView callJavaScript:stringJS];
            });
        }
    }
}

/**
 获取native调用JS evaluateJavaScript字符串。
 
 @param aStringCallBackName  原生回调JS方法名；
 @param aDicParams 原生回调参数；
 @param isMethodExist 原生是否有需要调用的方法
 @param aStringToken JS判断方法回调的标识，如果不是返回值回调，aStringToken： nil.
 @return 原生调JS方法字符串.
 */
- (NSString *)mt_getJSMethodWithCallBackName:(NSString *)aStringCallBackName
                                      params:(NSDictionary *)aDicParams
                               methodIsExist:(BOOL)isMethodExist
                                       token:(NSString *)aStringToken
{
    /// 回调方法名不存在
    if (aStringCallBackName == nil) {
        return nil;
    }
    
    NSMutableDictionary *mDicNativeJSHandler = @{}.mutableCopy;
    
    if (aDicParams) {
        [mDicNativeJSHandler setObject:aDicParams forKey:lykMTCJSNativeEventHandlerNativeDataParamKey];
    }
    
    if (aStringToken) {
        [mDicNativeJSHandler setObject:aStringToken forKey:lykMTCJSNativeEventHandlerNativeTokenKey];
    }
    if (isMethodExist) {
        [mDicNativeJSHandler setObject:@(MNE_NativeCallBackCode_Success) forKey:lykMTCJSNativeEventHandlerNativeCodeKey];
    } else {
        [mDicNativeJSHandler setObject:@(MNE_NativeCallBackCode_NoMethod) forKey:lykMTCJSNativeEventHandlerNativeCodeKey];
    }

    NSError *errorParse = nil;
    NSData *dataJSON = [NSJSONSerialization dataWithJSONObject:mDicNativeJSHandler
                                                       options:0
                                                         error:&errorParse];
    
    if (errorParse) {
        NSLog(@"Native  返回值 json 序列化出错 %@", [errorParse localizedDescription]);
        
        return nil;
    }
    
    NSString *stringJS = [[NSString alloc] initWithData:dataJSON encoding:NSUTF8StringEncoding];
    
    stringJS = [NSString stringWithFormat:@"jsBridge['%@']('%@')", aStringCallBackName, stringJS];
    
    return stringJS;
}

#pragma mark - 处理消息转发
/**
 通过方法签名 调用原生的方法并获取返回值
 
 @param aSelector 原生的方法
 @param objects 调用原生方法参数
 @return 原生方法返回值
 */
- (id)mt_JSNavtiePerformSelector:(SEL)aSelector withObjects:(NSArray *)objects
{
    // 创建一个函数签名，这个签名可以是任意的，但需要注意，签名函数的参数数量要和调用的一致。
    NSMethodSignature *signature = [self.webView methodSignatureForSelector:aSelector];
    // 通过签名初始化
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    // 设置target
    [invocation setTarget:self.webView];
    // 设置selector
    [invocation setSelector:aSelector];
    
    NSUInteger i = 1;
    /// 添加参数Index
    for (id object in objects) {
        id tempObject = object;
        // 注意：1、这里设置参数的Index 需要从2开始，因为前两个被selector和target占用。
        [invocation setArgument:&tempObject atIndex:++i];
    }
    
    // retain 所有参数，防止参数被释放dealloc
    [invocation retainArguments];
    
    // 消息调用
    [invocation invoke];
    
    /* 在arc模式下，getReturnValue：仅仅是从invocation的返回值拷贝到指定的内存地址，
     如果返回值是一个NSObject对象的话，是没有处理起内存管理的。
     而我们在定义resultSet时使用的是__strong类型的指针对象，arc就会假设该内存块已被retain（实际没有），
     当resultSet出了定义域释放时，导致该crash。假如在定义之前有赋值的话，还会造成内存泄露的问题。
     */
    
    /* 使用一个unretain的对象来获取返回值，或者 用void *指针来保存返回值，然后用__bridge来转化为OC对象。*/
    
    void *temp = NULL;
    /// 如果存在返回值
    if ([signature methodReturnLength]) {
        [invocation getReturnValue:&temp];
        
        id objcMinor = (__bridge id)temp;
        
        if (objcMinor) {
            return objcMinor;
        }
    }
    return nil;
}


#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message
{
    if ([message.name isEqualToString:lykMTCJSNativeEventHandlerIdentifier]) {
        NSString *stringJSON = message.body;
        /// 如果stringJSON无效，表示JS调方法有问题，退出检查。
        if (stringJSON == nil) {
            return;
        }
        NSData *dataJSON = [stringJSON dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dicJSHandler = [NSJSONSerialization JSONObjectWithData:dataJSON options:0 error:NULL];
        [self mt_interactWithDictionary:dicJSHandler];
    }
}
@end
