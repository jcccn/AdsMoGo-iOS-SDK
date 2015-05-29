//
//  DOARCMacros.h
//
//  Copyright (c) 2014年 company. All rights reserved.
//

#if !defined(__clang__) || __clang_major__ < 3
#ifndef __bridge
#define __bridge
#endif

#ifndef __bridge_retain
#define __bridge_retain
#endif

#ifndef __bridge_retained
#define __bridge_retained
#endif

#ifndef __autoreleasing
#define __autoreleasing
#endif

#ifndef __strong
#define __strong
#endif

#ifndef __unsafe_unretained
#define __unsafe_unretained
#endif

#ifndef __weak
#define __weak
#endif
#endif

#ifndef DO_STRONG
#if __has_feature(objc_arc)
#define DO_STRONG strong
#else
#define DO_STRONG retain
#endif
#endif

#ifndef DO_WEAK
#if __has_feature(objc_arc_weak)
#define DO_WEAK weak
#elif __has_feature(objc_arc)
#define DO_WEAK unsafe_unretained
#else
#define DO_WEAK assign
#endif
#endif

#if __has_feature(objc_arc)
#define DO_SAFE_ARC_PROP_RETAIN strong
#define DO_SAFE_ARC_RETAIN(x) (x)
#define DO_SAFE_ARC_RELEASE(x)
#define DO_SAFE_ARC_AUTORELEASE(x) (x)
#define DO_SAFE_ARC_BLOCK_COPY(x) (x)
#define DO_SAFE_ARC_BLOCK_RELEASE(x)
#define DO_SAFE_ARC_SUPER_DEALLOC()
#define DO_SAFE_ARC_AUTORELEASE_POOL_START() @autoreleasepool {
#define DO_SAFE_ARC_AUTORELEASE_POOL_END() }
#else
#define DO_SAFE_ARC_PROP_RETAIN retain
#define DO_SAFE_ARC_RETAIN(x) ([(x) retain])
#define DO_SAFE_ARC_RELEASE(x) ([(x) release],x = nil)
#define DO_SAFE_ARC_AUTORELEASE(x) ([(x) autorelease])
#define DO_SAFE_ARC_BLOCK_COPY(x) (Block_copy(x))
#define DO_SAFE_ARC_BLOCK_RELEASE(x) (Block_release(x))
#define DO_SAFE_ARC_SUPER_DEALLOC() ([super dealloc])
#define DO_SAFE_ARC_AUTORELEASE_POOL_START() NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
#define DO_SAFE_ARC_AUTORELEASE_POOL_END() [pool release];
#endif
