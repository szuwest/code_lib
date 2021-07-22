//
//  UITextField+Separator.h
//  Future
//
//  Created by West on 2021/7/22.
//  Copyright © 2021 WeGene. All rights reserved.
// 分隔符支持任意长度，字符串中可含有分隔符且无影响
// https://github.com/CodeWicky/-Tools/blob/1b1350ac7ad9e9ba60743a0216ec07f37eee05c3/DWTextFieldUtils/UITextField%2BDWTextFieldUtils.h
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (Separator)

///分割长度数组
/**
 形如
 @[@3,@4,@4]
 则以3、4、4形式分隔，且限制长度3+4+4为11
 */
@property (nonatomic ,strong) NSArray<NSNumber *> * componentsLength;

///分隔符
/**
 默认为空格
 */
@property (nonatomic ,copy) NSString * componentsSeparator;

///剔除分隔符的绝对字符串
@property (nonatomic ,strong ,readonly) NSString * absoluteString;

///若需要限制长度并分割，请在需要限制的条件下在shouldChange代理中返回此方法
/**
 形如
 -(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
 {
 return [textField dw_ShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string];
 }
 */
-(BOOL)dw_ShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

- (NSInteger)cursorPosition;
- (void)setCursorPosition:(NSInteger)position;

@end

NS_ASSUME_NONNULL_END
