//
//  ResoldHouseResultHeadView.m
//  HKT
//
//  Created by Ting on 15/11/9.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "NewHouseResultHeadView.h"
#import "XYPieChart.h"
#import "Tax.h"


@interface NewHouseResultHeadView ()<XYPieChartDelegate, XYPieChartDataSource>{
    
}

@property (nonatomic,weak) IBOutlet XYPieChart *buyerPieChart;
@property (nonatomic,weak) IBOutlet UILabel *lblBuyer;



@property (nonatomic,retain) NSArray *buyerData;

@end

@implementation NewHouseResultHeadView


-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.buyerPieChart setDelegate:self];
    [self.buyerPieChart setDataSource:self];
    [self.buyerPieChart setStartPieAngle:M_PI_2];
    [self.buyerPieChart setAnimationSpeed:1.0];
    [self.buyerPieChart setUserInteractionEnabled:NO];
    
    _lblBuyer.layer.cornerRadius = 50.0f;
    _lblBuyer.clipsToBounds = YES;
}

-(void)setDataSource:(NSArray *)array{
    _buyerData = array;
    [self.buyerPieChart reloadData];
}


#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return [_buyerData count];
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    Tax *tax = [_buyerData objectAtIndex:index];
    return  tax.taxPrice;
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    Tax *tax = [_buyerData objectAtIndex:index];
    return  [UIColor colorWithHex:tax.taxColor];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will select slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will deselect slice at index %lu",(unsigned long)index);
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

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
