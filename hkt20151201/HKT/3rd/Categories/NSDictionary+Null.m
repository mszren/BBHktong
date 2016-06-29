//
//  NSDictionary+Null.m
//  Nextdoors
//
//  Created by hfhouse on 15/6/2.
//  Copyright (c) 2015年 hfw. All rights reserved.
//

#import "NSDictionary+Null.h"
#import "NSArray+Null.h"

@implementation NSDictionary (Null)

- (NSDictionary *)dictionaryWithoutNull {
    
    NSMutableDictionary *mutableSelf = [self mutableCopy];
    NSMutableArray *nullKeys = [NSMutableArray new];
    
    [mutableSelf enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            mutableSelf[key] = [obj dictionaryWithoutNull];
        }
        else if ([obj isKindOfClass:[NSArray class]]) {
            mutableSelf[key] = [obj arrayWithoutNull];
        }
        else if ([obj isEqual:[NSNull null]]) {
            [nullKeys addObject:key];
        }
    }];
    
    [mutableSelf removeObjectsForKeys:nullKeys];
    
    return [mutableSelf copy];
}

@end
