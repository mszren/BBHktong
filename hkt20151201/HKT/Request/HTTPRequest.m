//
//  HTTPRequest.m
//  QuickDrive
//
//  Created by xianli on 15/8/6.
//  Copyright (c) 2015年 listener~. All rights reserved.
//

#import "HTTPRequest.h"
#import "HTTPRequest+Private.h"
#import "AFNetworking.h"
#import "AFNetworkReachabilityManager.h"
#import "cJSON.h"
#import "NSData+Base64.h"
#import "JSONKit.h"
#import "NSDictionary+Null.h"
#import "NSArray+Null.h"
#import "CryptFunction.h"

#define desKey @"newland_Iportol@lx100$#3"

NSInteger const HTTPPageSize = 20;



static NSString * const kBaseURL  = @"index.php/Hkt";    // 公网服务器


@implementation HTTPRequest

#pragma mark - Private functions

static NSString* JSONStringFromDictionary(NSDictionary *dictionary) {
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
    return JSONStringFromData(data);
}

NSString *AppRequestManagerDefaultHTTPContentType() {
    return @"text/html;charset=utf-8";
}

static NSString* JSONStringFromData(NSData *data) {
    
    cJSON *json = cJSON_Parse(data.bytes);
    if (!json) {
        NSLog(@"parse parameter JSON string failed! response is: %s", data.bytes);
        return @"";
    }
    
    char *cstring = cJSON_Print(json);
    NSString *jsonString = [NSString stringWithCString:cstring encoding:NSUTF8StringEncoding];
    free(cstring);
    cJSON_Delete(json);
    
    return jsonString;
}

#pragma mark - Public functions

NSString* HTTPRequestPrivateBaseURL() {
    return [NSString stringWithFormat:@"%@%@",kBasePort,kBaseURL];
}

#pragma mark - Private methods

+ (void)startRequestCommand:(NSString *)command
                        url:(NSString *)url
                     method:(NSString *)method
                 parameters:(NSDictionary *)parameters
                    timeout:(NSTimeInterval)timeout
              responseBlock:(HTTPRequestResponseBlock)responseBlock {
    
    
    
    NSData *bodyData;
    if(parameters != nil){
        bodyData = [NSJSONSerialization dataWithJSONObject:parameters
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:nil];
        // 构造请求参数
        NSLog(@"%@ ----- url is: %@, request parameters are: %@", command, url, JSONStringFromDictionary(parameters));
        bodyData = [CryptFunction TripleDESEncrypt:bodyData WithKey:desKey];
    }
    
    // 构造Request
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:method
                                                                                 URLString:url
                                                                                parameters:nil
                                                                                     error:nil];
    request.timeoutInterval = timeout;
    [request setValue:AppRequestManagerDefaultHTTPContentType() forHTTPHeaderField:@"Content-Type"];
    
    NSString *nonce = [GlobalFunction generateUUID];
    NSString *timestamp = [NSString stringWithFormat:@"%llu", (long long)[NSDate date].timeIntervalSince1970];
    
    [request setValue:@"zuolinyouli" forHTTPHeaderField:@"consumerKey"];
    [request setValue:nonce forHTTPHeaderField:@"nonce"];
    [request setValue:timestamp forHTTPHeaderField:@"timestamp"];
    //[request setValue:[AppStartManager sharedInstance].appInfo.appVersion forHTTPHeaderField:@"version"];
    
    NSString *encripStr = [NSString stringWithFormat:@"%@&%@", nonce, timestamp];
    NSString *signature = [CryptFunction hmacsha1:encripStr secret:@"shiyanshi2015"];
    [request setValue:signature forHTTPHeaderField:@"signature"];
    
    [request setHTTPBody:bodyData];
    
    //构造operation
    AFHTTPRequestOperation *httpRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSData *response) {
        
        response = [CryptFunction TripleDESDecrypt:response WithKey:desKey];
        
        NSLog(@"%@ response JSON is: %@", NSStringFromClass(self.class), JSONStringFromData(response));
        
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:response
                                                                       options:NSJSONReadingAllowFragments
                                                                         error:NULL];
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            responseObject = [responseObject dictionaryWithoutNull];
            
            NSString *message = responseObject[@"tips"];
            NSNumber *code = responseObject[@"status"];
            NSDictionary *data = responseObject[@"data"];
            
            
            if (responseBlock) {
                responseBlock(code.unsignedIntegerValue, message, data);
            }
        }
        else {
            if (responseBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    responseBlock(-1, @"接口返回数据格式错误！", nil);
                });
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@ request failed, error is: %@", command, error);
        
        if (responseBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                responseBlock(error.code, error.userInfo[@"NSLocalizedDescription"], nil);
            });
        }
    }];
    
    [httpRequestOperation start];
}

#pragma mark - Public methods

+ (void)postCommand:(NSString *)command
                url:(NSString *)url
         parameters:(NSDictionary *)parameters
      responseBlock:(HTTPRequestResponseBlock)responseBlock {
    return [self postCommand:command url:url parameters:parameters timeout:20 responseBlock:responseBlock];
}

+ (void)postCommand:(NSString *)command
                url:(NSString *)url
         parameters:(NSDictionary *)parameters
            timeout:(NSTimeInterval)timeout
      responseBlock:(HTTPRequestResponseBlock)responseBlock {
    
    [self startRequestCommand:command
                          url:url
                       method:@"POST"
                   parameters:parameters
                      timeout:timeout
                responseBlock:responseBlock];
}

@end
