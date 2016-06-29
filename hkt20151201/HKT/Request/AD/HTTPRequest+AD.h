//
//  HTTPRequest+AD.h
//  HKT
//
//  Created by Ting on 15/11/20.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "HTTPRequest.h"

@interface HTTPRequest (AD)

+(void)getAdImageUrlCompleteBlock:(void (^)(BOOL ok, NSString *message, NSURL *url))completeBlock;

@end
