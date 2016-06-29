//
//  ResoldHouseResultHeadView.m
//  HKT
//
//  Created by Ting on 15/11/9.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "ResoldHouseResultHeadView.h"
#import "XYPieChart.h"
#import "Tax.h"


@interface ResoldHouseResultHeadView ()<XYPieChartDelegate, XYPieChartDataSource>{
    
}

@property (nonatomic,weak) IBOutlet XYPieChart *buyerPieChart;
@property (nonatomic,weak) IBOutlet XYPieChart *sellerPieChart;

@property (nonatomic,weak) IBOutlet UILabel *lblBuyer;
@property (nonatomic,weak) IBOutlet UILabel *lblSeller;

@property (nonatomic,retain) NSArray *buyerData;
@property (nonatomic,retain) NSArray *sellerData;
@end

@implementation ResoldHouseResultHeadView


-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.buyerPieChart setDelegate:self];
    [self.buyerPieChart setDataSource:self];
    [self.buyerPieChart setStartPieAngle:M_PI_2];
    [self.buyerPieChart setAnimationSpeed:1.0];
    
    [self.sellerPieChart setDelegate:self];
    [self.sellerPieChart setDataSource:self];
    [self.sellerPieChart setStartPieAngle:M_PI_2];
    [self.sellerPieChart setAnimationSpeed:1.0];

    [self.buyerPieChart setUserInteractionEnabled:NO];
    
    [self.sellerPieChart setUserInteractionEnabled:NO];
    
    _lblBuyer.layer.cornerRadius = 40.0f;
    _lblBuyer.clipsToBounds = YES;
    _lblSeller.layer.cornerRadius = 40.0f;
    _lblSeller.clipsToBounds = YES;
}

-(void)setDataSource:(NSArray *)array{
    
    NSDictionary *sellerDic = [array firstObject];
    _sellerData = [[sellerDic allValues]firstObject];
    
    NSDictionary *buyerDic = [array lastObject];
    _buyerData = [[buyerDic allValues]firstObject];
    
    [self.buyerPieChart reloadData];
    [self.sellerPieChart reloadData];
}


#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    if(pieChart == _buyerPieChart){
        return [_buyerData count];
    }else {
        return [_sellerData count];
    }
    
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    if(pieChart == _buyerPieChart){
        
        Tax *tax = [_buyerData objectAtIndex:index];
        return  tax.taxPrice;
        
    }else {
        Tax *tax = [_sellerData objectAtIndex:index];
        return  tax.taxPrice;
    }
    
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    if(pieChart == _buyerPieChart){
        
        Tax *tax = [_buyerData objectAtIndex:index];
        return  [UIColor colorWithHex:tax.taxColor];
        
    }else {
        Tax *tax = [_sellerData objectAtIndex:index];
        return  [UIColor colorWithHex:tax.taxColor];
    }
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will select slice at index %lu",(unsigned long)index);
}

- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will deselect slice at index %lu",index);
}

- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did deselect slice at index %lu",(unsigned long)index);
}

- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %lu",(unsigned long)index);
    // self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[self.slices objectAtIndex:index]];
}

@end
