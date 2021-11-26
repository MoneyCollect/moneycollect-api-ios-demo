//
//  MCProductCell.m
//  Example
//
//  Created by 邓侃 on 2021/11/3.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import "MCProductCell.h"
#import <MoneyCollect/MoneyCollect.h>
#import "MCConfigurationFile.h"
#import "MCProductDetailsModel.h"

/** cell 的高度 */
#define cellHeight   AdaptedHeight(80)

@interface MCProductCell ()
/** 图标 */
@property (nonatomic,strong) UIImageView *iconImageV;
/** 名称 */
@property (nonatomic,strong) UILabel *nameLabel;
/** 价格 */
@property (nonatomic,strong) UILabel *priceLabel;
/** 数量 */
@property (nonatomic,strong) UIButton *button;

@end

@implementation MCProductCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        
        UIImage *image = [UIImage imageNamed:@"产品1"];
        
        CGFloat w = image.size.width * 0.625;
        CGFloat h = image.size.height * 0.625;
        
        // 图标
        _iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(AdaptedWidth(15), (cellHeight - h) * 0.5, w, h)];
        [self.contentView addSubview:_iconImageV];
        
        // 名称
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageV.right + AdaptedWidth(10), AdaptedHeight(10), AdaptedWidth(200), (cellHeight - AdaptedHeight(20)) * 0.5)];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = Font_Regular(15.0f);
        [self.contentView addSubview:_nameLabel];
        
        // 价格
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom, _nameLabel.width, _nameLabel.height)];
        _priceLabel.textColor = [UIColor blackColor];
        _priceLabel.font = Font_Bold(15.0f);
        [self.contentView addSubview:_priceLabel];
        
        CGFloat btnWidth = AdaptedWidth(35);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREEN_WIDTH - AdaptedWidth(15) - btnWidth, (cellHeight - btnWidth) * 0.5, btnWidth, btnWidth);
        [button setTitle:@"x1" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"底圆背景"] forState:UIControlStateNormal];
        [self.contentView addSubview:button];
        _button = button;
        
    }
    return self;
}

- (void)setModel:(MCProductDetailsModel *)model
{
    _model = model;
    
    _iconImageV.image = [UIImage imageNamed:model.icon];
    _nameLabel.text = model.name;
    
    NSString *currency = [MCConfigurationFile getCurrency];
    if ([currency isEqualToString:@"USD"]) {
        _priceLabel.text = [NSString stringWithFormat:@"$%@",model.price];
    }else if ([currency isEqualToString:@"KRW"]) {
        _priceLabel.text = [NSString stringWithFormat:@"₩%@",model.price];
    }else if ([currency isEqualToString:@"IQD"]) {
        _priceLabel.text = [NSString stringWithFormat:@"ID%@",model.price];
    }else {
        _priceLabel.text = [NSString stringWithFormat:@"JPY￥%@",model.price];
    }
    
    if (model.isSelected) {
        [_button setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    }else {
        [_button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
}

@end
