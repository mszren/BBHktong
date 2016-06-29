//
//  HTTPRequest+PersonCenterRequest.h
//  HKT
//
//  Created by app on 15/11/9.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "HTTPRequest.h"

@interface HTTPRequest (PersonCenterRequest)

+(void)uploadHeaderImgWithAdminId:(NSString *)AdminId
                           HeadPic:(UIImage *)HeadPic
                     completeBlock:(void (^)(BOOL ok, NSString *message,NSString *headPicURL))completeBlock;

//上传认证
+(void)uploadIdentifyImgWithUserId:(NSString *)userId
                       pictrue:(UIImage *)pictrue
                       houseName:(NSString *)houseName
                       adminTruename:(NSString *)adminTruename
                 completeBlock:(void (^)(BOOL ok, NSString *message,NSString *rewardMoney))completeBlock;

@end
