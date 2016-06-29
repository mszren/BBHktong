//
//  NewHouseResultViewController.h
//  HKT
//
//  Created by iOS2 on 15/11/10.
//  Copyright © 2015年 百瑞. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, NewHouseType) {
    normalHousing               = 0,        //普通住宅
    notNormalHousing            = 1,        //非普通住宅

};

@interface NewHouseResultModel : NSObject

@property (nonatomic,assign)NewHouseType houseType;     //房屋类型
@property (nonatomic,assign)BOOL isOnlyHouse;           //唯一住房
@property (nonatomic,assign)float houseArea;            //房屋面积
@property (nonatomic,assign)float houseUnitPrice;       //房屋单价

@end


@interface NewHouseResultViewController : BaseViewController

-(instancetype)initWithNewHouseResultModel:(NewHouseResultModel *)newHouseResultModel;

@end
