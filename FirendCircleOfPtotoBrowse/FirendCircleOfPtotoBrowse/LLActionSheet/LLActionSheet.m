//
//  LLActionSheet.m
//  LLActionSheet
//
//  Created by 雷亮 on 16/9/1.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "LLActionSheet.h"
#import "UIView+Frame.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define LLScale(x) ((kScreenWidth / 320.0) * x)

#ifndef LLRelease_UIView
#define LLRelease_UIView(__ref) \
\
{ \
    if ((__ref) != nil) { \
        [__ref removeFromSuperview]; \
        __ref = nil; \
    } \
}
#endif

#define HEXCOLOR(hexValue)              [UIColor colorWithRed : ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0 green : ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0 blue : ((CGFloat)(hexValue & 0xFF)) / 255.0 alpha : 1.0]

#define HEXACOLOR(hexValue, alphaValue) [UIColor colorWithRed : ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0 green : ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0 blue : ((CGFloat)(hexValue & 0xFF)) / 255.0 alpha : (alphaValue)]

#define Format(...) [NSString stringWithFormat:__VA_ARGS__]

#define kCellHeight LLScale(45.f)

static CGFloat const kLabelTag = 10000;

@interface LLActionSheet () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UIWindow *window;
@property (nonatomic, copy) NSArray <NSString *>*messageArray;
@property (nonatomic, copy) NSString *cancel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat tableViewHeight;
@property (nonatomic, copy) LLActionSheetBlock clickBlock;
@property (nonatomic, copy) LLActionSheetCancelBlock cancelBlock;

@end

@implementation LLActionSheet

- (instancetype)initWithMessageArray:(NSArray <NSString *>*)messageArray cancel:(NSString *)cancel clickBlock:(LLActionSheetBlock)clickBlock cancelBlock:(LLActionSheetCancelBlock)cancelBlock {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.window = [[UIApplication sharedApplication] keyWindow];
        self.messageArray = messageArray;
        self.cancel = cancel;
        self.clickBlock = clickBlock;
        self.cancelBlock = cancelBlock;
        
        [self buildingUI];
    }
    return self;
}

- (instancetype)initWithMessageArray:(NSArray <NSString *>*)messageArray clickBlock:(LLActionSheetBlock)clickBlock {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.window = [[UIApplication sharedApplication] keyWindow];
        self.messageArray = messageArray;
        self.cancel = @"";
        self.clickBlock = clickBlock;
        self.cancelBlock = nil;
        
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.f;
    
    // 计算tableView高度
    CGFloat messagesHeight = self.messageArray.count * kCellHeight;
    CGFloat spacingHeight = 0;
    CGFloat cancelHeight = 0;
    
    if (self.cancel.length > 0) {
        spacingHeight = LLScale(5);
        cancelHeight = self.cancel.length > 0 ? kCellHeight : 0;
    }
    self.tableViewHeight = messagesHeight + spacingHeight + cancelHeight;
    
    // tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, self.tableViewHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    
    // 点击dismiss
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction:)];
    [self addGestureRecognizer:tap];
}

- (void)showList {
    [self.window addSubview:self];
    [self.window addSubview:self.tableView];
    
    self.hidden = NO;
    _tableView.hidden = NO;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0.5f;
        self.tableView.fch_y = kScreenHeight - self.tableViewHeight;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0.f;
        self.tableView.fch_y = kScreenHeight;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.tableView.hidden = YES;
        [self _release];
    }];
}

- (void)_release {
    [self removeFromSuperview];
    LLRelease_UIView(_tableView);
    _clickBlock = nil;
    _cancelBlock = nil;
}

- (void)dealloc {
//    NSLog(@"%@", self);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark -
#pragma mark - tableView Delegate && Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.cancel.length > 0) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.messageArray.count;
    }
    return (self.cancel.length > 0 ? 1 : 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return (self.cancel.length > 0 ? 10 : 0);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = HEXACOLOR(0xeeeeef, 0.95);
    if (section == 0) {
        return headerView;
    } else if (section == 1) {
        headerView.frame = CGRectMake(0, 0, kScreenWidth, (self.cancel.length > 0 ? 10 : 0));
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reUse = Format(@"reUse");
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reUse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reUse];
        cell.backgroundColor = HEXACOLOR(0xffffff, 0.95);

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kCellHeight)];
        label.font = [UIFont systemFontOfSize:LLScale(14)];
        label.textColor = HEXCOLOR(0x000000);
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 1;
        label.tag = kLabelTag;
        [cell addSubview:label];
    }
    UILabel *label = [cell viewWithTag:kLabelTag];
    if (indexPath.section == 0) {
        label.text = self.messageArray[indexPath.row];
    } else if (indexPath.section == 1) {
        label.text = self.cancel;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (self.clickBlock) {
            self.clickBlock(indexPath.row, self.messageArray[indexPath.row]);
        }
    } else {
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    }
    // dismiss
    [self dismiss];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //最后一行分隔线顶头显示
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)handleTapAction:(UITapGestureRecognizer *)tap {
    [self dismiss];
}

@end
