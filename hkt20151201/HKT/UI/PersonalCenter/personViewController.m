//
//  personViewController.m
//  HKT
//
//  Created by app on 15-5-30.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "personViewController.h"
#import "ReviseCipher.h"
#import "Popover.h"
#import "UserManager.h"
#import "UIImageView+WebCache.h"
#import "HTTPRequest+Login.h"
#import "HTTPRequest+PersonCenterRequest.h"
#import "User.h"

@interface personViewController ()<UIGestureRecognizerDelegate,UIPopoverListViewDataSource, UIPopoverListViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ASIHTTPRequestDelegate,UIActionSheetDelegate>
{
    UIImage *image;
    UserManager *Single;
    UIButton * btnImage;
    NSString *imageURLStr;
    UIImageView *loadImage;
    NSString *RZ;
    UIActionSheet *sheet;
}
@property(nonatomic,strong)UIButton *leftButton;
@property(nonatomic,strong)UILabel *labelPhone;
@end

@implementation personViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    _labelPhone.text = Single.admin_mobile;
    [self unBtnRZ];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    imageURLStr = [[NSString alloc] init];
    Single = [UserManager shareUserManager];
    RZ = [[NSString alloc] init];
    self.title = @"个人资料";
    
    //左按钮
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 44, 44);
    [_leftButton setImage:[UIImage imageNamed:@"top_goback_left"] forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"top_goback_left_pre"] forState:UIControlStateHighlighted];
    [_leftButton addTarget:self action:@selector(buttonLeftClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_leftButton];
    [self addLeftBarButtonItem:leftBarButtonItem];

    [self login:Single.admin_mobile andPwd:Single.admin_pw];
    [self CreateHeader];
    [self CreateFooter];
    
}


-(void)CreateHeader{
    //头像背景
    UIView *viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, 80)];
    viewHead.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewHead];
    
    //头像按钮
    btnImage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnImage.frame = CGRectMake(20,13, 54, 54);
    [btnImage addTarget:self action:@selector(btnImage) forControlEvents:UIControlEventTouchUpInside];
    btnImage.tag = 350;
    btnImage.layer.cornerRadius = 27.0;
    btnImage.layer.borderWidth = 1.0;
    btnImage.layer.borderColor = [UIColor clearColor].CGColor;
    btnImage.clipsToBounds =TRUE;
    [viewHead addSubview:btnImage];
    
    loadImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 54, 54)];
    loadImage.image = [UIImage imageNamed:@"personal_head"];
    if (Single.userHeaderImg.length != 0) {
        [loadImage sd_setImageWithURL:[NSURL URLWithString:Single.userHeaderImg]];
    }
    [btnImage addSubview:loadImage];
    
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(84, 0, 150, 80)];
    labelName.textColor = [UIColor colorWithRed:3/255.0f green:3/255.0f blue:3/255.0f alpha:1];
    labelName.text = Single.admin_truename;
    labelName.font = [UIFont systemFontOfSize:18];
    [viewHead addSubview:labelName];
    
    
}

-(void)CreateFooter{
    UIView *viewFoot = [[UIView alloc] initWithFrame:CGRectMake(0, 92, ScreenSize.width, 176)];
    viewFoot.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewFoot];
    NSArray *arrBtnNameArr = @[@"手机号码",@"所属楼盘",@"身份认证",@"登录密码"];
    NSArray *labelChangeArr = @[@"更换",@"未认证",@"未认证",@"修改"];
    
    for (int i = 0; i < 4; i ++) {
        UIButton *btnAll = [UIButton buttonWithType:UIButtonTypeCustom];
        btnAll.frame = CGRectMake(0, 44 * i, ScreenSize.width, 44);
        btnAll.tag = 500 + i;
        
        [btnAll setTitle:[arrBtnNameArr objectAtIndex:i] forState:UIControlStateNormal];
        [btnAll setTitleColor:[UIColor colorWithRed:3/255.0f green:3/255.0f blue:3/255.0f alpha:1] forState:UIControlStateNormal];
        [btnAll setBackgroundImage:[UIImage imageNamed:@"whiteBg"] forState:UIControlStateNormal];
        [btnAll setBackgroundImage:[UIImage imageNamed:@"gray2"] forState:UIControlStateHighlighted];
        btnAll.titleLabel.font = [UIFont systemFontOfSize:16];
        btnAll.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btnAll.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        
        [btnAll addTarget:self action:@selector(btnAll:) forControlEvents:UIControlEventTouchUpInside];
        [viewFoot addSubview:btnAll];
        
        if (i == 0) {
            _labelPhone = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 150, 44)];
            _labelPhone.textColor = [UIColor lightGrayColor];
            _labelPhone.font = [UIFont systemFontOfSize:14];
            [btnAll addSubview:_labelPhone];
        }
        
        if (i != 3) {
            //线
            UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(15, 43.5 , ScreenSize.width - 15, 0.5)];
            labelLine.backgroundColor = [UIColor colorWithHex:0xdcdcdc];
            [btnAll addSubview:labelLine];

        }
        //箭头
        UIImageView *imageViewArrow = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenSize.width - 24, 14, 9, 16)];
        imageViewArrow.image = [UIImage imageNamed:@"arrow"];
        imageViewArrow.tag = 600 + i;
        [btnAll addSubview:imageViewArrow];
        
        //可改变字
        UILabel *labelChange = [[UILabel alloc] initWithFrame:CGRectMake(200, 14, ScreenSize.width - 200 - 39, 16)];
        labelChange.textColor = [UIColor lightGrayColor];
        labelChange.tag = 700 + i;
        labelChange.text = [labelChangeArr objectAtIndex:i];
        labelChange.font = [UIFont systemFontOfSize:16];
        labelChange.textAlignment = NSTextAlignmentRight;
        [btnAll addSubview:labelChange];
    }
    
    
}



//点击按钮
-(void)btnAll:(UIButton *)btnAll{
    
    if (btnAll.tag == 500) {
        //修改手机号
        ChangePhoneNumber *CP = [[ChangePhoneNumber alloc] init];
        [self.navigationController pushViewController:CP animated:YES];
        
    }else if(btnAll.tag == 503){
        //修改密码
        ReviseCipher *rpw = [[ReviseCipher alloc] init];
        [self.navigationController pushViewController:rpw animated:YES];
    }else {
        //所属楼盘 身份
        identificationViewController *identification = [[identificationViewController alloc] init];
        [self.navigationController pushViewController:identification animated:YES];
    }
    
}

//改图片
-(void)btnImage
{
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


-(void)buttonLeftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}



#pragma mark - 上传图像
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    CGSize imagesize = image.size;
    
    imagesize.height =225;
    
    imagesize.width =225;
    UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(imagesize.height, imagesize.width)];
    loadImage.image = smallImage;
    [HTTPRequest uploadHeaderImgWithAdminId:Single.admin_id HeadPic:smallImage completeBlock:^(BOOL ok, NSString *message,NSString *headPicURL) {
        if(ok){
            [User updateHeadImgWithLoginName:headPicURL HeadImgUrl:headPicURL];
            //新头像
            NSURL *url1 = [NSURL URLWithString:headPicURL];
            [loadImage sd_setImageWithURL:url1];
            imageURLStr = headPicURL;
            Single.userHeaderImg = headPicURL;
            NSLog(@"Single.userHeaderImg333333 ======= %@",Single.userHeaderImg);

            [self makeToast:@"上传成功" duration:1];
        }else {
            [self makeToast:message];
        }
    }];
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


-(void)login:(NSString *)loginName andPwd:(NSString*)pwd{
    [HTTPRequest loginWithPhone:loginName password:pwd completeBlock:^(BOOL ok, NSString *message, NSDictionary *data) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(ok){
            imageURLStr = [data objectForKey:@"admin_head_img"];
            Single.userHeaderImg = imageURLStr;
            Single.admin_hid = [data objectForKey:@"admin_hid"];
            _labelPhone.text = [data objectForKey:@"admin_mobile"];
            NSString *admin_attr = [NSString stringWithFormat:@"%@",[data objectForKey:@"admin_attr"]];
            Single.admin_attr  = admin_attr;
            UILabel *labelChangeStauts2 = (UILabel *)[self.view viewWithTag:701];
            UILabel *labelChangeStauts3 = (UILabel *)[self.view viewWithTag:702];
            labelChangeStauts2.text = RZ;
            labelChangeStauts3.text = RZ;
            [self unBtnRZ];
            NSURL *url = [NSURL URLWithString:imageURLStr];
            if (imageURLStr.length != 0) {
                [loadImage sd_setImageWithURL:url];
            }
        }else {
            [self makeToast:message duration:1];
            
        }
    }];
    
}

-(void)unBtnRZ{
    UIImageView *imageViewArrow2 = (UIImageView *)[self.view viewWithTag:601];
    UIImageView *imageViewArrow3 = (UIImageView *)[self.view viewWithTag:602];
    
    if ([Single.admin_attr isEqual:@"1"]) {
        RZ = @"认证失败";
    }
    else if ([Single.admin_attr isEqual:@"2"]){
        imageViewArrow2.hidden = YES;
        imageViewArrow3.hidden = YES;
        RZ = @"已认证";
    }else if ([Single.admin_attr isEqual:@"3"])
    {
        imageViewArrow2.hidden = YES;
        imageViewArrow3.hidden = YES;
        Single.admin_hid = @"认证中";
        RZ = @"认证中";
    }else{
        RZ = @"未认证";
    }
    UILabel *labelChangeStauts2 = (UILabel *)[self.view viewWithTag:701];
    UILabel *labelChangeStauts3 = (UILabel *)[self.view viewWithTag:702];
    UIButton *btnHouseRZ = (UIButton *)[self.view viewWithTag:501];
    UIButton *btnIdentityRZ = (UIButton *)[self.view viewWithTag:502];
    labelChangeStauts2.text = Single.admin_hid;
    labelChangeStauts3.text = RZ;
    if ([RZ isEqualToString:@"已认证"] ||[RZ isEqualToString:@"认证中"]) {
        btnHouseRZ.userInteractionEnabled = NO;
        btnIdentityRZ.userInteractionEnabled = NO;
    }else{
        btnHouseRZ.userInteractionEnabled = YES;
        btnIdentityRZ.userInteractionEnabled = YES;
    }

    
    
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}


-(void)viewDidDisappear:(BOOL)animated
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

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
