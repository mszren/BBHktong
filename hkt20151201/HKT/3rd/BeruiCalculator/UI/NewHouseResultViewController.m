//
//  NewHouseResultViewController.m
//  HKT
//
//  Created by iOS2 on 15/11/6.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "NewHouseResultViewController.h"
#import "ResoldHouseResultTableViewCell.h"
#import "ResoldHouseResultFootView.h"
#import "Tax.h"
#import "NewHouseResultHeadView.h"
#import "ShareTemplate.h"

@implementation NewHouseResultModel
@end

@interface NewHouseResultViewController (){
    
    NewHouseResultModel *newHouseResult;
    NSArray *dataSource;
    float qishui;
    float maimaishouxu;
    float totalTaxPrice;
    
    NSString *shareContent;
}

//基础
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIButton *backButton;
@property(strong,nonatomic)UIButton* shareBtn;

@property (nonatomic, retain) ResoldHouseResultFootView *resoldHouseResultFootView;
@property (nonatomic, retain) NewHouseResultHeadView *newHouseResultHeadView;


@property (nonatomic, weak) IBOutlet UITableView *myTableView;

@end

@implementation NewHouseResultViewController


-(instancetype)initWithNewHouseResultModel:(NewHouseResultModel *)newHouseResultModel{
    self = [super init];
    if(self){
        newHouseResult = newHouseResultModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self readyView];
    [self readyDataSource];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.shareBtn];
    // Do any additional setup after loading the view from its nib.
}

-(void)readyView{
    [self setupNaviagionBar];
    
    _myTableView.tableFooterView = self.resoldHouseResultFootView;
    _myTableView.tableHeaderView = self.newHouseResultHeadView;
    
}

-(void)readyDataSource{
    
    
    float CPrice = newHouseResult.houseArea * newHouseResult.houseUnitPrice;
    NSLog(@"%f-----%f",newHouseResult.houseArea,newHouseResult.houseUnitPrice);
    
    //买方缴纳|总价百分比
    
    //契税 1.5%
    
    //印花税 0.05%
    
    //公证费 0.3%
    
    //委托办理产权手续费 0.3%
    
    //房屋买卖手续费  120平方米及以下的每件1000元，121—5000平方米的每件3000元，5001平方米以上的每件10000元。对经济适用房按以上收费标准的50％收费。
    
    //契税 家庭首次购买唯一住房90㎡以下1%；90㎡-144㎡2%；144㎡以上4%。非唯一 4%
    
//    float qishui = 0.0;
    
    //非唯一
    if(!newHouseResult.isOnlyHouse){
        qishui = CPrice * 0.04;
    }else {
        
        //唯一
        if(newHouseResult.houseArea <90.00){
            qishui = CPrice * 0.01;
        }else if (newHouseResult.houseArea >= 90.00 && newHouseResult.houseArea <= 144.00){
            qishui = CPrice * 0.02;
        }else {
            qishui = CPrice * 0.04;
        }
    }
    
    if(newHouseResult.houseType == notNormalHousing){
        qishui = CPrice * 0.04;
    }
    
    Tax *qishuiTax = [Tax new];
    qishuiTax.taxName = @"契税(必选):";
    qishuiTax.taxPrice = qishui;
    qishuiTax.taxColor = 0x00a1d9;
    
    //印花税 0.05%
    Tax *yinhuashuiTax = [Tax new];
    yinhuashuiTax.taxName = @"印花税(必缴):";
    yinhuashuiTax.taxPrice = CPrice * 0.0005;
    yinhuashuiTax.taxColor = 0xf2d03c;
    
    //公证费 0.3%
    Tax *gongzhengshuiTax = [Tax new];
    gongzhengshuiTax.taxName = @"公证费(可选):";
    gongzhengshuiTax.taxPrice = CPrice * 0.003;
    gongzhengshuiTax.taxColor = 0xc4d9188;
    
    //委托办理产权手续费 0.3%
    Tax *weituoshuiTax = [Tax new];
    weituoshuiTax.taxName = @"委托办理产权手续费(可选):";
    weituoshuiTax.taxPrice = CPrice * 0.003;
    weituoshuiTax.taxColor = 0x858da0;
    
    //房屋买卖手续费 2.5元/㎡
//    float maimaishouxu;
    
    maimaishouxu = newHouseResult.houseArea *2.5;
    
    Tax *maimaishouxuTax = [Tax new];
    maimaishouxuTax.taxName = @"房屋买卖手续费:";
    maimaishouxuTax.taxPrice = maimaishouxu;
    maimaishouxuTax.taxColor = 0xd06fa0;
    
    dataSource = @[qishuiTax,yinhuashuiTax,gongzhengshuiTax,weituoshuiTax,maimaishouxuTax];
    
    [self.newHouseResultHeadView setDataSource:dataSource];
    
    totalTaxPrice = qishuiTax.taxPrice + yinhuashuiTax.taxPrice + gongzhengshuiTax.taxPrice + weituoshuiTax.taxPrice + maimaishouxuTax.taxPrice;
    
    NSString* moneyStr = [NSString stringWithFormat:@"%.0f", totalTaxPrice];
    NSMutableAttributedString* num = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"约%@元",moneyStr]];
    [num addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:198/255.0 green:35/255.0 blue:82/255.0 alpha:1] range:NSMakeRange(1, moneyStr.length)];
    self.resoldHouseResultFootView.lblPrice.attributedText = num;
    
    shareContent = [NSString stringWithFormat:@"总税金：%.0f元；契税：%.0f元，印花税：%.0f元，公证费(可选)：%.0f元，委托办理费用（可选）：%.0f元，买卖手续费：%.0f元。",totalTaxPrice,qishui,yinhuashuiTax.taxPrice,gongzhengshuiTax.taxPrice,weituoshuiTax.taxPrice,maimaishouxu];
}

#pragma mark -- UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierForAccountCell = @"ResoldHouseResultTableViewCell";
    
    ResoldHouseResultTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierForAccountCell];
    if (!cell)
    {
        cell =  [[[NSBundle mainBundle]loadNibNamed:identifierForAccountCell owner:self options:nil]lastObject];
    }
    
    Tax *tax = [dataSource objectAtIndex:indexPath.row];
    
    cell.colorView.backgroundColor = [UIColor colorWithHex:tax.taxColor];
    cell.titleLbl.text = tax.taxName;
    cell.priceLbl.text = [NSString stringWithFormat:@"%.0f",tax.taxPrice];
    return cell;
}

#pragma mark -- UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - private methods

- (void)setupNaviagionBar {
    self.navigationItem.titleView = self.titleLabel;
    [self addLeftBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:self.backButton]];
}

#pragma mark - UIButton actions

- (void)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)shareClick:(UIButton*)btn
{
    [MobClick event:@"loan_calculate_share"];
    ShareModel *shareModel = [ShareModel new];
    shareModel.shareTitle = @"汇客通";
    shareModel.shareContent = shareContent;
    shareModel.shareWebURL = @"";
    shareModel.shareImageURL =nil;
    shareModel.shareImage =[GlobalFunction imageWithView:self.view];
    ShareTemplate  *shareTemplate = [ShareTemplate new];
    [shareTemplate actionWithShare:self WithSinaModel:shareModel andMessageTypeIsImage:YES];
}
#pragma mark - getter/setter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 220, 44)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"计算结果";
    }
    return _titleLabel;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_backButton setImage:[UIImage imageNamed:@"top_goback_left"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

-(ResoldHouseResultFootView *)resoldHouseResultFootView{
    if(!_resoldHouseResultFootView){
        _resoldHouseResultFootView = [[[NSBundle mainBundle]loadNibNamed:@"ResoldHouseResultFootView" owner:self options:nil]lastObject];
        _resoldHouseResultFootView.frame = CGRectMake(0, 0, 0, 130);
        
    }
    return _resoldHouseResultFootView;
}

-(NewHouseResultHeadView *)newHouseResultHeadView{
    if(!_newHouseResultHeadView){
        _newHouseResultHeadView = [[[NSBundle mainBundle]loadNibNamed:@"NewHouseResultHeadView" owner:self options:nil]lastObject];
        _newHouseResultHeadView.frame = CGRectMake(0, 0, 0, 200);
    }
    return _newHouseResultHeadView;
}

-(UIButton*)shareBtn
{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.frame = CGRectMake(0, 0, 44, 44);
        [_shareBtn setImage:[UIImage imageNamed:@"nav_btn_share"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
