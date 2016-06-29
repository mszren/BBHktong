//
//  GrabCunstomerTableViewCell.m
//  HKT
//
//  Created by Ting on 15/11/19.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "GrabCunstomerTableViewCell.h"
#import "PureColorToImage.h"
#import "GrabCustomerModel.h"


@implementation GrabCunstomerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImage *imgBtn = [PureColorToImage imageWithColor:[UIColor colorWithHex:0xff3737] andWidth:10.0f andHeight:10.0f];
    UIImage *imgBtnDisabled = [PureColorToImage imageWithColor:[UIColor colorWithHex:0xcccccc] andWidth:10.0f andHeight:10.0f];
    
    [_btnForGrab setBackgroundImage:imgBtn forState:UIControlStateNormal];
    [_btnForGrab setBackgroundImage:imgBtnDisabled forState:UIControlStateDisabled];
    
    _btnForGrab.layer.cornerRadius  = 5.0f;
    _btnForGrab.clipsToBounds = YES;
    
    _lblForHour.backgroundColor = [UIColor colorWithHex:0xf0f2f5];
    _lblForMins.backgroundColor = [UIColor colorWithHex:0xf0f2f5];
    _lblForSec.backgroundColor = [UIColor colorWithHex:0xf0f2f5];
    
    _lblForHour.textColor = [UIColor colorWithHex:0x9b7039];
    _lblForMins.textColor = [UIColor colorWithHex:0x9b7039];
    _lblForSec.textColor = [UIColor colorWithHex:0x9b7039];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showData)
                                                 name:@"countDown"
                                               object:nil];
    // Initialization code
}

- (void)setModel:(GrabCustomerModel *)model{
    _model = model;
    [self showData];
}

- (void)showData{
   
    self.lblForName.text = _model.customer_name;
    [self.btnForPhoneNum setTitle:_model.customer_tel forState:UIControlStateNormal];
    
    NSInteger h= _model.sec/3600;
    NSInteger m=(_model.sec-h*3600)/60;
    NSInteger s=(_model.sec-h*3600)%60;
    
    self.lblForHour.text = [NSString stringWithFormat:@"%02zd",h];
    self.lblForMins.text = [NSString stringWithFormat:@"%02zd",m];
    self.lblForSec.text =  [NSString stringWithFormat:@"%02zd",s];
}

-(IBAction)actionWithPhoneCall:(UIButton *)btn{
    if(_delegate && [_delegate respondsToSelector:@selector(actionWithPhoneCall:)]){
        [_delegate actionWithPhoneCall:btn];
    }
}

-(IBAction)actionWithGrabCunstomer:(UIButton *)btn{
    if(_delegate && [_delegate respondsToSelector:@selector(actionWithGrabCunstomer:)]){
        [_delegate actionWithGrabCunstomer:btn];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
