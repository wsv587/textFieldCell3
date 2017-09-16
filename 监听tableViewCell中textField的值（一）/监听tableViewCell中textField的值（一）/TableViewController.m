//
//  TableViewController.m
//  监听tableViewCell中textField的值（一）
//
//  Created by wangsong on 16/5/3.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"
#import "CustomTextField.h"

@interface TableViewController ()
/**
 *  标题
 */
@property(nonatomic, strong) NSArray *titles;
/**
 *  占位文字
 */
@property(nonatomic, strong) NSArray *placeHolders;
/**
 *  数据源
 */
@property(nonatomic,strong) NSMutableArray *contents;

@end

@implementation TableViewController
    static NSString * const ID = @"textFieldCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TableViewCell class]) bundle:nil] forCellReuseIdentifier:ID];
}

// 如果不能保证控制器的dealloc方法肯定会被调用，不要在viewDidLoad方法中注册通知。
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.rowHeight = 160;
    // 注册通知
    // 注意：此处监听的通知是：UITextFieldTextDidEndEditingNotification，textField结束编辑发送的通知，textField结束编辑时才会发送这个通知。
    // 想实时监听textField的内容的变化，你也可以注册这个通知：UITextFieldTextDidChangeNotification，textField值改变就会发送的通知。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellTextFieldDidEndEditing:) name:@"CustomTextFieldDidEndEditingNotification" object:nil];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contentTextFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 在这个方法里移除通知，因为：
    // 防止控制器被强引用导致-dealloc方法没有调用
    // 其他界面也有textField，其他界面的textField也会发送同样的通知，导致频繁的调用监听到通知的方法，而这些通知是这个界面不需要的，所以在视图将要消失的时候移除通知 同样，在视图将要显示的时候注册通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CustomTextFieldDidEndEditingNotification" object:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.contentTextField.indexPath = indexPath;

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *customCell = (TableViewCell *)cell;
    customCell.titleLabel.text = self.titles[indexPath.row];
    customCell.contentTextField.placeholder = self.placeHolders[indexPath.row];
    if (indexPath.section == 0) {
        customCell.contentTextField.text = [self.contents objectAtIndex:indexPath.row];
        // 必须有else!
    } else {
        // 切记：对于cell的重用，有if，就必须有else。因为之前屏幕上出现的cell离开屏幕被缓存起来时候，cell上的内容并没有清空，当cell被重用时，系统并不会给我们把cell上之前配置的内容清空掉，所以我们在else中对contentTextField内容进行重新配置或者清空（根据自己的业务场景而定）
        customCell.contentTextField.text = [NSString stringWithFormat:@"第%ld组,第%ld行",indexPath.section,indexPath.row];
    }
    
}

#pragma mark - private method
// 接收到注册监听的通知后调用
- (void)cellTextFieldDidEndEditing:(NSNotification *)noti {
    CustomTextField *textField = noti.object;
    if (!textField.indexPath) {
        return;
    }
    
    NSString *userInfoValue = [noti.userInfo objectForKey:@"textFieldText"];
    NSLog(@"text:%@,userInfoValue:%@",textField.text,userInfoValue);
    // 如果涉及到多个section，可以使用二维数组，此处不再赘述
    if (textField.indexPath.section == 0) {
        [self.contents replaceObjectAtIndex:textField.indexPath.row withObject:userInfoValue];

    } else if (textField.indexPath.section == 1) {
        // 同上，请自行脑补
    } else if (textField.indexPath.section == 2) {
        // 同上，请自行脑补
    } else {
        // 同上，请自行脑补
    }
}

#pragma mark -Getter
- (NSArray *)titles
{
    if (!_titles) {
        _titles = @[@"姓名",@"年龄",@"地址",@"公司",@"性别",@"爱好",@"身高",@"体重"];
    }
    return _titles;
}

- (NSArray *)placeHolders
{
    if (!_placeHolders) {
        _placeHolders = @[@"请输入姓名",@"请输入年龄",@"请输入地址",@"请输入公司",@"请输入性别",@"请输入爱好",@"请输入身高",@"请输入体重"];
    }
    return _placeHolders;
}

- (NSMutableArray *)contents {
    if (!_contents) {
        _contents = [NSMutableArray arrayWithCapacity:self.titles.count];
        for (int i = 0; i < self.titles.count; i++) {
            [_contents addObject:@""];
        }
    }
    return _contents;
}

@end
