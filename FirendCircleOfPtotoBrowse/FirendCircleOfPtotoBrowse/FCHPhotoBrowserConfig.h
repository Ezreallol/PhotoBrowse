//
//  FCHPhotoBrowserConfig.h
//  FirendCircleOfPtotoBrowse
//
//  Created by Acon on 16/12/23.
//  Copyright © 2016年 FCH. All rights reserved.
//

#ifndef FCHPhotoBrowserConfig_h
#define FCHPhotoBrowserConfig_h

typedef enum {
    FCHWaitingViewModeLoopDiagram, // 环形
    FCHWaitingViewModePieDiagram // 饼型
} FCHWaitingViewMode;

// 图片保存成功提示文字
#define FCHPhotoBrowserSaveImageSuccessText @" ^_^ 保存成功 ";

// 图片保存失败提示文字
#define FCHPhotoBrowserSaveImageFailText @" >_< 保存失败 ";

// browser背景颜色
#define FCHPhotoBrowserBackgrounColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.95]

// browser中图片间的margin
#define FCHPhotoBrowserImageViewMargin 10

// browser中显示图片动画时长
#define FCHPhotoBrowserShowImageAnimationDuration 0.4f

// browser中显示图片动画时长
#define FCHPhotoBrowserHideImageAnimationDuration 0.4f

// 图片下载进度指示进度显示样式（FCHWaitingViewModeLoopDiagram 环形，FCHWaitingViewModePieDiagram 饼型）
#define FCHWaitingViewProgressMode FCHWaitingViewModeLoopDiagram

// 图片下载进度指示器背景色
#define FCHWaitingViewBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]

// 图片下载进度指示器内部控件间的间距
#define FCHWaitingViewItemMargin 10
#endif /* FCHPhotoBrowserConfig_h */
