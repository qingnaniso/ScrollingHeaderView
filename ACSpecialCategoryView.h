//
//  ACSpecialCategoryView.h
//  ArtCMP
//
//  Created by smartrookie on 16/7/20.
//  Copyright © 2016年 Art. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^categoryViewTapBlock)(NSInteger index);

@interface ACSpecialCategoryView : UIScrollView

-(instancetype)initWithContents:(NSArray *)array;

- (void)whenTapped:( categoryViewTapBlock ) tapBlock;
- (BOOL)scrollToIdx:(NSInteger)index;
- (void)animationWithProgress:(CGFloat)progress ToIndex:(NSInteger)index;
- (void)updateContent:(NSArray *)array;

@end
