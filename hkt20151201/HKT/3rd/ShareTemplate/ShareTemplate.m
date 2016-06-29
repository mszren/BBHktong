//
//  ShareTemplate.m
//  AH2House
//
//  Created by Ting on 14-8-13.
//  Copyright (c) 2014年 星空传媒控股. All rights reserved.
//

#import "ShareTemplate.h"
#import "UMSocial.h"
#import <MessageUI/MessageUI.h>
#import "IQKeyboardManager.h"

@implementation ShareModel

@end

@interface ShareTemplate ()<MFMessageComposeViewControllerDelegate,UMSocialUIDelegate>
{
    
}

@end


@implementation ShareTemplate


-(void)actionWithShare:(UIViewController *)vc WithSinaModel:(ShareModel*)shareMode andMessageTypeIsImage:(BOOL)isImage{
    
    //如果超过140个字符--截取
    if(shareMode.shareContent.length > 140){
        shareMode.shareContent =  [shareMode.shareContent substringToIndex:140];
        shareMode.shareContent = [shareMode.shareContent stringByAppendingString:@"..."];
    }
    
    UIImage *img;
    UMSocialUrlResource *imgResource;
    if(shareMode.shareImageURL.length == 0 && !shareMode.shareImage){
        img = [UIImage imageNamed:@"shareIcon"];
    }
    
    if (shareMode.shareImage){
        img = shareMode.shareImage;
    }
    
    if(shareMode.shareImageURL.length>0){
        imgResource = [[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeImage url:shareMode.shareImageURL];
    }
    
    showVc=vc;
    if (!self.activityView) {
        self.activityView = [[HYActivityView alloc]initWithTitle:@"分享到" referView:nil];
        //横屏会变成一行6个, 竖屏无法一行同时显示6个, 会自动使用默认一行4个的设置.
        self.activityView.numberOfButtonPerLine = 3;
        //微信好友
        ButtonView * bv = [[ButtonView alloc]initWithText:@"微信好友" image:[UIImage imageNamed:@"icon_weixin"] handler:^(ButtonView *buttonView){
            [self.activityView hide];
            //微信好友额外配置
            if(isImage){
                [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeImage;
            }
            [UMSocialData defaultData].extConfig.wechatSessionData.title = shareMode.shareTitle;
            [UMSocialData defaultData].extConfig.wechatSessionData.url = shareMode.shareWebURL;
            //分享
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:shareMode.shareContent image:img location:nil urlResource:imgResource presentedController:vc completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];
        }];
        [self.activityView addButtonView:bv];
        //
        //微信朋友圈
        bv = [[ButtonView alloc]initWithText:@"微信朋友圈" image:[UIImage imageNamed:@"icon_weixincircle"] handler:^(ButtonView *buttonView){
            [self.activityView hide];
            //微信朋友圈额外配置
            if(isImage){
                [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeImage;
            }
            [UMSocialData defaultData].extConfig.wechatTimelineData.title=shareMode.shareContent;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareMode.shareWebURL;
            //分享
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:shareMode.shareContent image:img location:nil urlResource:imgResource presentedController:vc completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];
        }];
        [self.activityView addButtonView:bv];
        
        //QQ
        bv = [[ButtonView alloc]initWithText:@"QQ" image:[UIImage imageNamed:@"icon_qq"] handler:^(ButtonView *buttonView){
            [self.activityView hide];
            if(isImage){
                [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
            }
            [UMSocialData defaultData].extConfig.qqData.title = shareMode.shareTitle;
            [UMSocialData defaultData].extConfig.qqData.url = shareMode.shareWebURL;
            //分享
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:shareMode.shareContent image:img location:nil urlResource:imgResource presentedController:vc completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];
        }];
        [self.activityView addButtonView:bv];
        
        //QQ空间
        bv = [[ButtonView alloc]initWithText:@"QQ空间" image:[UIImage imageNamed:@"icon_qq_zone"] handler:^(ButtonView *buttonView){
            [self.activityView hide];
            [UMSocialData defaultData].extConfig.qzoneData.title = shareMode.shareTitle;
            [UMSocialData defaultData].extConfig.qzoneData.url = shareMode.shareWebURL;
            //分享
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:shareMode.shareContent image:img location:nil urlResource:imgResource presentedController:vc completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];
        }];
        [self.activityView addButtonView:bv];
        
        //新浪微博
        bv = [[ButtonView alloc]initWithText:@"新浪微博" image:[UIImage imageNamed:@"icon_sina"] handler:^(ButtonView *buttonView){
            [self.activityView hide];
            
            [[IQKeyboardManager sharedManager] setEnable:NO];
            [UMSocialData defaultData].extConfig.sinaData.snsName = @"汇客通";
            [UMSocialData defaultData].extConfig.sinaData.shareImage = imgResource;
            
            NSString *content = [NSString stringWithFormat:@"#%@#%@%@",shareMode.shareTitle,shareMode.shareContent,shareMode.shareWebURL];
            
            //设置分享内容和回调对象
            [[UMSocialControllerService defaultControllerService] setShareText:content
                                                                    shareImage:img
                                                              socialUIDelegate:self];
            
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(vc, [UMSocialControllerService defaultControllerService], YES);
            
        }];
        [self.activityView addButtonView:bv];
        
        //短信
        bv = [[ButtonView alloc]initWithText:@"短信" image:[UIImage imageNamed:@"icon_message"] handler:^(ButtonView *buttonView){
            MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
            picker.messageComposeDelegate=self;
            picker.body = [NSString stringWithFormat:@"%@ %@",shareMode.shareContent,shareMode.shareWebURL];
            [vc presentViewController:picker animated:YES completion:NULL];
            //[[picker navigationBar] setTintColor:[XKHUtil hexStringToColor:@"#4871c5"]];
        }];
        [self.activityView addButtonView:bv];
        
        
    }
    [self.activityView show];
    
}

-(void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Result: SMS sending canceled");
            break;
        case MessageComposeResultSent:
            NSLog(@"Result: SMS sent");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Result: SMS sending failed");
            break;
        default:
            NSLog(@"Result: SMS not sent");
            break;
    }
    
    [showVc dismissViewControllerAnimated:YES completion:NULL];
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
}

@end
