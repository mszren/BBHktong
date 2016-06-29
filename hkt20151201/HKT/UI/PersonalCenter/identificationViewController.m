//
//  identificationViewController.m
//  HKT
//
//  Created by app on 15-6-19.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "identificationViewController.h"
#import "STAlertView.h"
#import "MBProgressHUD+MJ.h"
#import "HTTPRequest+PersonCenterRequest.h"

@interface identificationViewController ()<UIAlertViewDelegate,UITextFieldDelegate,UIActionSheetDelegate>
{
    UIActionSheet *sheet;
    UIImage *image;
    UIButton *btnZJZ;
    UserManager *Single;
    UIAlertView *alert;
    UIImage *smallImage;
    ASIFormDataRequest *request;
}

@property(nonatomic,copy)UIView *viewBgHouse;
@property(nonatomic,copy)UITextField *textFieldHouse;
@property(nonatomic,copy)UIView *viewBgName;
@property(nonatomic,copy)UITextField *textFieldName;
@property(nonatomic,copy)UILabel *labelIdentify;
@property(nonatomic,copy)UIButton *btnIdentify;
@property(nonatomic,copy)UILabel *labelExample;
@property(nonatomic,copy)UIImageView *imageViewExample;
@property(nonatomic,copy)UILabel *labelIdentifyUpload;
@property(nonatomic,copy)UIImageView *imageViewAdd;

@end

@implementation identificationViewController
-(void)dealloc{
    
    [request setDelegate:nil];
    [request cancel];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    Single = [UserManager shareUserManager];
    self.title = @"身份认证";
    
    //左按钮
    UIButton *leftButton = [self getBackButton];
    [leftButton addTarget:self action:@selector(buttonLeftClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    [self addLeftBarButtonItem:leftBarButtonItem];
    
    //右按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 44, 44);
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(buttonRight1Click) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    [self addRightBarButtonItem:rightBarButtonItem];
    
    UIScrollView *sc = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    sc.showsVerticalScrollIndicator = NO;
    [self.view addSubview:sc];
    
    _viewBgHouse = [[UIView alloc] initWithFrame:CGRectMake(0, 15, ScreenSize.width, 44)];
    _viewBgHouse.backgroundColor = [UIColor whiteColor];
    [sc addSubview:_viewBgHouse];
    
    _textFieldHouse = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, ScreenSize.width - 30, 44)];
    _textFieldHouse.font = [UIFont systemFontOfSize:16];
    _textFieldHouse.textColor = [UIColor blackColor];
    _textFieldHouse.keyboardType = UIKeyboardTypeDefault;
    _textFieldHouse.placeholder = @"所属楼盘";
    _textFieldHouse.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textFieldHouse.delegate = self;
    [_viewBgHouse addSubview:_textFieldHouse];
    
    _viewBgName = [[UIView alloc] initWithFrame:CGRectMake(0, 74, ScreenSize.width, 44)];
    _viewBgName.backgroundColor = [UIColor whiteColor];
    [sc addSubview:_viewBgName];
    
    _textFieldName = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, ScreenSize.width - 30, 44)];
    _textFieldName.font = [UIFont systemFontOfSize:16];
    _textFieldName.textColor = [UIColor blackColor];
    _textFieldName.keyboardType = UIKeyboardTypeDefault;
    _textFieldName.placeholder = @"真实姓名";
    _textFieldName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textFieldName.delegate = self;
    [_viewBgName addSubview:_textFieldName];
    
    _labelIdentify = [[UILabel alloc] initWithFrame:CGRectMake(15, 133, ScreenSize.width - 30, 20)];
    _labelIdentify.text = @"上传身份证:";
    _labelIdentify.textColor = [UIColor colorWithHex:0x768082];
    _labelIdentify.font = [UIFont systemFontOfSize:16];
    [sc addSubview:_labelIdentify];
    
    _btnIdentify = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnIdentify.frame = CGRectMake(ScreenSize.width / 2 - 114, 168, 228, 152);
    [_btnIdentify addTarget:self action:@selector(btnIdentifyClick)
        forControlEvents:UIControlEventTouchUpInside];
    _btnIdentify.backgroundColor = [UIColor colorWithHex:0xf6f8fa];
    [sc addSubview:_btnIdentify];
        
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = CGRectMake(0, 0, 228, 152);
    borderLayer.position = CGPointMake(CGRectGetMidX(_btnIdentify.bounds), CGRectGetMidY(_btnIdentify.bounds));
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds  cornerRadius:4].CGPath;
    borderLayer.lineWidth = 1. / [[UIScreen mainScreen] scale];
    borderLayer.lineDashPattern = @[@4, @4];
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor colorWithHex:0x768082].CGColor;
    [_btnIdentify.layer addSublayer:borderLayer];
    
    _labelIdentifyUpload = [[UILabel alloc] initWithFrame:CGRectMake(0, 46, 228, 20)];
    _labelIdentifyUpload.text = @"上传身份证照片";
    _labelIdentifyUpload.textColor = [UIColor lightGrayColor];
    _labelIdentifyUpload.font = [UIFont systemFontOfSize:16];
    _labelIdentifyUpload.textAlignment = NSTextAlignmentCenter;
    [_btnIdentify addSubview:_labelIdentifyUpload];
    
    _imageViewAdd = [[UIImageView alloc] initWithFrame:CGRectMake(92, 71, 44, 44)];
    _imageViewAdd.image = [UIImage imageNamed:@"personal_photo_add"];
    [_btnIdentify addSubview:_imageViewAdd];
    
    _labelExample = [[UILabel alloc] initWithFrame:CGRectMake(15, 335, ScreenSize.width - 30, 20)];
    _labelExample.text = @"示例:";
    _labelExample.textColor = [UIColor colorWithHex:0x768082];
    _labelExample.font = [UIFont systemFontOfSize:16];
    [sc addSubview:_labelExample];
    
    _imageViewExample = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenSize.width / 2 - 114, 370, 228, 152)];
    _imageViewExample.image = [UIImage imageNamed:@"personal_photo_upload_example"];
    [sc addSubview:_imageViewExample];
    
    
    UILabel *labelLineFoot = [[UILabel alloc] initWithFrame:CGRectMake(15, 537, ScreenSize.width - 30, 0.5)];
    labelLineFoot.backgroundColor = [UIColor colorWithHex:0x768082];
    [sc addSubview:labelLineFoot];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 552, ScreenSize.width - 30, 20)];
    label1.text = @"1.建议使用二代身份证";
    label1.textColor = [UIColor colorWithHex:0x999999];
    label1.font = [UIFont systemFontOfSize:14];
    [sc addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 572 + 4, ScreenSize.width - 30, 20)];
    label2.text = @"2.照片只支持jpg,png格式,大小最大不要超过2M";
    label2.textColor = [UIColor colorWithHex:0x999999];
    label2.font = [UIFont systemFontOfSize:14];
    [sc addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(15, 592 + 8, ScreenSize.width - 30, 45)];
    label3.font = [UIFont systemFontOfSize:14];
    label3.textColor = [UIColor colorWithHex:0x999999];
    label3.text = @"3.照片需原始照片,未经任何软件编辑修改,且使用同一场景";
    CGSize trueSize = [label3.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(ScreenSize.width - 30, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    [label3 setNumberOfLines:0];
//    label3.lineBreakMode = NSLineBreakByCharWrapping;
     label3.frame = CGRectMake(15, 592 + 8, ScreenSize.width - 30,trueSize.height );
    sc.contentSize = CGSizeMake(0, 600 + trueSize.height + 100);
    [sc addSubview:label3];
    
}


-(void)btnIdentifyClick
{
    [_textFieldName resignFirstResponder];
    [_textFieldHouse resignFirstResponder];
    sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"拍摄新照片" otherButtonTitles:@"从手机相册中选取",@"取消", nil];
    [sheet showInView:self.view];
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //相机
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        [self presentModalViewController:picker animated:YES];//进入照相界面
        
    }else if(buttonIndex == 1){
        //相册
        UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
        [pickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        pickerVC.allowsEditing = YES;
        pickerVC.delegate = self;
        [self presentViewController:pickerVC animated:YES completion:nil];
        
    }
    
}


#pragma mark - 上传图像
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    image = [info objectForKey:UIImagePickerControllerEditedImage];
    CGSize imagesize = image.size;
    imagesize.height =152;
    imagesize.width =228;
    smallImage=[self scaleFromImage:image toSize:CGSizeMake(imagesize.height, imagesize.width)];
    //     [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    NSData* dataImage;
    if (UIImagePNGRepresentation(smallImage)) {
        dataImage = UIImagePNGRepresentation(smallImage);
    }
    else {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        dataImage = UIImageJPEGRepresentation(smallImage, 1);
    }
    
    if ([image isEqual:@""]) {
        _labelIdentifyUpload.hidden = NO;
        _imageViewAdd.hidden  = NO;
    }else{
        [_btnIdentify setBackgroundImage:image forState:UIControlStateNormal];
        _labelIdentifyUpload.hidden = YES;
        _imageViewAdd.hidden  = YES;
    }
    Single.admin_attr = @"3";
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *) scaleFromImage: (UIImage *) imageOld toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [imageOld drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//上传
-(void)buttonRight1Click
{
    NSData * imageData = UIImageJPEGRepresentation(image, 1);
    if (imageData == 0) {
        [self makeToast:@"请选择图片" duration:1];
    }else if (_textFieldHouse.text.length == 0) {
        [self makeToast:@"请输入楼盘" duration:1];
    }else if (_textFieldName.text.length == 0) {
        [self makeToast:@"请输入姓名" duration:1];
    }else{
        NSLog(@"_textFieldHouse.text == %@,_textFieldName.text == %@ ,Single.admin_id == %@",_textFieldHouse.text,_textFieldName.text,Single.admin_id);

        [HTTPRequest uploadIdentifyImgWithUserId:Single.admin_id pictrue:smallImage houseName:_textFieldHouse.text adminTruename:_textFieldName.text completeBlock:^(BOOL ok, NSString *message,NSString *rewardMoney) {
            if(ok){
                Single.admin_hid = @"认证中";
                [STAlertView showTitle:@"上传成功!" message:rewardMoney hideDelay:2.0];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [self makeToast:message];
            }
        }];

    }
        
        }


/*
#pragma mark - request
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
}

- (void)requestFinished:(ASIHTTPRequest *)requestSubmit
{    
    if (requestSubmit.responseData) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:requestSubmit.responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic ==== %@",dic);
        NSDictionary *data = [dic objectForKey:@"data"];
        if ([dic[@"tips"] isEqualToString:@""]) {
            [self makeToast:@"上传成功" duration:1];

            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self makeToast:dic[@"tips"] duration:1];

        }
        
    }
}

*/

//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    if ([image isEqual:@""]) {
//        //       NSLog(@"没图片");
//    }else{
//        [btnZJZ setBackgroundImage:image forState:UIControlStateNormal];
//
//    }
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}




//#pragma mark - request
//- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
//{
//    //    NSLog(@"request %ld 建立连接...",(long)request.tag);
//}
//
//- (void)requestFinished:(ASIHTTPRequest *)request
//{
//    [self.navigationController popViewControllerAnimated:YES];
//    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
//    
////    NSDictionary *data = [dic objectForKey:@"data"];
//    [STAlertView showTitle:@"上传成功!" message:dic[@"rewardMoney"] hideDelay:2.0];
//
//    
////    if ([dic[@"tips"] isEqualToString:@""]) {
////        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"提交成功" delegate:nil cancelButtonTitle:@"好的，我知道了" otherButtonTitles: nil];
////        [alert1 show];
////        
////    }else{
////        NSLog(@"meikong");
////        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示信息" message:dic[@"tips"] delegate:nil cancelButtonTitle:@"好的，我知道了" otherButtonTitles: nil];
////        [alert1 show];
////    }
////    
//}



-(void)buttonLeftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
