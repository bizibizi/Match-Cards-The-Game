//
//  CardView.m
//  CardGameUpdated
//
//  Created by igorbizi@mail.ru on 4/15/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import "CardView.h"

@implementation CardView

#define DEFAULT_CARD_HEIGHT 180.0
#define DEFAULT_CARD_SCALE_FACTOR 0.9
#define DEFAULT_CARD_CORNER_RADIUS 12.0


- (CGFloat)cardScaleFactor
{
    return self.bounds.size.height / DEFAULT_CARD_HEIGHT;
}

- (CGFloat)cardCornerRadius
{
    return [self cardScaleFactor] * DEFAULT_CARD_CORNER_RADIUS;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    //draw rounded rect
    
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:[self cardCornerRadius]];
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(rect);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeRedraw; // redraw view then bounds changed
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    
    return self;
}

- (Card *)getCard //abstract
{
    return nil;
}

- (void)setCard:(Card *)card //abstract
{
    
}

@end
