//
//  ACScrollingLabel.m
//  ArtCMP
//
//  Created by smartrookie on 16/7/22.
//  Copyright © 2016年 Art. All rights reserved.
//

#import "ACScrollingLabel.h"

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
        CGSize size = [[ACGlobal sharedInstance] measureTextViewAttributedString:stringForMeasureWordLength widthlimit:3000];
        _width = size.width += 8; //文字实际宽度 8 左右各偏移4点，好看一点
        
    }
    return _width;
}
@end
