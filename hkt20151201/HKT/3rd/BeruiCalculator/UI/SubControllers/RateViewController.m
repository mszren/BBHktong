//
//  RateViewController.m
//  HKT
//
//  Created by iOS2 on 15/11/3.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "RateViewController.h"
#import "WYYControl.h"
#import "HTTPRequest+Calculator.h"
#import "LoanScaleTableViewCell.h"
#import "CalculatorDataModel.h"

@interface RateViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _index;
    NSArray* _rateArr;
    NSInteger _btnTag;
}

@property (weak, nonatomic) IBOutlet UITableView *rateTableView;

@property(strong,nonatomic)NSMutableArray* rateNameArray;
@property(strong,nonatomic)NSMutableArray* rateNumArray;

@end


@implementation RateViewController

-(id)initWithRateArray:(NSArray *)rateArray rateIndex:(NSInteger)index btnTag:(NSInteger)btnTag
{
    self = [super init];
    if (self) {
        _index = index;
        _rateArr = rateArray;
        _btnTag = btnTag;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _rateNameArray = [[NSMutableArray alloc]init];
    [self setNavgationBarButttonAndLabelTitle:@"利率选择"];
}

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _rateArr.count/4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"LoanScaleTableViewCell";
    LoanScaleTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"LoanScaleTableViewCell" owner:self options:nil]lastObject];
    }
    NSInteger sectionRow = indexPath.section;
    NSInteger cellRow = indexPath.row;
    CalculatorDataModel* model = [_rateArr objectAtIndex:sectionRow*4+ cellRow];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@%@%@",model.rateStr,model.rate,@"%"];
    if (sectionRow*4+ cellRow == _index) {
        [cell setChecked:NO];
    }else{
        [cell setChecked:YES];
    }
    return cell;
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger selectRow = indexPath.section*4 + indexPath.row;
    [_delegate rateArray:_rateArr rateIndex:selectRow btnTag:_btnTag];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
