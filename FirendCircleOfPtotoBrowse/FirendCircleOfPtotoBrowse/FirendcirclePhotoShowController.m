//
//  FirendcirclePhotoShowController.m
//  FirendCircleOfPtotoBrowse
//
//  Created by Acon on 16/12/22.
//  Copyright © 2016年 FCH. All rights reserved.
//





#import "FirendcirclePhotoShowController.h"
#import "DemoCell.h"
#import "FCHPhotoItem.h"
@interface FirendcirclePhotoShowController ()
/** DataSource */
@property (nonatomic, strong) NSArray *srcStringArray;

@end

@implementation FirendcirclePhotoShowController





- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    
    self.tableView.rowHeight =300;
    
    self.title = @"图片浏览(fch)";

   _srcStringArray = @[@"http://ww2.sinaimg.cn/thumbnail/904c2a35jw1emu3ec7kf8j20c10epjsn.jpg",
                        @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
                        @"http://ww2.sinaimg.cn/thumbnail/67307b53jw1epqq3bmwr6j20c80axmy5.jpg",
                        @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
                        @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                     
                       
                       @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg"
                        ];

    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     static NSString * ID = @"photo";
    DemoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[DemoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    
    NSMutableArray *temp = [NSMutableArray array];
    [_srcStringArray enumerateObjectsUsingBlock:^(NSString *src, NSUInteger idx, BOOL *stop) {
        FCHPhotoItem *item = [[FCHPhotoItem alloc] init];
        item.thumbnail_pic = src;
        [temp addObject:item];
    }];
    
    cell.photoGroup.phototItemArray = [temp copy];
    
    return cell;

}




@end
