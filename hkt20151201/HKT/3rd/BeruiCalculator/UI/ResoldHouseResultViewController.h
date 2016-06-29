//
//  ResoldHouseResultViewController.h
//  HKT
//
//  Created by iOS2 on 15/11/6.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, HouseType) {
    resoldNormalHousing               = 0,          //普通住宅
    resoldNotNormalHousing            = 1,          //非普通住宅
    resoldAffordableHousing           = 2,          //经济适用房
};

typedef NS_ENUM(NSInteger, TimeType) {
    lessTwoYears                    = 0,            //不满两年....
    twoYearsToFiveYears             = 1,            //两到五年
    moreFiveYears                   = 2,            //五年以上
};

@interface ResoldHouseResultModel : NSObject

@property (nonatomic,assign)BOOL isSellOnlyHouse;       //卖家唯一住房
@property (nonatomic,assign)TimeType time;              //购买期限
@property (nonatomic,assign)BOOL isFirstBuy;            //买家唯一住房
@property (nonatomic,assign)HouseType houseType;        //房屋类型
@property (nonatomic,assign)float houseArea;            //房屋面积
@property (nonatomic,assign)float houseUnitPrice;       //房屋单价
@property (nonatomic,assign)float originalPrice;        //房屋原价(如果没填,则不传)

@end


@interface ResoldHouseResultViewController : BaseViewController

-(instancetype)initWithResoldHouseResultModel:(ResoldHouseResultModel *)resoldHouseResultModel;

@end
