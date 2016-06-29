//
//  HTTPRequest+Private.h
//  VeryZhun
//
//  Created by xianli on 15/8/6.
//  Copyright (c) 2015年 listener~. All rights reserved.
//

#import "HTTPRequest.h"

@interface HTTPRequest (Private)

NSString *HTTPRequestPrivateBaseURL();

typedef void(^HTTPRequestResponseBlock)(NSUInteger code,
                                      NSString *message,
                                      id data);

+ (void)postCommand:(NSString *)command
                url:(NSString *)url
         parameters:(NSDictionary *)parameters
      responseBlock:(HTTPRequestResponseBlock)responseBlock;

+ (void)postCommand:(NSString *)command
                url:(NSString *)url
         parameters:(NSDictionary *)parameters
            timeout:(NSTimeInterval)timeout
      responseBlock:(HTTPRequestResponseBlock)responseBlock;

@end
