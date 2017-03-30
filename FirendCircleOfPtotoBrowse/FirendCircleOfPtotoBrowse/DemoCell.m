//
//  DemoCell.m
//  FirendCircleOfPtotoBrowse
//
//  Created by Acon on 16/12/22.
//  Copyright © 2016年 FCH. All rights reserved.
//

#import "DemoCell.h"

@implementation DemoCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpView];
    }
    return self;
}


-(void)setUpView
{
    FCHPhotoGroup *photoGroup = [FCHPhotoGroup new];
    [self.contentView addSubview:photoGroup];
    self.photoGroup = photoGroup;
    
    
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    self.photoGroup.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);

}

@end
