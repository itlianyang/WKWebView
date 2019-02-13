//
//  LYMacroHeader.h
//  LYWKWebView
//
//  Created by lianyangyang on 2019/2/12.
//  Copyright © 2019年 lianyangyang. All rights reserved.
//
#import <pthread.h>

#ifndef LYMacroHeader_h
#define LYMacroHeader_h


#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) \
    autoreleasepool {}  \
    __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) \
    autoreleasepool {}  \
    __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) \
    try {               \
    } @finally {        \
    }                   \
    {                   \
    }                   \
    __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) \
    try {               \
    } @finally {        \
    }                   \
    {                   \
    }                   \
    __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) \
    autoreleasepool {}    \
    __typeof__(object) object = weak##_##object;
#else
#define strongify(object) \
    autoreleasepool {}    \
    __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) \
    try {                 \
    } @finally {          \
    }                     \
    __typeof__(object) object = weak##_##object;
#else
#define strongify(object) \
    try {                 \
    } @finally {          \
    }                     \
    __typeof__(object) object = block##_##object;
#endif
#endif
#endif

/**
 Whether in main queue/thread.
 */
static inline bool dispatch_is_main_queue()
{
    return pthread_main_np() != 0;
}

/**
 Submits a block for asynchronous execution on a main queue and returns immediately.
 */
static inline void dispatch_async_on_main_queue(void (^block)(void))
{
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

/**
 Submits a block for execution on a main queue and waits until the block completes.
 */
static inline void dispatch_sync_on_main_queue(void (^block)(void))
{
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

#endif /* LYMacroHeader_h */
