//
//  ACSpecialCategoryView.m
//  ArtCMP
//
//  Created by smartrookie on 16/7/20.
//  Copyright © 2016年 Art. All rights reserved.
//

#import "ACSpecialCategoryView.h"
#import "ACScrollingLabel.h"

@interface ACSpecialCategoryView ()

@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) UILabel *currentChosenLabel;
@property (strong, nonatomic) categoryViewTapBlock tapBlock;
@property (strong, nonatomic) NSMutableArray *LabelsArray;
@property (strong, nonatomic) UIView *scrollingBlock;
@property (strong, nonatomic) NSAttributedString *stringForMeasureWordLength;
@end

@implementation ACSpecialCategoryView

-(instancetype)initWithContents:(NSArray *)array
{
    self = [super init];
    
    if (self) {
        
        self.dataSource = array;
        self.LabelsArray = [NSMutableArray arrayWithCapacity:array.count];
        [self setupView];
        [self initContentView];
    }
    
    return self;
}

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        [self setupView];
    }
    
    return self;
}

- (void)setupView
{
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
}

- (void)initContentView
{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    //选项
    [self.dataSource enumerateObjectsUsingBlock:^(NSString *  _Nonnull categoryName, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ACScrollingLabel *label = [[ACScrollingLabel alloc] init];
        
        label.text = categoryName;
        
        [self addSubview:label];
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.font = [UIFont systemFontOfSize:15];
        
        label.userInteractionEnabled = YES;
        
        label.frame = CGRectMake(idx * 80, 7, 80, 30);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        
        [label addGestureRecognizer:tap];
        
        [self.LabelsArray addObject:label];
        
    }];
    
    //滑块
    self.scrollingBlock = [[UIView alloc] init];
    
    self.scrollingBlock.backgroundColor = [UIColor blackColor];
    
    [self addSubview:self.scrollingBlock];
    
    //初始化滑块位置
    [self scrollingBlockSrollToIndex:0];
    
    //默认选择第一项
    [self scrollToIdx:0];
    //设置scrollview内容大小
    self.contentSize = CGSizeMake(self.dataSource.count * 80, 44);

}

-(void)updateContent:(NSArray *)array
{
    self.dataSource = array;
    self.LabelsArray = [NSMutableArray arrayWithCapacity:array.count];
    [self initContentView];
    [self setNeedsDisplay];
}

-(void)tap:(UIGestureRecognizer *)rec
{
    if ([rec.view isEqual:self.currentChosenLabel]) {
        return;
    }
    
    [self labelAnimation:[self.LabelsArray indexOfObject:rec.view]];

    if (self.tapBlock) {
        UILabel *label = (UILabel *)rec.view;
        self.tapBlock([self.LabelsArray indexOfObject:label]);
    };
}

-(void)whenTapped:(categoryViewTapBlock)tapBlock
{
    self.tapBlock = tapBlock;
}

- (void)scrollingBlockSrollToIndex:(NSInteger)index
{
    if (self.LabelsArray.count < 1) {
        return;
    }
    ACScrollingLabel *label = self.LabelsArray[index];
    [UIView animateWithDuration:0.2 animations:^{
        self.scrollingBlock.frame = CGRectMake(label.frame.origin.x + (label.frame.size.width / 2 -label.width/2), 44 - 2, label.width, 2);
    }];
}

-(BOOL)scrollToIdx:(NSInteger)index
{
    [self labelAnimation:index];
    
    [self scrollingBlockSrollToIndex:index];
    
    return YES;
}

- (void)labelAnimation:(NSInteger)index
{
    if (self.LabelsArray.count < 1) {
        return;
    }
    
    [self makeScaleSmallAnimation:self.currentChosenLabel];
    
    UILabel *label = self.LabelsArray[index];
    
    CGFloat x = label.frame.origin.x - (kScreenWidth / 2 - label.frame.size.width / 2);
    
    [self scrollRectToVisible:CGRectMake(x, 0, kScreenWidth, 44) animated:YES];
    
    [self makeScaleBigAnimation:label];
    
    self.currentChosenLabel = (UILabel *)label;
}

-(void)animationWithProgress:(CGFloat)progress ToIndex:(NSInteger)index
{
    if (progress > 1) {
        [self scrollToIdx:index];
    }
    ACScrollingLabel *fromLabel = (ACScrollingLabel *)self.currentChosenLabel;
    CGFloat distance = self.contentSize.width;
    self.scrollingBlock.frame = CGRectMake(40 - fromLabel.width / 2 + progress *distance, 44 - 2, fromLabel.width, 2);
}

- (void)makeScaleBigAnimation:(UIView *)view
{
    CABasicAnimation * bigAni = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    bigAni.toValue = [NSNumber numberWithFloat:1.1];
    bigAni.duration = 0.3;
    bigAni.removedOnCompletion = NO;
    bigAni.fillMode = kCAFillModeForwards;
    
    [view.layer addAnimation:bigAni forKey:@"makeScaleBigAnimation"];
    
    [UIView animateWithDuration:0.3 animations:^{
        UILabel *label = (UILabel *)view;
        label.textColor = [UIColor redColor];
    }];
    
}

- (void)makeScaleSmallAnimation:(UIView *)view
{
    CABasicAnimation * smallAni = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    smallAni.toValue = [NSNumber numberWithFloat:1.0];
    smallAni.duration = 0.3;
    smallAni.removedOnCompletion = NO;
    smallAni.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:smallAni forKey:@"makeScaleSmallAnimation"];
    [UIView animateWithDuration:0.3 animations:^{
        UILabel *label = (UILabel *)view;
        label.textColor = [UIColor blackColor];
    }];
}
@end
