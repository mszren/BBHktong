//
//  ResoldHouseResultViewController.m
//  HKT
//
//  Created by iOS2 on 15/11/6.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "ResoldHouseResultViewController.h"
#import "ResoldHouseResultTableViewCell.h"
#import "ResoldHouseResultFootView.h"
#import "Tax.h"
#import "ResoldHouseResultHeadView.h"
#import "ShareTemplate.h"

@implementation ResoldHouseResultModel

@end

@interface ResoldHouseResultViewController (){
    
    ResoldHouseResultModel *resoldHouseResult;
    NSArray *dataSource;
    float qishui;
    float yinyeshui;
    float gerensuodeshui;
    float yinhuashui;
    float totalTaxPrice ;
    float gongben ;
}

//基础
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIButton *backButton;
@property(strong,nonatomic)UIButton* shareBtn;

@property (nonatomic, retain) ResoldHouseResultFootView *resoldHouseResultFootView;
@property (nonatomic, retain) ResoldHouseResultHeadView *resoldHouseResultHeadView;
@property (nonatomic, weak) IBOutlet UITableView *myTableView;

@end

@implementation ResoldHouseResultViewController


-(instancetype)initWithResoldHouseResultModel:(ResoldHouseResultModel *)resoldHouseResultModel{
    self = [super init];
    if(self){
        resoldHouseResult = resoldHouseResultModel;
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
    _myTableView.tableHeaderView = self.resoldHouseResultHeadView;
    
}

-(void)readyDataSource{
    
    float CPrice = resoldHouseResult.houseArea * resoldHouseResult.houseUnitPrice;
    
    //契税
//    float qishui = 0.00;
    //买方缴纳
    //家庭首次购买唯一住房90㎡以下1%；90㎡-139㎡1.5%；140㎡以上3%。
    //购买非家庭唯一住房 3%
    
    //家庭首套
    if([resoldHouseResult isFirstBuy]){
        if(resoldHouseResult.houseArea < 89.00){
            qishui = CPrice*0.01;
        }else if(resoldHouseResult.houseArea >= 90.00 && resoldHouseResult.houseArea < 144.00){
            qishui = CPrice *0.02;
        }else{
            qishui = CPrice *0.04;
        }
        //非首套
    }else
    {
        qishui = CPrice *0.04;
    }
    
    if(resoldHouseResult.houseType == resoldNotNormalHousing){
        qishui = CPrice *0.04;
    }
    
    Tax *qishuiTax = [Tax new];
    qishuiTax.taxName = @"契税:";
    qishuiTax.taxPrice = qishui;
    qishuiTax.taxColor = 0xc36860;
    
    //营业税
//    float yinyeshui = 0.00;
    
    //非普宅（总价）*5.56%
    
    //普宅<2年5.56%  普宅>=2年免征
    if (resoldHouseResult.houseType == resoldNormalHousing){
        if(resoldHouseResult.time == lessTwoYears){
            yinyeshui = CPrice *0.0556;
        }else{
            yinyeshui = 0.00;
        }
    }
    
    //非普宅（总价）*5.56%
    else if(resoldHouseResult.houseType == resoldNotNormalHousing){
        yinyeshui = CPrice * 0.0556;
        
    }
    
    Tax *yinyeshuiTax = [Tax new];
    yinyeshuiTax.taxName = @"营业税:";
    yinyeshuiTax.taxPrice = yinyeshui;
    yinyeshuiTax.taxColor = 0x11a1d9;
    
    
    //个人所得税
//    float gerensuodeshui = 0.00;
    //卖方缴纳
    //出售满5年以上并且是家庭唯一住房，免征。
    //出售未满5年住房或满5年非唯一住宅，核定征收税率暂按1%或差额20%执行。
    if(resoldHouseResult.time == moreFiveYears && resoldHouseResult.isSellOnlyHouse){
        gerensuodeshui = 0.00;
    }else {
        //填入了原价,说明算差价
        if(resoldHouseResult.originalPrice>0){
            if(CPrice <= resoldHouseResult.originalPrice){
                gerensuodeshui = 0.00;
            }else{
                gerensuodeshui = (CPrice - resoldHouseResult.originalPrice )* 0.2;
            }
            
        }else{
            
            gerensuodeshui = CPrice * 0.01;
        }
    }
    
    Tax *gerensuodeshuiTax = [Tax new];
    gerensuodeshuiTax.taxName = @"个人所得税:";
    gerensuodeshuiTax.taxPrice = gerensuodeshui;
    gerensuodeshuiTax.taxColor = 0x4e9188;
    
    //印花税  目前免征
//    float yinhuashui = 0.00;
    
    Tax *yinhuashuiTax = [Tax new];
    yinhuashuiTax.taxName = @"印花税:";
    yinhuashuiTax.taxPrice = yinhuashui;
    yinhuashuiTax.taxColor = 0xf2d03b;
    
    //工本印花税
//    float gongben = 5.00;
    
    Tax *gongbenTax = [Tax new];
    gongbenTax.taxName = @"工本印花税:";
    gongbenTax.taxPrice = gongben;
    gongbenTax.taxColor = 0x537b9b;
    
    //综合地价款
    float zonghedijiakuan = 0.00;
    if(resoldHouseResult.houseType == resoldAffordableHousing){
        zonghedijiakuan = CPrice * 0.1;
    }
    
    Tax *zonghedijiakuanTax = [Tax new];
    zonghedijiakuanTax.taxName = @"综合地价款:";
    zonghedijiakuanTax.taxPrice = zonghedijiakuan;
    zonghedijiakuanTax.taxColor = 0xeb7bb6;
    
    dataSource = @[
                   @{@"卖方缴纳":@[yinyeshuiTax,gerensuodeshuiTax]},
                   
                   @{@"买方缴纳":@[qishuiTax,yinhuashuiTax,gongbenTax,zonghedijiakuanTax]},
                   
                   ];
    
    [self.resoldHouseResultHeadView setDataSource:dataSource];
    
    
    totalTaxPrice = qishui + yinhuashui + gerensuodeshui + yinyeshui + gongben + zonghedijiakuan;
    
    NSString* moneyStr = [NSString stringWithFormat:@"%.0f", totalTaxPrice];
    NSMutableAttributedString* num = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"约%@元",moneyStr]];
    [num addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:198/255.0 green:35/255.0 blue:82/255.0 alpha:1] range:NSMakeRange(1, moneyStr.length)];
    self.resoldHouseResultFootView.lblPrice.attributedText = num;
    
}

#pragma mark -- UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *sectionDic = [dataSource objectAtIndex:section];
    NSArray *sectionArray = [sectionDic.allValues firstObject];
    return sectionArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 24.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSDictionary *sectionDic = [dataSource objectAtIndex:section];
    
    UIView *sectionHead = [UIView new];
    sectionHead.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kDeviceWidth, 25)];
    lblTitle.font = [UIFont systemFontOfSize:15.0f];
    lblTitle.textColor = [UIColor colorWithHex:0x333333];
    lblTitle.text = [[sectionDic allKeys]firstObject];
    
    [sectionHead addSubview:lblTitle];
    return sectionHead;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierForAccountCell = @"ResoldHouseResultTableViewCell";
    
    ResoldHouseResultTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierForAccountCell];
    if (!cell)
    {
        cell =  [[[NSBundle mainBundle]loadNibNamed:identifierForAccountCell owner:self options:nil]lastObject];
    }
    
    NSDictionary *sectionDic = [dataSource objectAtIndex:indexPath.section];
    NSArray *sectionArray = [sectionDic.allValues firstObject];
    Tax *tax = [sectionArray objectAtIndex:indexPath.row];
    
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
    shareModel.shareContent = [NSString stringWithFormat:@"总税金：%.0f元；卖方缴纳（营业税：%.0f元，个人所得税：%.0f元）；买方缴纳（契税：%.0f元，工本印花税：%.0f元",totalTaxPrice,yinyeshui,gerensuodeshui,qishui,gongben];
    shareModel.shareImageURL =nil;
    shareModel.shareWebURL = @"";
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

-(ResoldHouseResultHeadView *)resoldHouseResultHeadView{
    if(!_resoldHouseResultHeadView){
        _resoldHouseResultHeadView = [[[NSBundle mainBundle]loadNibNamed:@"ResoldHouseResultHeadView" owner:self options:nil]lastObject];
        _resoldHouseResultHeadView.frame = CGRectMake(0, 0, 0, 140);
        
    }
    return _resoldHouseResultHeadView;
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
