//
//  CSDataUtil.h
//  commSupport
//
//  Created by easelin on 12-1-30.
//  Copyright 2012 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef _CSDataUtil_h_
#define _CSDataUtil_h_

#if defined(__cplusplus)
extern "C" {
#endif

#define FieldOffset(type, filed) ((unsigned int) &((type *)0)->filed)
#define FieldSize(type, field) sizeof(((type *)0)->field)
	
extern void CSSetLLong(uint8_t* to, int64_t from );
extern void CSGetLLong(int64_t* to, uint8_t* from);
extern void CSSetShort(uint8_t* to, int16_t from);
extern void CSGetShort(int16_t* to, uint8_t* from);
extern void CSSetLong(uint8_t* to, int32_t from);
extern void CSGetLong(int32_t* to, uint8_t* from);	

extern NSData * CSGenerateMD5Data(NSData * data);
extern int CSCalculateTeaEncryptLength(NSData * data);
extern NSData * CSGenerateTeaEncryptData(NSData * data, NSData* key);
extern NSData * CSGenerateTeaDecryptData(NSData * data, NSData* key);
extern NSString * CSGenerateDataString(NSData * data);
	
#if defined(__cplusplus)
}
#endif

#endif