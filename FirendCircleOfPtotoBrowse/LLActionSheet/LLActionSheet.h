//
//  LLActionSheet.h
//  LLActionSheet
//
//  Created by 雷亮 on 16/9/1.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LLActionSheetBlock)(NSInteger selectedIndex, NSString *message);
typedef void(^LLActionSheetCancelBlock)();

@interface LLActionSheet : UIView

- (instancetype)initWithMessageArray:(NSArray <NSString *>*)messageArray cancel:(NSString *)cancel clickBlock:(LLActionSheetBlock)clickBlock cancelBlock:(LLActionSheetCancelBlock)cancelBlock;

- (instancetype)initWithMessageArray:(NSArray <NSString *>*)messageArray clickBlock:(LLActionSheetBlock)clickBlock;

- (void)show;

- (void)dismiss;

@end
