//
//  HTTPRequest+PersonCenterRequest.m
//  HKT
//
//  Created by app on 15/11/9.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "HTTPRequest+PersonCenterRequest.h"
#import "HTTPRequest+Private.h"
#import "NSData+Base64.h"

@implementation HTTPRequest (PersonCenterRequest)

//上传头像
+(void)uploadHeaderImgWithAdminId:(NSString *)AdminId
                          HeadPic:(UIImage *)HeadPic
                    completeBlock:(void (^)(BOOL ok, NSString *message,NSString *headPicURL))completeBlock{
    
    NSParameterAssert(AdminId.length > 0);
    NSParameterAssert(HeadPic);
    
    NSString *url = @"http://api.berui.com/index.php/Hkt/V2/uploadHead";
    
    
    NSData *data = UIImageJPEGRepresentation(HeadPic , 0.5);
    NSString *picStream = [data base64EncodedStringWithSeparateLines:NO];
    
    NSDictionary *parameters = @{@"admin_id" : AdminId,
                                 @"headimg" : picStream,
                                 };
    
    [self postCommand:NSStringFromSelector(_cmd)
                  url:url
           parameters:parameters
        responseBlock:^(NSUInteger code, NSString *message, NSDictionary *data) {
            
            if (!completeBlock) {
                return;
            }
            
            if (code != 1) {
                completeBlock(NO, nil, message);
                return;
            }
            
            NSString *headPath = data[@"pic"];
            
            if(code == 1 && headPath.length>0){
                
                completeBlock(YES,message ,headPath );
            }else {
                completeBlock(NO, nil ,@"上传失败!");
                
            }
        }];
}


//上传认证
+(void)uploadIdentifyImgWithUserId:(NSString *)userId
                       pictrue:(UIImage *)pictrue
                     houseName:(NSString *)houseName
                 adminTruename:(NSString *)adminTruename
                 completeBlock:(void (^)(BOOL ok, NSString *message,NSString *rewardMoney))completeBlock{
    
    NSParameterAssert(userId.length > 0);
    NSParameterAssert(pictrue);
    NSParameterAssert(houseName.length > 0);
    NSParameterAssert(adminTruename.length > 0);
    
    NSString *url = @"http://api.berui.com/index.php/Hkt/V2/userAuth";
    
    
    NSData *data = UIImageJPEGRepresentation(pictrue , 0.5);
    NSString *picStream = [data base64EncodedStringWithSeparateLines:NO];
    
    NSDictionary *parameters = @{@"admin_id" : userId,
                                 @"pictrue" : picStream,
                                 @"house_name" : houseName,
                                 @"admin_truename":adminTruename
                                 };
    
    [self postCommand:NSStringFromSelector(_cmd)
                  url:url
           parameters:parameters
        responseBlock:^(NSUInteger code, NSString *message, NSDictionary *data) {
            
            if (!completeBlock) {
                return;
            }
            if (code != 1) {
                completeBlock(NO,  message,nil);
                return;
            }
            NSString *rewardMoney = data[@"rewardMoney"];
            if(code == 1){
                
                completeBlock(YES, message,rewardMoney);
            }else {
                completeBlock(NO, @"上传失败!",rewardMoney);
                
            }
        }];
}




@end
