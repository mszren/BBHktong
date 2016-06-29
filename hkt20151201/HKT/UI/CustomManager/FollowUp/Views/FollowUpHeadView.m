//
//  FollowUpHeadView.m
//  HKT
//
//  Created by Ting on 15/11/24.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "FollowUpHeadView.h"
#import "FollowUpHeadTableViewCell.h"


@interface FollowUpHeadView ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)NSIndexPath *selectIndex;

@property(nonatomic,strong)NSArray *dataSource;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *followUpStateHeight;

@end

@implementation FollowUpHeadView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.labelStates.clipsToBounds = YES;
    self.labelStates.textColor = [UIColor whiteColor];
    self.labelStates.layer.cornerRadius = 11.0f;
}
 

-(IBAction)followUpButtonClick:(UIButton *)button{
    
    
    if(_delegate && [_delegate respondsToSelector:@selector(actionWithFollowClick:)]){
        [_delegate actionWithFollowClick:button];
    }
    

}



#pragma mark -- UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"FollowUpHeadTableViewCell";
    
    FollowUpHeadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell =  [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]lastObject];
        
    }
    
    if(indexPath.row == self.selectIndex.row && self.selectIndex!= nil){
        [cell setSelectedSytle:YES];
    }else{
        [cell setSelectedSytle:NO];
    }
    
    NSString *str = [self.dataSource objectAtIndex:indexPath.row];
    cell.titleLabel.text = str;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!self.selectIndex) {
        self.selectIndex = indexPath;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        BOOL selectTheSameRow = indexPath.row == self.selectIndex.row? YES:NO;
        NSIndexPath *tempIndexPath = [self.selectIndex copy];
        //两次点击不同的cell
        if (!selectTheSameRow) {
            self.selectIndex = indexPath;
            [tableView reloadRowsAtIndexPaths:@[tempIndexPath,indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
    if(indexPath.row==1){
      
        if(_delegate && [_delegate respondsToSelector:@selector(actionWithTypeClick:)]){
            [_delegate actionWithTypeClick:@"2"];
        }
        
        self.followUpStateHeight.constant = 155;
        [self layoutIfNeeded];
    }else if(indexPath.row==0){
        
        if(_delegate && [_delegate respondsToSelector:@selector(actionWithTypeClick:)]){
            [_delegate actionWithTypeClick:@"1"];
        }

        for (int i = 100; i < 103; i++) {
            UIButton *buttonTag = [self viewWithTag:i];
            [buttonTag setSelected:NO];
        }
        self.followUpStateHeight.constant = 0;
        [self layoutIfNeeded];
    }
}

#pragma mark getter/setter

-(NSIndexPath *)selectIndex{
    if(!_selectIndex){
        _selectIndex = [NSIndexPath indexPathForRow:1 inSection:0];
    }
    return _selectIndex;
}

-(NSArray *)dataSource{
    if(!_dataSource){
        _dataSource = @[@"电话跟进",@"案场跟进"];
    }
    return _dataSource;
}

@end
