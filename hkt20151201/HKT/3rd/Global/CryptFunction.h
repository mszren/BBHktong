//
//  CryptFunction.h
//  hfwzone
//
//  Created by star on 15/3/31.
//  Copyright (c) 2015年 hfw.kunwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CryptFunction : NSObject
/******************************************************************************
 函数名称 : + (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES加密
 输入参数 : (NSData *)data
 (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key;

/******************************************************************************
 函数名称 : + (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key
 函数描述 : 文本数据进行DES解密
 输入参数 : (NSData *)data (NSString *)key
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 : 此函数不可用于过长文本
 ******************************************************************************/
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key;


//计算HMAC-SHA1， added by xdyang 网络鉴权使用
+ (NSString *)hmacsha1:(NSString *)data secret:(NSString *)key;

// 3DES 加密
+ (NSData *)TripleDESEncrypt:(NSData *)data WithKey:(NSString *)key;
+ (NSData *)TripleDESDecrypt:(NSData *)data WithKey:(NSString *)key;

//杀1
+ (NSString *)sha1:(NSString *)input;
@end
