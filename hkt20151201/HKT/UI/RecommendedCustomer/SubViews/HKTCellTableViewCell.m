//
//  HKTCellTableViewCell.m
//  HKT
//
//  Created by app on 15-6-23.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "HKTCellTableViewCell.h"

@implementation HKTCellTableViewCell
{
    UIImageView *customer_nameImg;//头像
    UILabel *customer_name;
    
    UIImageView *customer_telImg;
    UILabel *customer_tel;
    
    UILabel *statusText;
    UILabel *statusTextN;
    
    UILabel *lineLabel;
    
    UILabel *push_atime;
    UILabel *push_atimeN;
    
    UILabel *house_name;
    
    UILabel *areaList;
    
    NSString *customer_id;
    NSString *push_id;
    UserManager *singLE;
}


- (void)awakeFromNib {
    
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *imageL = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width*1.2, 2)];
        imageL.image = [UIImage imageNamed:@"line"];
        [self.contentView addSubview:imageL];
        
        customer_nameImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [self.contentView addSubview:customer_nameImg];
        
        customer_name = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, 100, 20)];
        customer_name.font = [UIFont systemFontOfSize:16];
        customer_name.textColor = [UIColor blackColor];
        [self.contentView addSubview:customer_name];
        
        customer_telImg = [[UIImageView alloc] initWithFrame:CGRectMake(55, 35, 15, 13)];
        [self.contentView addSubview:customer_telImg];
        
        
        customer_tel = [[UILabel alloc] initWithFrame:CGRectMake(75, 35, 100, 13)];
        customer_tel.font = [UIFont  systemFontOfSize:13];
        customer_tel.textColor = [UIColor grayColor];
        
        
        [self.contentView addSubview:customer_tel];
        
//        statusTextN = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 140, 15, 50, 13)];
        statusTextN = [[UILabel alloc] init];
        statusTextN.text = @"有效期:";
        statusTextN.textColor = [UIColor grayColor];
        statusTextN.font = [UIFont boldSystemFontOfSize:12];
        [self.contentView addSubview:statusTextN];
        
//        statusText = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 100, 15, 100, 13)];
        statusText = [[UILabel alloc] init];
        statusText.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:statusText];
        
        
        lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, self.contentView.frame.size.width*1.2, 0.6)];
        lineLabel.backgroundColor = [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1];
        [self.contentView addSubview:lineLabel];
        
        push_atimeN = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 90, 20)];
        push_atimeN.text = @"推送的时间:";
        push_atimeN.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:push_atimeN];
        
        push_atime = [[UILabel alloc] initWithFrame:CGRectMake(90, 70, 200, 20)];
        push_atime.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:push_atime];
        
        house_name = [[UILabel alloc]
                      initWithFrame:CGRectMake(10, 95, 300, 20)];
        house_name.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:house_name];
        
        areaList = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, 300, 20)];
        areaList.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:areaList];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 205,self.contentView.frame.size.width*1.2, 10)];
        view.backgroundColor = [UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1];
        [self.contentView addSubview:view];
        //去掉阴影效果
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.HKTCellBtn];
    }
    return self;
    
    
    
}

-(void)setModel:(HKTModel *)model
{
    if (_model!=model) {
        _model = model;
    }
    singLE = [UserManager shareUserManager];
    customer_nameImg.image = [UIImage imageNamed:@"recommend_client_adapter_head_pre"];
    customer_telImg.image = [UIImage imageNamed:@"phone"];
    customer_name.text = model.customer_name;
    statusText.text = model.statusText;
    push_atime.text = model.push_atime;
    house_name.text = [NSString stringWithFormat:@"感兴趣的楼盘:%@",model.house_name];
    areaList.text = [NSString stringWithFormat:@"感兴趣的区域:%@",model.areaList];
    //        statusTextN = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 140, 15, 50, 13)];
    //        statusText = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 100, 15, 100, 13)];

   
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@",model.customer_tel];
    if ([model.overdue intValue] == 1) {
        statusText.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - [statusText.text length] * 12 - 25 , 15, [statusText.text length] * 12, 13);
        statusTextN.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - [statusText.text length] * 12 - 25 - 45, 15, 50, 13);
        if ([str length] == 11) {
            [str deleteCharactersInRange:NSMakeRange(9,2)];

            customer_tel.text = [NSString stringWithFormat:@"%@**",str];
        }else{
            customer_tel.text = @"无效号码";
        }
//            UILabel *labelStar = [[UILabel alloc] initWithFrame:CGRectMake(120, 38, 50, 13)];
//            labelStar.textColor = [UIColor grayColor];
//            labelStar.text  = @"*****";
//            [self.contentView addSubview:labelStar];
    }else{
    statusTextN.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - [statusText.text length] * 14  - 55, 15, 50, 13);
    statusText.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width - [statusText.text length] * 14 - 15  , 15, [statusText.text length] * 12, 13);
    customer_tel.text = model.customer_tel;
    }
    customer_id = model.customer_id;
    push_id = model.push_id;
    
    if ([model.overdue intValue] == 1) {
        _HKTCellBtn.backgroundColor = [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1];
        _HKTCellBtn.userInteractionEnabled = NO;
        [_HKTCellBtn setTitle:@"过期用户" forState:UIControlStateNormal];
        [_HKTCellBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else {
        [_HKTCellBtn setTitle:@"我要跟进" forState:UIControlStateNormal];
        _HKTCellBtn.userInteractionEnabled = YES;
        _HKTCellBtn.backgroundColor = [UIColor colorWithRed:14/255.0f green:141/255.0f blue:219/255.0f alpha:1];
        [_HKTCellBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(UIButton *)HKTCellBtn{
    if (!_HKTCellBtn) {
        _HKTCellBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _HKTCellBtn.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width / 2 - 75  , 150, 150, 40);
        _HKTCellBtn.layer.masksToBounds = YES;
        _HKTCellBtn.layer.cornerRadius = 20;
        [_HKTCellBtn addTarget:self action:@selector(HKTCellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _HKTCellBtn;
}

-(void)HKTCellBtnClick:(UIButton *)btn{
//用代理指针调用代理方法
    //遵循协议
    if([self.delegate respondsToSelector:@selector(HKTCellBtnClick:)]){
        [self.delegate HKTCellBtnClick:btn];
    }

}

@end
