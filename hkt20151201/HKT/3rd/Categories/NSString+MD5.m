//
//  NSString+MD5.m
//  QuickDrive
//
//  Created by xianli on 15/8/17.
//  Copyright (c) 2015年 xianli. All rights reserved.
//

#import "NSString+MD5.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)

- (NSString *)MD5 {
    if (self.length == 0) {
        return self;
    }
    
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    
    return [hash lowercaseString];
}

@end
