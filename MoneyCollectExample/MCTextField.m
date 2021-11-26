//
//  MCTextField.m
//  Example
//
//  Created by 邓侃 on 2021/11/10.
//  Copyright © 2021 AsiaBill. All rights reserved.
//

#import "MCTextField.h"
#import <MoneyCollect/MoneyCollect.h>


/** 占位符开始编辑的坐标 */
#define Placeholder_StartFrame      CGRectMake(AdaptedWidth(12.5), 0, self.frame.size.width - AdaptedWidth(12.5 + 12.5), AdaptedHeight(20))
/** 占位符结束编辑的坐标 */
#define Placeholder_EndFrame        CGRectMake(AdaptedWidth(12.5), 0, self.frame.size.width - AdaptedWidth(12.5 + 12.5), self.frame.size.height)

/** 输入框开始编辑的坐标 */
#define TextField_StartFrame         CGRectMake(AdaptedWidth(12.5), AdaptedHeight(20), self.frame.size.width - AdaptedWidth(12.5 + 12.5), AdaptedHeight(20))
/** 输入框结束编辑的坐标 */
#define TextField_EndFrame          CGRectMake(AdaptedWidth(12.5), 0, self.frame.size.width - AdaptedWidth(12.5 + 12.5), self.frame.size.height)



@interface MCTextField ()<UITextFieldDelegate>
/** 站位符 */
@property (nonatomic,strong) UILabel *placeholder;
/** 输入框 */
@property (nonatomic,strong) UITextField *textField;

@end

@implementation MCTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
     
        self.backgroundColor = [UIColor whiteColor];
        
        //占位标题
        UILabel *placeholder = [[UILabel alloc] init];
        placeholder.frame = Placeholder_EndFrame;
        placeholder.font = Font_Regular(13.0f);
        placeholder.textColor = [UIColor jk_colorWithHex:0x8F8F8F];
        [self addSubview:placeholder];
        _placeholder = placeholder;
        
        
        //输入框
        UITextField *textField = [[UITextField alloc] init];
        textField.frame = TextField_EndFrame;
        textField.delegate = self;
        textField.textColor = [UIColor jk_colorWithHex:0x333333];
        textField.font = Font_Bold(13.0f);
        
        textField.backgroundColor = [UIColor clearColor];
        //光标颜色
        textField.tintColor = [UIColor jk_colorWithHex:0x8F8F8F];
        
        // 添加输入框数据改变监听
        [textField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
        
        _textField = textField;
        
        [self addSubview:textField];
        
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(AdaptedWidth(8), AdaptedWidth(8))];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //    maskLayer.frame = self.bounds;
        maskLayer.lineWidth = 0.5;
    //    maskLayer.lineCap = kCALineCapSquare;
        maskLayer.strokeColor = [UIColor jk_colorWithHex:0xD8D8D8].CGColor;
        maskLayer.fillColor = [UIColor clearColor].CGColor;
        maskLayer.path = maskPath.CGPath;

        self.layer.mask = maskLayer;
        [self.layer addSublayer:maskLayer];
        
    }
    return self;
}


#pragma mark - UITextFieldDelegate
// 将要开始编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        weakSelf.placeholder.hidden = NO;
        
        //1.调整 Placeholder (占位符)的高度,文字大小
        weakSelf.placeholder.frame = Placeholder_StartFrame;
        weakSelf.placeholder.font = Font_Regular(11.0f);
        
        //调整 UITextField 的位置,高度
        weakSelf.textField.frame = TextField_StartFrame;
        
    }];
    
    return YES;
}

// 将要结束编辑
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        //有数据隐藏站位符号
        weakSelf.placeholder.hidden = textField.text.length;
        
        if (!textField.text.length) { // 没有数据
           
            //1.调整 Placeholder (占位符)的高度,文字大小
            weakSelf.placeholder.frame = Placeholder_EndFrame;
            weakSelf.placeholder.font = Font_Regular(13.0f);
            
        }
        
        //调整 UITextField 的位置,高度
        weakSelf.textField.frame = TextField_EndFrame;
        
    }];
    
    return YES;
}

- (void)textValueChanged:(UITextField *)textField
{
    _text = textField.text;
}

- (void)setPlaceholderStr:(NSString *)placeholderStr
{
    _placeholderStr = placeholderStr;
    
    _placeholder.text = placeholderStr;
}

- (void)setText:(NSString *)text
{
    _text = text;
    _textField.text = text;
    _placeholder.hidden = text.length;
}

@end
