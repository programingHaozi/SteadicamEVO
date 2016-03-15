//
//  TFTextField.m
//  TFUILib
//
//  Created by xiayiyong on 16/1/12.
//  Copyright © 2016年 上海赛可电子商务有限公司. All rights reserved.
//

#import "TFTextField.h"
#import <TFBaseLib_iOS/TFBaseUtil+Valid.h>

@interface TFTextField() <UITextFieldDelegate>

@end

@implementation TFTextField

- (instancetype)initWithFrame:(CGRect)frame
                         text:(NSString *)text
                  placeholder:(NSString *)placeholder
{
    if (self = [super initWithFrame:frame])
    {
        self.text = text;
        self.placeholder = placeholder;
    }
    
    return self;
}

#pragma mark - setter -

- (void)setLeftMargin:(NSNumber *)leftMargin
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, leftMargin.floatValue, CGRectGetHeight(self.bounds))];
    leftView.alpha = 0.0;
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    _leftMargin = leftMargin;
}

- (void)setBottomBorderColor:(UIColor *)underlineColor
{
    _bottomBorderColor = underlineColor;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    // Draw underline if need
    if (self.bottomBorderColor != nil) {
        CGFloat r, g, b, a;
        [self.bottomBorderColor getRed:&r green:&g blue:&b alpha:&a];
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(ctx, 1.0);
        CGContextSetRGBStrokeColor(ctx, r, g, b, a);
        CGContextMoveToPoint(ctx, 0, rect.size.height - 1);
        CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height - 1);
        CGContextStrokePath(ctx);
    }
}

#pragma mark - UITextFieldDelegate -

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //得到输入框的内容
    if (textField.text.length > toBeString.length) {
        return YES;
    }
    
    if (self.maxLength > 0 && toBeString.length > self.maxLength) {
        return NO;
    }
    
    if (self.inputType == TFTextfieldInputTypeLettersAndNumbersOnly)
    {
        //判断只能输入英文和汉字
        
        if(!tf_isValidNickname(string))
        {
            return NO;
        }
    }
    else if (self.inputType == TFTextfieldInputTypeAllCharacters)
    {
        textField.text = [NSString stringWithFormat:@"%@", [toBeString uppercaseString]];
        self.text = textField.text;
        if (textField.text.length > 1) {
            UITextRange *textRange = [[UITextRange alloc] init];
            UITextPosition* selectionStart = [UITextPosition new];
            selectionStart = [textField positionFromPosition:[textField beginningOfDocument] offset:range.location+1];
            UITextPosition* selectionEnd = selectionStart;
            textRange = [textField textRangeFromPosition:selectionStart toPosition:selectionEnd];
            textField.selectedTextRange = textRange;
        }
        return NO;
    }
    else if (self.inputType == TFTextfieldInputTypeAllCharactersAndNoPunctuation)
    {
        //判断只能输入英文和汉字
        if(!tf_isValidNickname(string))
        {
            return NO;
        }
        textField.text = [NSString stringWithFormat:@"%@", [toBeString uppercaseString]];
        self.text = textField.text;
        if (textField.text.length > 1)
        {
            UITextRange *textRange = [[UITextRange alloc] init];
            UITextPosition* selectionStart = [UITextPosition new];
            selectionStart = [textField positionFromPosition:[textField beginningOfDocument] offset:range.location+1];
            UITextPosition* selectionEnd = selectionStart;
            textRange = [textField textRangeFromPosition:selectionStart toPosition:selectionEnd];
            textField.selectedTextRange = textRange;
        }
        return NO;
    }
    return YES;
}

@end
