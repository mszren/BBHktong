//
//  managerCell.m
//  HKT
//
//  Created by app on 15-6-26.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "managerCell.h"
#import "CoreLabel.h"

@implementation managerCell
{
    UILabel *customer_name;
    UILabel *followText;
    
    UIView *viewDetail;
    CoreLabel *noteNums;
    UILabel *push_last_uptime;
    UILabel *noteText;
    UILabel *noteTypeText;
    UILabel *labelNull;
    UILabel *labelCenter;
    UIButton *btnPhone;
    NSString *phoneStr;
}


- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        phoneStr = [[NSString alloc] init];
        
        UIView *viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width, 15)];
        viewTop.backgroundColor = [UIColor colorWithHex:0xf0f2f5];
        [self.contentView addSubview:viewTop];
        
        _detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _detailBtn.frame = CGRectMake(0, 15, ScreenSize.width, 44);
        [_detailBtn setBackgroundColor:[UIColor whiteColor]];
        [_detailBtn addTarget:self action:@selector(managerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _detailBtn.tag = 1;
        [self.contentView addSubview:_detailBtn];
        
        customer_name = [[UILabel alloc] init];
        customer_name.font = [UIFont systemFontOfSize:16];
        [_detailBtn addSubview:customer_name];
        
        followText = [[UILabel alloc] init];
        followText.font = [UIFont systemFontOfSize:14];
        followText.textColor = [UIColor whiteColor];
        followText.layer.masksToBounds = YES;
        followText.layer.cornerRadius = 10;
        [_detailBtn addSubview:followText];
        
        _thinkText = [[UILabel alloc] init];
        _thinkText.textAlignment = NSTextAlignmentCenter;
        _thinkText.layer.masksToBounds = YES;
        _thinkText.layer.cornerRadius = 9.5;
        [_detailBtn addSubview:_thinkText];
        
        UIImageView *imageViewArrow = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenSize.width - 23, 14, 8, 16)];
        imageViewArrow.image = [UIImage imageNamed:@"arrow"];
        [_detailBtn addSubview:imageViewArrow];
        
        UILabel *LineHead = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, ScreenSize.width, 1)];
        LineHead.backgroundColor = [UIColor colorWithHex:0xf0f2f5];
        [_detailBtn addSubview:LineHead];
        
        //跟进详情
        viewDetail = [[UIView alloc] init];
        viewDetail.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:viewDetail];
        
        noteNums = [[CoreLabel alloc] init];
        noteNums.textColor = [UIColor colorWithHex:0x999999];
        noteNums.font = [UIFont systemFontOfSize:14];
       
        push_last_uptime = [[UILabel alloc] init];
        push_last_uptime.font = [UIFont systemFontOfSize:14];
        push_last_uptime.textColor = [UIColor colorWithHex:0x999999];
        
        noteTypeText = [[UILabel alloc] init];
        noteTypeText.font = [UIFont systemFontOfSize:14];
        noteTypeText.textColor = [UIColor colorWithHex:0x333333];
        
        noteText = [[UILabel alloc] init];
        noteText.font = [UIFont systemFontOfSize:14];
        noteText.textColor = [UIColor colorWithHex:0x666666];
        //没数据时
        labelNull = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 80, 14)];
        labelNull.text = @"暂无跟进";
        labelNull.font = [UIFont systemFontOfSize:16];
        labelNull.textColor = [UIColor colorWithHex:0x666666];
        
        //按钮
        
        btnPhone = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnPhone setBackgroundColor:[UIColor colorWithHex:0xfbf9f9]];
        [btnPhone setTitle:@"电话" forState:UIControlStateNormal];
        btnPhone.titleLabel.font = [UIFont systemFontOfSize:14];
        [btnPhone setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
        [btnPhone addTarget:self action:@selector(btnPhoneClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btnPhone];
        btnPhone.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
        UIImageView *imageViewPhone = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenSize.width / 4 - 24, 10, 24, 24)];
        imageViewPhone.image = [UIImage imageNamed:@"customer_record_call"];
        [btnPhone addSubview:imageViewPhone];
        
       
        
        _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_followBtn setBackgroundColor:[UIColor colorWithHex:0xfbf9f9]];
        [_followBtn setTitle:@"跟进" forState:UIControlStateNormal];
        _followBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_followBtn setTitleColor:[UIColor colorWithHex:0x666666] forState:UIControlStateNormal];
        [_followBtn addTarget:self action:@selector(managerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _followBtn.tag = 2;
        _followBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
        [self.contentView addSubview:_followBtn];
        
        labelCenter = [[UILabel alloc] init];
        labelCenter.backgroundColor = [UIColor colorWithHex:0xdddbdb];
        [_followBtn addSubview:labelCenter];
        
        
        UILabel * LineFootLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width/2, 1)];
        LineFootLeft.backgroundColor = [UIColor colorWithHex:0xf0f2f5];
        [btnPhone addSubview:LineFootLeft];
        
        
        UILabel * LineFootRight = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenSize.width/2, 1)];
        LineFootRight.backgroundColor = [UIColor colorWithHex:0xf0f2f5];
        [_followBtn addSubview:LineFootRight];
        
        UIImageView *imageViewFollow = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenSize.width / 4 - 24, 10, 24, 24)];
        imageViewFollow.image = [UIImage imageNamed:@"customer_genjin"];
        [_followBtn addSubview:imageViewFollow];
        
        //去掉阴影效果
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    return self;
}

-(void)setModel:(managerModel *)model
{
    if (_model!=model) {
        _model = model;
    }
    
    customer_name.text = model.customer_name;
    customer_name.frame = CGRectMake(15, 12, [model.customer_name length]  * 16, 20);
    phoneStr = model.PhoneStr;
    followText.text = model.followText;
    followText.frame = CGRectMake([model.customer_name length]  * 16 + 25, 12, 60, 20);
    [followText setTextAlignment:NSTextAlignmentCenter];
    if ([followText.text isEqualToString:@"已到访"]) {
        followText.backgroundColor = [UIColor colorWithHex:0x7ec36a];
    }else if([followText.text isEqualToString:@"认筹"]){
         followText.backgroundColor = [UIColor colorWithHex:0x00baed];
    }else if([followText.text isEqualToString:@"认购"]){
        followText.backgroundColor = [UIColor colorWithHex:0x0198dd];
    }else{
        followText.backgroundColor = [UIColor colorWithHex:0xb5b5b5];
    }
    
    _thinkText.text = model.thinkText;
    _thinkText.frame = CGRectMake([model.customer_name length]  * 16 + 30 + 60, 12, 19, 19);
    _thinkText.textColor = [UIColor whiteColor];
    _thinkText.textAlignment = NSTextAlignmentCenter;
    if ([_thinkText.text isEqualToString:@"A"]) {
        _thinkText.backgroundColor = [UIColor colorWithHex:0xff3737];
    }else if ([_thinkText.text isEqualToString:@"B"]) {
        _thinkText.backgroundColor = [UIColor colorWithHex:0xf19149];
    }else if([_thinkText.text isEqualToString:@"C"])
    {
       _thinkText.backgroundColor = [UIColor colorWithHex:0xf2bc11];
    }else if([_thinkText.text isEqualToString:@"D"])
    {
        _thinkText.backgroundColor = [UIColor colorWithHex:0x4bdd8b];
    }else {
       _thinkText.backgroundColor = [UIColor clearColor];
    }

    push_last_uptime.text = [NSString stringWithFormat:@"时间:%@",[model.push_last_uptime stringByReplacingOccurrencesOfString: @"." withString: @"-"]];
    noteNums.text = [NSString stringWithFormat:@"第%@次跟进",model.noteNums];
    noteTypeText.text = model.noteTypeText;
    noteText.text = model.noteText;
    noteText.numberOfLines = 0;
    
//    if (push_last_uptime.text.length == 0) {
    if ([[NSString stringWithFormat:@"%@",model.noteNums] isEqualToString:@"0"]) {
        labelNull.text = @"暂无跟进";
        //跟进次数为空
        noteNums.frame = CGRectMake(15, 10, 0, 0);
        push_last_uptime.frame = CGRectMake(90, 10, 0, 0);

        if (noteText.text.length == 0) {
            //跟进记录为空
            noteTypeText.frame = CGRectMake(15, 34, 0, 0);
            noteText.frame = CGRectMake(15 + [noteTypeText.text length] * 11, 33, 0, 0);
            [viewDetail addSubview:labelNull];
            viewDetail.frame = CGRectMake(0, 59, ScreenSize.width, 44);
            btnPhone.frame = CGRectMake(0, 102, ScreenSize.width / 2, 44);
            _followBtn.frame = CGRectMake(ScreenSize.width / 2, 102, ScreenSize.width / 2, 44);

        }else{
            //跟进记录不为空
            noteTypeText.frame = CGRectMake(15, 10, [noteTypeText.text length] * 11, 14);
            CGSize noteTextTrueSize = [model.noteText sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 30 - [noteTypeText.text length] * 11, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
            
            noteText.frame = CGRectMake(15 + [noteTypeText.text length] * 11, 9, ScreenSize.width - 30 - [noteTypeText.text length] * 14, noteTextTrueSize.height);
            [viewDetail addSubview:noteTypeText];
            [viewDetail addSubview:noteText];
            viewDetail.frame = CGRectMake(0, 59, ScreenSize.width, noteTextTrueSize.height + 30);
        }

    }else{
            labelNull.text = @"";
            [viewDetail addSubview:noteNums];
            [viewDetail addSubview:push_last_uptime];
            //跟进次数不为空
        
        if ([model.noteNums intValue] < 10) {
            [noteNums addAttr:CoreLabelAttrColor value:[UIColor colorWithHex:0x009944] range:NSMakeRange(1,1
                                                                                                         )];

        }else{
            [noteNums addAttr:CoreLabelAttrColor value:[UIColor colorWithHex:0x009944] range:NSMakeRange(1,2
                                                                                                         
                                                                                                         )];
        }
            noteNums.frame = CGRectMake(15, 10, 80, 14);
                    push_last_uptime.frame = CGRectMake(90, 10, 150, 14);
        
            if (noteText.text.length == 0) {
                //跟进记录为空
                noteTypeText.frame = CGRectMake(15, 34, 0, 0);
                noteText.frame = CGRectMake(15 + [noteTypeText.text length] * 11, 33, 0, 0);
                viewDetail.frame = CGRectMake(0, 59, ScreenSize.width, 34);
            }else{
                [viewDetail addSubview:noteTypeText];
                [viewDetail addSubview:noteText];
                //跟进记录不为空
                CGSize noteTextTrueSize = [model.noteText sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 30 - [noteTypeText.text length] * 11, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
                                
                noteText.frame = CGRectMake(15 + [noteTypeText.text length] * 11, 33, ScreenSize.width - 30 - [noteTypeText.text length] * 14, noteTextTrueSize.height);
                noteTypeText.frame = CGRectMake(15, 34, [noteTypeText.text length] * 11, 14);
                
                viewDetail.frame = CGRectMake(0, 59, ScreenSize.width, 34 + noteTextTrueSize.height + 10);
                
            }

            
}
    
//        LineFoot.frame = CGRectMake(0, 34 + viewDetail.frame.size.height, ScreenSize.width, 0.5);
    
        btnPhone.frame = CGRectMake(0, viewDetail.frame.size.height + 59, ScreenSize.width / 2, 44);
        labelCenter.frame = CGRectMake(0,7, 1, 30);
        _followBtn.frame = CGRectMake(ScreenSize.width / 2-0.5, viewDetail.frame.size.height + 59, ScreenSize.width / 2, 44);
    }

-(void)managerBtnClick:(UIButton *)managerBtn{
//用代理指针调用代理方法
//遵循协议
    
    if([self.delegate respondsToSelector:@selector(managerBtnClick:)]){
            [self.delegate managerBtnClick:managerBtn];
        }
}

-(void)btnPhoneClick{
    [MobClick event:@"call_phone"];
    NSURL *telUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",phoneStr]];
    if( [[UIApplication sharedApplication] canOpenURL:telUrl]){
        [[UIApplication sharedApplication]openURL:telUrl];
    }
}

//-(void)HKTCellBtnClick:(UIButton *)btn{
//    //用代理指针调用代理方法
//    //遵循协议
//    if([self.delegate respondsToSelector:@selector(HKTCellBtnClick:)]){
//        [self.delegate HKTCellBtnClick:btn];
//    }
//    
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
