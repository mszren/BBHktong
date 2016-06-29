//
//  FollowUpViewController.m
//  HKT
//
//  Created by Ting on 15/11/24.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "FollowUpViewController.h"
#import "UpdatePhotoView.h"
#import "WYYControl.h"
#import "FollowUpHeadView.h"
#import "HTTPRequest+manager.h"
#import "UserManager.h"
#import "MBProgressHUD+MJ.h"
#import "STAlertView.h"

#import "ZYQAssetPickerController.h"

#define kOriginalMaxWidth 640.0
@implementation FollowUpViewControllerModel

@end

@interface FollowUpViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextViewDelegate,FollowUpHeadViewDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView* _photoImageView;
    
    NSString *followTypeSelf;
    NSString *followIdSelf;
}

@property(nonatomic ,strong)    UIButton* addImageBtn;
@property(nonatomic, strong)    UpdatePhotoView* updatePhotoView;
@property(nonatomic, strong)    FollowUpHeadView* followUpHeadView;
@property(nonatomic, weak  )    IBOutlet UIScrollView *mainScrollview;

@property(nonatomic, strong)    FollowUpViewControllerModel* followUpViewControllerModel;


//基础
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation FollowUpViewController

-(instancetype)initWithModel:(FollowUpViewControllerModel *)model{
    self = [super init];
    if(self){
        _followUpViewControllerModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readyView];
    [self showData];
    [self refreshSubView];
    
}

-(void)readyView{
    
    _imageArr = [[NSMutableArray alloc]init];
    [self.updatePhotoView.mainScrollView addSubview:self.addImageBtn];
    [self setupNaviagionBar];
    [self refreshSubView];
    followTypeSelf = @"2";
    
}

-(void)showData{
    
    self.followUpHeadView.labelName.text = _followUpViewControllerModel.customer_name;
    NSString *followText =  _followUpViewControllerModel.followText;
    
    if([_followUpViewControllerModel.followText isEqualToString:@"认筹"]){
        UIButton *buttonTag = [self.followUpHeadView viewWithTag:100];
        [buttonTag setEnabled:NO];
        UIButton *buttonTag1 = [self.followUpHeadView viewWithTag:101];
        [buttonTag1 setEnabled:NO];
    }
    
    [self showFollowText:followText];
}

-(void)showFollowText:(NSString *)followText{
    
    if ([followText isEqualToString:@"已到访"] || [followText isEqualToString:@"到访"]) {
        self.followUpHeadView.labelStates.backgroundColor = [UIColor colorWithHex:0x7ec36a];
    }else if([followText isEqualToString:@"认筹"]){
        self.followUpHeadView.labelStates.backgroundColor = [UIColor colorWithHex:0x00baed];
    }else if([followText isEqualToString:@"认购"]){
        self.followUpHeadView.labelStates.backgroundColor = [UIColor colorWithHex:0x0198dd];
    }else{
        self.followUpHeadView.labelStates.backgroundColor = [UIColor colorWithHex:0xb5b5b5];
    }
    self.followUpHeadView.labelStates.text = followText;
}

-(void)refreshSubView{
    
    //添加若干子模块
    [_mainScrollview addSubview:self.updatePhotoView];
    [_mainScrollview addSubview:self.followUpHeadView];
    
    NSDictionary *views = @{@"mainScrollview":_mainScrollview,
                            @"followUpHeadView":self.followUpHeadView,
                            @"updatePhotoView":self.updatePhotoView
                            };
    //横向
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[followUpHeadView(width)]-0-|" options:0 metrics:@{@"width":@(kDeviceWidth)} views:views]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[updatePhotoView]-0-|" options:0 metrics:nil views:views]];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[followUpHeadView]-15-[updatePhotoView]-15-|" options:0 metrics:nil views:views]];
    
}

-(void)picAction:(UIButton*)btn
{
    if (_imageArr.count > 4) {
        [self makeToast:@"最多上传5张图片"];
    }else{
        UIActionSheet *sheet;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"拍摄新照片" otherButtonTitles:@"从相册选取",@"取消", nil];
        }
        else
        {
            sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"从相册选取" otherButtonTitles:@"取消", nil];
        }
        
        sheet.tag = 255;
        [sheet showInView:self.view];
    }
    
}

#pragma mark - actionsheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255)
    {
        NSUInteger sourceType = 0;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            switch (buttonIndex)
            {
                case 2:
                    return;
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    // 相册
//                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [self presentView];
                    break;
            }
        }
        else
        {
            if (buttonIndex == 1)
            {
                return;
            }
            else
            {
//                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                [self presentView];
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }
}

-(void)presentView
{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 5-_imageArr.count;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [self presentViewController:picker animated:YES completion:NULL];
}


#pragma mark - image picker delegte

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    image = [self imageByScalingToMaxSize:image];
    [self.imageArr addObject:image];
    [self refreshData];
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
 
//    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *image=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        image = [self imageByScalingToMaxSize:image];
        [self.imageArr addObject:image];
    }
    [self refreshData];
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}


#pragma mark - image scale utility

- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < kOriginalMaxWidth) return sourceImage;
    
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = kOriginalMaxWidth;
        btWidth = sourceImage.size.width * (kOriginalMaxWidth / sourceImage.size.height);
    }
    else {
        btWidth = kOriginalMaxWidth;
        btHeight = sourceImage.size.height * (kOriginalMaxWidth / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        }
        else {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (!newImage) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)refreshData
{
    [self loadSubViews];
    _addImageBtn.frame = CGRectMake(15+85*_imageArr.count, 0, 80, 80);
    _updatePhotoView.mainScrollView.contentSize = CGSizeMake(_imageArr.count*kDeviceWidth/3,0);
    if (_imageArr.count >= 3) {
        CGPoint bottomOffset = CGPointMake(_updatePhotoView.mainScrollView.contentOffset.x, _updatePhotoView.mainScrollView.contentSize.height - _updatePhotoView.mainScrollView.bounds.size.height);
        [_updatePhotoView.mainScrollView setContentOffset:bottomOffset animated:NO];
        CGPoint newOffset = _updatePhotoView.mainScrollView.contentOffset;
        newOffset.x = 80*(_imageArr.count-3);
        newOffset.y = 0;
        [_updatePhotoView.mainScrollView setContentOffset:newOffset animated:YES];
    }
}

-(void)deleteAction:(UIButton*)btn
{
    [_imageArr removeObjectAtIndex:btn.tag - 2000];
    
    for (UIView *view in _updatePhotoView.mainScrollView.subviews) {
        [view removeFromSuperview];
    }
    _addImageBtn.frame = CGRectMake(15+85*_imageArr.count, 0, 80, 80);
    [_updatePhotoView.mainScrollView addSubview:_addImageBtn];
    [self loadSubViews];
}

-(void)loadSubViews
{
    for (int i = 0; i < _imageArr.count; i ++)
    {
        _photoImageView = [[UIImageView alloc]initWithFrame: CGRectMake(15+85*i, 5, 70, 70)];
        _photoImageView.layer.cornerRadius = 5.0f;
        _photoImageView.tag = 2500+i;
        _photoImageView.layer.masksToBounds = YES;
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_updatePhotoView.mainScrollView addSubview:_photoImageView];
        [_photoImageView setImage:self.imageArr[i]];
        
        UIButton* deleteBtn = [WYYControl createButtonWithFrame:CGRectMake(77+85*i, 0, 16, 16) ImageName:@"customer_add_img_del" Target:self Action:@selector(deleteAction:) Title:nil];
        deleteBtn.tag = 2000+i;
        [_updatePhotoView.mainScrollView addSubview:deleteBtn];
    }
}


#pragma mark UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (_updatePhotoView.followDetailTextView.text.length == 0) {
        _updatePhotoView.placeHolderLabel.hidden = NO;
    }else
        _updatePhotoView.placeHolderLabel.hidden = YES;
    
    //该判断用于联想输入
    if (textView.text.length > 500)
    {
        textView.text = [textView.text substringToIndex:500];
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if([text isEqualToString:@"\n"]){
        [_updatePhotoView.followDetailTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - FollowUpHeadViewDelegate

-(void)actionWithFollowClick:(UIButton *)button{
    
    for (int i = 100; i < 103; i++) {
        UIButton *buttonTag = [self.followUpHeadView viewWithTag:i];
        [buttonTag setSelected:NO];
    }
    
    [button setSelected:YES];
    
    NSString *followText = @"";
    
    if(button.tag==100){
        followText=@"到访";
        followIdSelf = @"4";
    }else if (button.tag==101){
        followText=@"认筹";
        followIdSelf = @"9";
    }else if (button.tag==102){
        followText=@"认购";
        followIdSelf = @"7";
    }
    
    [self showFollowText:followText];
}

-(void)actionWithTypeClick:(NSString *)type{
    followTypeSelf=type;
    if([followTypeSelf isEqualToString:@"1"]){
        followIdSelf = @"";
        [self showData];
    }
}

#pragma mark - UIButton actions

- (void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveButtonClicked{
    if(!self.updatePhotoView.followDetailTextView.text.length>0){
        [self makeToast:@"请输入跟进内容"];
        return;
    }
    
    if([followTypeSelf isEqualToString:@"2"] && !followIdSelf.length>0){
        [self makeToast:@"请选择跟进状态"];
        return;
    }
    
    NSString *adminId = [UserManager shareUserManager].admin_id;
    NSString *followID = followIdSelf;
    NSString *type = followTypeSelf;
    NSString *customerId = _followUpViewControllerModel.customer_id;
    NSString *content = self.updatePhotoView.followDetailTextView.text;
   
    [self.saveButton setEnabled:NO];
    [self showHUDSimple];
    [HTTPRequest GJWithAdminID:adminId followID:followID customID:customerId content:content type:type pics:[_imageArr copy] completeBlock:^(BOOL ok, NSString *message, NSDictionary *dic) {
        [self.saveButton setEnabled:YES];
        [self hideHUD];
        if(ok){
            NSString *alertStr = dic[@"rewardMoney"];
            if (alertStr.length>0) {
                [STAlertView showTitle:message message:alertStr hideDelay:2.0];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self makeToast:message];
        }
    }];
}

#pragma mark getter/setter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 220, 44)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"客户跟进";
    }
    return _titleLabel;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [self getBackButton];
        [_backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

- (UIButton*)addImageBtn
{
    if (!_addImageBtn) {
        _addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addImageBtn.frame = CGRectMake(15, 0, 70, 70);
        [_addImageBtn setImage:[UIImage imageNamed:@"customer_add_img_add"] forState:UIControlStateNormal];
        [_addImageBtn addTarget:self action:@selector(picAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addImageBtn;
}

- (FollowUpHeadView *)followUpHeadView{
    if(!_followUpHeadView){
        _followUpHeadView = [[[NSBundle mainBundle]loadNibNamed:@"FollowUpHeadView" owner:self options:nil]lastObject];
        _followUpHeadView.delegate = self;
    }
    return _followUpHeadView;
}

- (UpdatePhotoView*)updatePhotoView{
    if (!_updatePhotoView) {
        _updatePhotoView = [[[NSBundle mainBundle] loadNibNamed:@"UpdatePhotoView" owner:self options:nil]lastObject];
    }
    return _updatePhotoView;
}

#pragma mark - private methods

- (void)setupNaviagionBar {
    self.navigationItem.titleView = self.titleLabel;
    [self addLeftBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:self.backButton]];
    [self addRightBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:self.saveButton]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

