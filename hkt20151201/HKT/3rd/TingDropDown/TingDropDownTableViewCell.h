//
//  TingDropDownTableViewCell.h
//  FSDropDownMenu
//
//  Created by Ting on 15/11/19.
//  Copyright © 2015年 chx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TingDropDownTableViewCell : UITableViewCell

@property (nonatomic,weak)IBOutlet UILabel *titleLbl;

-(void)setSelectedSytle:(BOOL)selected;

@end
