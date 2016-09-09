//
//  ACScrollingLabel.m
//  ArtCMP
//
//  Created by smartrookie on 16/7/22.
//  Copyright © 2016年 Art. All rights reserved.
//

#import "ACScrollingLabel.h"

@interface ACScrollingLabel ()
@property (strong, nonatomic) UITextView *measureTextView;
@end

@implementation ACScrollingLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(CGFloat)width
{
    if (!_width) {
        
        NSDictionary *dic = @{@"NSFontAttributeName":[UIFont systemFontOfSize:16]};
        NSAttributedString * stringForMeasureWordLength = [[NSAttributedString alloc] initWithString:self.text attributes:dic];
        CGSize size = [self measureTextViewAttributedString:stringForMeasureWordLength widthlimit:3000];
        _width = size.width += 8; //文字实际宽度 8 左右各偏移4点，好看一点
        
    }
    return 50;
}

-(CGSize)measureTextViewAttributedString:(NSAttributedString *)attrString widthlimit:(CGFloat)widthlimit
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.measureTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        self.measureTextView.showsVerticalScrollIndicator = NO;
        self.measureTextView.scrollEnabled = NO;
        self.measureTextView.editable = NO;
    });
    //ensure use safe in asynchronous thread
    @synchronized(self.measureTextView){
        self.measureTextView.frame = CGRectMake(0, 0, widthlimit, CGFLOAT_MAX);
        self.measureTextView.attributedText = attrString;
        [self.measureTextView.layoutManager ensureLayoutForTextContainer:self.measureTextView.textContainer];
        CGRect textBounds = [self.measureTextView.layoutManager usedRectForTextContainer:self.measureTextView.textContainer];
        CGFloat width =  (CGFloat)ceil(textBounds.size.width + self.measureTextView.textContainerInset.left + self.measureTextView.textContainerInset.right);
        CGFloat height = (CGFloat)ceil(textBounds.size.height + self.measureTextView.textContainerInset.top + self.measureTextView.textContainerInset.bottom);
        return CGSizeMake(width, height);
    }
}
@end
