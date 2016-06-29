//
//  PasswordView.m
//  HKT
//
//  Created by Ting on 15/11/3.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "PasswordView.h"
#import "UIColor+Hex.h"

#import "KVNProgress.h"

@interface PasswordView ()<UITextViewDelegate>{
    
    
}

@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *editView;
@property (weak, nonatomic) IBOutlet UITextView *hiddenTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editViewbottom;
@property (weak, nonatomic) IBOutlet UIButton *btnForget;

@end

@implementation PasswordView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(BOOL)becomeFirstResponder{
    [super becomeFirstResponder];
    [self.hiddenTextView becomeFirstResponder];
    return YES;
}


-(void)awakeFromNib{
    [super awakeFromNib];
    _editView.layer.borderColor     = [UIColor colorWithHex:0xd2d2d2].CGColor;
    _editView.layer.borderWidth     = 1.0f;
    _editView.layer.cornerRadius    = 4.0f;
    
    self.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.4];
    _editView.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(interceptTap)];
    [self addGestureRecognizer:tap];
    
}

-(void)interceptTap{

}

-(void)showPassWordView{
    
    [self canEdit:YES];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if(!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    UIView *topView = [[window subviews] objectAtIndex:0];
    self.frame = topView.bounds;
    [topView addSubview:self];
    
    [self layoutIfNeeded];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [_hiddenTextView becomeFirstResponder];

    
}


- (void)removeFromSuperview{
    
    [KVNProgress  dismiss];
    
    _hiddenTextView.text = @"";
    for (int i = 0; i< 106; i++) {
        UILabel *lbl =  (UILabel *)[self viewWithTag:100 + i];
        lbl.text = @"";
    }
    
    _editViewbottom.constant = 0;
    [[NSNotificationCenter defaultCenter]removeObserver:self];

    [super removeFromSuperview];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if([text isEqualToString:@"/t"]){
        
        [textView resignFirstResponder];
        return NO;
    }
    
    NSString *afterStr              = [textView.text stringByReplacingCharactersInRange:range withString:text];
    //长度为六是请求数据
    if ([afterStr length] == 6) {
        
        //回调传密码
        self.finishEdit(afterStr,self);
        
        [textView resignFirstResponder];
    }
    
    //删除制空
    UILabel *textFieldAll       = (UILabel *)[self viewWithTag:100 + [afterStr length] - 1];
    if (afterStr.length == 0) {
        UILabel *textFieldNull      = (UILabel *)[self viewWithTag:100];
        textFieldNull.text              = @"";
    }else {
        textFieldAll.text               = @"●";
        for (NSInteger j                = [afterStr length]; j < 6; j ++) {
            UILabel *textFieldAllDelete = (UILabel *)[self viewWithTag:100 + j];
            textFieldAllDelete.text         = @"";
        }
    }
    
    //限制字数
    NSInteger res  = 6 -[afterStr length];
    if(res >= 0){
        return YES;
    }
    else{
        NSRange rg = {0,[text length]+res};
        if (rg.length>0) {
            NSString *s = [text substringWithRange:rg];
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
}

#pragma mark buttonAction

-(IBAction)actionWithClose{
    
    [self removeFromSuperview];
}

-(IBAction)actionWithForgetPasswrod{
    self.forgetPassword();
    [self removeFromSuperview];
}


#pragma mark NSNotificationCenter -keyboard

- (void)inputKeyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardEndFrameWindow;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardEndFrameWindow];
    
    double keyboardTransitionDuration;
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&keyboardTransitionDuration];
    
    CGRect keyboardEndFrameView = [self convertRect:keyboardEndFrameWindow fromView:nil];
    
    [UIView animateWithDuration:keyboardTransitionDuration animations:^{
        _editViewbottom.constant = keyboardEndFrameView.size.height + 50;
        [self layoutIfNeeded];
    } completion:nil];
}

-(void)inputKeyboardWillHide:(NSNotification *)notification{
    double keyboardTransitionDuration;
    //取出弹出时间 和收缩时间一致
    [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&keyboardTransitionDuration];
    [UIView animateWithDuration:keyboardTransitionDuration animations:^{
        //_editViewbottom.constant = 0;
        //[self layoutIfNeeded];
    } completion:nil];
}

-(void)canEdit:(BOOL)canEdit{
    if(canEdit){
        self.btnClose.enabled = YES;
        self.btnForget.hidden = NO;
        self.editView.hidden = NO;
        
    }else {
        self.btnClose.enabled = NO;
        self.btnForget.hidden = YES;
        self.editView.hidden = YES;
    }
}

#pragma mark 遮罩层

-(void)showWatting{
    [self canEdit:NO];
    [KVNProgress appearance].circleStrokeForegroundColor = [UIColor colorWithHex:blueButtonNormalColor];
    [KVNProgress appearance].statusColor = [UIColor colorWithHex:blueButtonNormalColor];
    [KVNProgress showWithParameters:@{KVNProgressViewParameterFullScreen: @(YES),
                                      KVNProgressViewParameterStatus: @"请等待...",
                                      KVNProgressViewParameterSuperview: self.backgroundView}];
}

-(void)hiddenWattingAndTryAgain{
    
    [self canEdit:YES];
    
    [_hiddenTextView becomeFirstResponder];
    _hiddenTextView.text = @"";
    for (int i = 0; i< 106; i++) {
        UILabel *lbl =  (UILabel *)[self viewWithTag:100 + i];
        lbl.text = @"";
    }
    [KVNProgress dismiss];
}

-(void)showSuccess{
    
    NSString *successTips = _successTips.length>0? _successTips : @"成功";
    
    [KVNProgress appearance].successColor = [UIColor colorWithHex:blueButtonNormalColor];
    [KVNProgress appearance].statusColor = [UIColor colorWithHex:blueButtonNormalColor];
    [KVNProgress showSuccessWithParameters:@{KVNProgressViewParameterStatus: successTips,
                                             KVNProgressViewParameterFullScreen:@(YES),
                                             KVNProgressViewParameterSuperview: self.backgroundView}
     ];
    
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2.0];
}

@end
