//
//  TimeChooseViewController.m
//  HKT
//
//  Created by iOS2 on 15/11/5.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "TimeChooseViewController.h"
#import "LoanScaleTableViewCell.h"
#import "WYYControl.h"
#import "LoanScaleTableViewCell.h"

@interface TimeChooseViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* _dataSource;

}
@property (weak, nonatomic) IBOutlet UITableView *timeChooseTableView;

@end

@implementation TimeChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[NSMutableArray alloc]init];
    for (int i=1; i <= 30; i ++) {
        NSString* year = [NSString stringWithFormat:@"%d年(%d期)",i,12*i];
        [_dataSource addObject:year];
    }
    [self setNavgationBarButttonAndLabelTitle:@"按揭年数"];
}

#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"LoanScaleTableViewCell";
    LoanScaleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil]lastObject];
    }
    cell.titleLabel.text = _dataSource[indexPath.row];
    if(indexPath.row == self.index-1){
        [cell setChecked:NO];
    }else {
        [cell setChecked:YES];
    }
    return cell;
}


#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger selectRow = indexPath.row + 1;
    [_delegate transmitTimeIndex:selectRow btnTag:_btnTag];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
