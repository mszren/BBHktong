//
//  detailCell.m
//  HKT
//
//  Created by app on 15-7-1.
//  Copyright (c) 2015年 百瑞. All rights reserved.
//

#import "detailCell.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "UserManager.h"

@implementation detailCell
{

    UILabel *labelNoteTypeText;
    UILabel *labelNote_atime;
    UILabel *labelNote_content;
    NSArray *imageArr;
    UILabel *labelLine;
    UIImageView *imageViewCircle;
    BOOL flag;
    UIView *viewImage;
    CGRect _oldFrame;
}

-(void)setModel:(detailModel *)model
{
    //清除view子视图
    [viewImage.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    if (_model!=model) {
        _model = model;
    }
    labelNoteTypeText.text = model.noteTypeText;
    labelNote_atime.text = [model.note_atime stringByReplacingOccurrencesOfString: @"." withString: @"-"];
    ;
    labelNote_content.text = model.note_content;
    labelNote_content.numberOfLines = 0;

    imageArr = model.note_pics;
    
    if (labelNoteTypeText.text.length > 0) {
        labelNoteTypeText.frame = CGRectMake(40, 15, labelNoteTypeText.text.length * 16, 20);
        _imageViewTime.frame = CGRectMake(40, 40, 18, 18);
        labelNote_atime.frame = CGRectMake(60, 39, 250, 20);
        
        if (labelNote_content.text.length > 0) {
            CGSize noteContentTrueSize = [model.note_content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(ScreenSize.width - 55, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
            labelNote_content.frame = CGRectMake(40, 64, ScreenSize.width - 55, noteContentTrueSize.height);
            
            if (imageArr.count != 0) {
                for (int i = 0; i < imageArr.count; i ++) {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40 + 30 * i, 0, 28, 21)];
                    imageView.clipsToBounds = YES;
                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                    [imageView sd_setImageWithURL:[NSURL URLWithString:[imageArr objectAtIndex:i]]];
                    viewImage.frame = CGRectMake(0, labelNote_content.frame.size.height + 70, ScreenSize.width, 21);
                    [viewImage addSubview:imageView];
                    imageView.userInteractionEnabled = YES;
                    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BtnClick:)] ];
                    imageView.tag = 100 + i;

                }
                labelLine.frame = CGRectMake(24.5, 0, 1, labelNote_content.frame.size.height + 110);
                imageViewCircle.frame = CGRectMake(15, (labelNote_content.frame.size.height + 106)/2 - 10, 20, 20);
            }else{
                labelLine.frame = CGRectMake(24.5, 0, 1, 64 + noteContentTrueSize.height + 20);
                imageViewCircle.frame = CGRectMake(15, (64 + noteContentTrueSize.height + 15)/2 - 10, 20, 20);
            }

            
        }else{
            labelNote_content.frame = CGRectMake(40, 64, 0, 0);
           
            if (imageArr.count != 0) {
                for (int i = 0; i < imageArr.count; i ++) {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40 + 30 * i, 0, 28, 21)];
                    imageView.clipsToBounds = YES;
                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                    [imageView sd_setImageWithURL:[NSURL URLWithString:[imageArr objectAtIndex:i]]];
                    viewImage.frame = CGRectMake(0, 64, ScreenSize.width, 21);
                    [viewImage addSubview:imageView];
                    imageView.userInteractionEnabled = YES;
                    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BtnClick:)] ];
                    imageView.tag = 100 + i;

                    }
                labelLine.frame = CGRectMake(24.5, 0, 1, 85 + 20);
                imageViewCircle.frame = CGRectMake(15, 100/2 - 10, 20, 20);
            }else{
                labelLine.frame = CGRectMake(24.5, 0, 1, 75);
                imageViewCircle.frame = CGRectMake(15, 69/2 - 10, 20, 20);
            }
            
        }

        
    }else{
        labelNoteTypeText.frame = CGRectMake(40, 15, 0, 0);
        _imageViewTime.frame = CGRectMake(40, 15, 18, 18);
        labelNote_atime.frame = CGRectMake(60, 14, 250, 20);
        
        if (labelNote_content.text.length > 0) {
            CGSize noteContentTrueSize = [model.note_content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(ScreenSize.width - 55, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
            labelNote_content.frame = CGRectMake(40, 40, ScreenSize.width - 55, noteContentTrueSize.height);
            
            if (imageArr.count != 0) {
                for (int i = 0; i < imageArr.count; i ++) {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40 + 30 * i, 0, 28, 21)];
                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                    imageView.clipsToBounds = YES;
                    [imageView sd_setImageWithURL:[NSURL URLWithString:[imageArr objectAtIndex:i]]];
                    
                    viewImage.frame = CGRectMake(0, labelNote_content.frame.size.height + 46, ScreenSize.width, 21);
                    [viewImage addSubview:imageView];
                    imageView.userInteractionEnabled = YES;
                    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BtnClick:)] ];
                    imageView.tag = 100 + i;

                }
                
                labelLine.frame = CGRectMake(24.5, 0, 1, labelNote_content.frame.size.height + 82);
                imageViewCircle.frame = CGRectMake(15, (labelNote_content.frame.size.height + 82)/2 - 10, 20, 20);
            }else{

                labelLine.frame = CGRectMake(24.5, 0, 1, labelNote_content.frame.size.height + 51);
                imageViewCircle.frame = CGRectMake(15, (labelNote_content.frame.size.height + 51)/2 - 10, 20, 20);
            }

        }else{
            labelNote_content.frame = CGRectMake(40, 40, 0, 0);
            
            if (imageArr.count != 0) {
                for (int i = 0; i < imageArr.count; i ++) {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40 + 30 * i, 0, 28, 21)];
                    imageView.clipsToBounds = YES;
                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                    [imageView sd_setImageWithURL:[NSURL URLWithString:[imageArr objectAtIndex:i]]];
                    viewImage.frame = CGRectMake(0, 40, ScreenSize.width, 21);
                    [viewImage addSubview:imageView];
                    
                    imageView.userInteractionEnabled = YES;
                    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(BtnClick:)] ];
                    imageView.tag = 100 + i;
                }
                labelLine.frame = CGRectMake(24.5, 0, 1, 76);
                imageViewCircle.frame = CGRectMake(15, 76/2 - 10, 20, 20);
            }else{
                labelLine.frame = CGRectMake(24.5, 0, 1, 45);
                imageViewCircle.frame = CGRectMake(15, 45/2 - 10, 20, 20);
            }
            
        }

    }
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        flag = YES;
        labelLine = [[UILabel alloc] init];
        labelLine.backgroundColor = [UIColor colorWithHex:0xe5eaeb];
        [self.contentView addSubview:labelLine];
        
        imageViewCircle = [[UIImageView alloc] init];
        imageViewCircle.image = [UIImage imageNamed:@"customer_record_point"];
        [self.contentView addSubview:imageViewCircle];
        
        labelNoteTypeText = [[UILabel alloc] init];
        labelNoteTypeText.textColor = [UIColor colorWithHex:0x666666];
        labelNoteTypeText.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:labelNoteTypeText];
        
        _imageViewTime = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageViewTime];
        
        labelNote_atime = [[UILabel alloc] init];
        labelNote_atime.textColor = [UIColor colorWithHex:0x999999];
        labelNote_atime.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:labelNote_atime];
        
        labelNote_content = [[UILabel alloc] init];
        labelNote_content.textColor = [UIColor colorWithHex:0x666666];
        labelNote_content.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:labelNote_content];
        
        viewImage = [[UIView alloc] init];
        [self.contentView addSubview:viewImage];
    }
    //去掉阴影效果
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

#pragma  mark Button Action

-(void)BtnClick:(UITapGestureRecognizer*)tap
{
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity: [imageArr count]];

    for (int i = 0; i < [imageArr count]; i++) {
        // 替换为中等尺寸图片
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString: [imageArr objectAtIndex:i]]; // 图片路径
        
        UIImageView * imageView = (UIImageView *)[self.contentView viewWithTag: tap.view.tag ];
        photo.srcImageView = imageView;
        [photos addObject:photo];
        
    }
    // 2.显示相册
    browser.currentPhotoIndex = (tap.view.tag - 100); // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
