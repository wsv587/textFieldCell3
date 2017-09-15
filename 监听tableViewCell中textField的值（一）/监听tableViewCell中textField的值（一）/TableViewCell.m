//
//  TableViewCell.m
//  监听tableViewCell中textField的值（一）
//
//  Created by wangsong on 16/5/3.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "TableViewCell.h"
#import "CustomTextField.h"

@interface TableViewCell ()<UITextFieldDelegate>


@end


@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentTextField.delegate = self;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSDictionary *userInfo = @{
                               @"textFieldText":self.contentTextField.text
                               };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CustomTextFieldDidEndEditingNotification" object:self.contentTextField userInfo:userInfo];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.contentTextField becomeFirstResponder];
}

@end
