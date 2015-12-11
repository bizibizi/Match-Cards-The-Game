//
//  SetCardView.m
//  CardGameUpdated
//
//  Created by igorbizi@mail.ru on 4/16/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

- (void)setCheatMark:(BOOL)cheatMark
{
    _cheatMark = cheatMark;
    [self setNeedsDisplay];
}

- (void)setChosenView:(BOOL)chosenView
{
    _chosenView = chosenView;
    [self setNeedsDisplay];
}

- (void)setSetCard:(SetCard *)card
{
    _setCard = card;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [super drawRect:rect];

    [self drawFigures];
    
    if (self.isChosenView) {
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cardCornerRadius]];
        [bezierPath addClip];
        [[UIColor blueColor] setStroke];
        bezierPath.lineWidth = [self cardCornerRadius] * 1.5;
        [bezierPath stroke];
    }
    
    if (self.isCheatMark) {
        CGRect cheatRect = CGRectMake(self.bounds.size.width * 0.05,
                                      self.bounds.size.height * 0.05,
                                      self.bounds.size.width * 0.2,
                                      self.bounds.size.height * 0.2);
        
        UIBezierPath *cheatPath = [[UIBezierPath alloc] init];
        [cheatPath moveToPoint:CGPointMake(cheatRect.origin.x + cheatRect.size.width*1/8,
                                           cheatRect.origin.y + cheatRect.size.height)];
        [cheatPath addLineToPoint:CGPointMake(cheatRect.origin.x + cheatRect.size.width/2,
                                              cheatRect.origin.y)];
        [cheatPath addLineToPoint:CGPointMake(cheatRect.origin.x + cheatRect.size.width - cheatRect.size.width*1/8,
                                              cheatRect.origin.y + cheatRect.size.height)];
        [cheatPath addLineToPoint:CGPointMake(cheatRect.origin.x,
                                              cheatRect.origin.y + cheatRect.size.height*2.5/8)];
        [cheatPath addLineToPoint:CGPointMake(cheatRect.origin.x + cheatRect.size.width,
                                              cheatRect.origin.y + cheatRect.size.height*2.5/8)];
        [cheatPath closePath];

        [[UIColor yellowColor] setFill];
        [cheatPath fill];
    }
}

- (void)drawFigures
{
    //number
    SetNumber number = self.setCard.number;
    
    //max 3 pips, so it will have 1, 2, 3 indexes
    
    //center
    if (number == oneNumber ||
        number == threeNumber) {
        [self drawFigureWithYOffset:[self offsetYForFigureAtIndex:1]];
    }
    
    //top, down
    if (number == threeNumber) {
        [self drawFigureWithYOffset:[self offsetYForFigureAtIndex:2]];
        [self drawFigureWithYOffset:[self offsetYForFigureAtIndex:3]];
    }
    
    //2 center
    if (number == twoNumber) {
        [self drawFigureWithYOffset:[self offsetYForFigureAtIndex:1]];
        [self drawFigureWithYOffset:[self offsetYForFigureAtIndex:2]];
    }
}

#define SET_FIGURE_DEFAULT_HEIGHT 40.0
#define SET_FIGURE_DEFAULT_WIDTH 80.0

- (CGSize)sizeForFigure
{
    return CGSizeMake(self.cardScaleFactor * SET_FIGURE_DEFAULT_WIDTH,
                      self.cardScaleFactor * SET_FIGURE_DEFAULT_HEIGHT);
}

- (CGFloat)setXOffset
{
    return (self.bounds.size.width - [self sizeForFigure].width) / 2 ;
}

//min index 1, max 3 for set
- (CGFloat)offsetYForFigureAtIndex:(NSUInteger)index
{
    CGFloat result = 0;
    CGFloat cardHeight = self.bounds.size.height;
    CGFloat figureHeight = [self sizeForFigure].height;
    CGFloat padding = figureHeight / 4;
    NSUInteger maxIndex = self.setCard.number;
    
    result = (cardHeight - figureHeight * maxIndex - padding * (maxIndex - 1)) / 2;
    result += (figureHeight + padding) * (index - 1);
    
    return result;
}

- (void)drawFigureWithYOffset:(CGFloat)YOffset
{
    //figure
    SetFigure figure = self.setCard.figure;
    UIBezierPath *figurePath;
    CGRect rect = CGRectMake([self setXOffset],
                             YOffset,
                             [self sizeForFigure].width,
                             [self sizeForFigure].height);
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat h = rect.size.height;
    CGFloat w = rect.size.width;

    if (figure == diamondFigure) {
        figurePath = [[UIBezierPath alloc] init];
        [figurePath moveToPoint:CGPointMake(x + w/2, y)];
        [figurePath addLineToPoint:CGPointMake(x + w, y + h/2)];
        [figurePath addLineToPoint:CGPointMake(x + w/2, y + h)];
        [figurePath addLineToPoint:CGPointMake(x, y + h/2)];
        [figurePath closePath];
        
    } else if (figure == ovalFigure) {
        figurePath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:rect.size];
      
    } else if (figure == squiggleFigure) {
        figurePath = [[UIBezierPath alloc] init];
        [figurePath moveToPoint:CGPointMake(x + w*0.05, y + h*0.40)];
        
        [figurePath addCurveToPoint:CGPointMake(x + w*0.35, y + h*0.25)
                controlPoint1:CGPointMake(x + w*0.09, y + h*0.15)
                controlPoint2:CGPointMake(x + w*0.18, y + h*0.10)];
        
        [figurePath addCurveToPoint:CGPointMake(x + w*0.75, y + h*0.30)
                controlPoint1:CGPointMake(x + w*0.40, y + h*0.30)
                controlPoint2:CGPointMake(x + w*0.60, y + h*0.45)];
        
        [figurePath addCurveToPoint:CGPointMake(x + w*0.97, y + h*0.35)
                controlPoint1:CGPointMake(x + w*0.87, y + h*0.15)
                controlPoint2:CGPointMake(x + w*0.98, y + h*0.00)];
    
        [figurePath addCurveToPoint:CGPointMake(x + w*0.45, y + h*0.85)
                controlPoint1:CGPointMake(x + w*0.95, y + h*1.10)
                controlPoint2:CGPointMake(x + w*0.50, y + h*0.95)];
        
        [figurePath addCurveToPoint:CGPointMake(x + w*0.25, y + h*0.85)
                controlPoint1:CGPointMake(x + w*0.40, y + h*0.80)
                controlPoint2:CGPointMake(x + w*0.35, y + h*0.75)];
        
        [figurePath addCurveToPoint:CGPointMake(x + w*0.05, y + h*0.40)
                controlPoint1:CGPointMake(x + w*0.00, y + h*1.10)
                controlPoint2:CGPointMake(x + w*0.005, y + h*0.60)];
        
        [figurePath closePath];
    }
    
    //color
    SetColor colorEnum = self.setCard.color;
    UIColor *color;
    if (colorEnum == greenColor) {
        color = [UIColor greenColor];
    } else if (colorEnum == redColor) {
        color = [UIColor redColor];
    } else if (colorEnum == blueColor) {
        color = [UIColor blueColor];
    }
    
    [color setStroke];
    [figurePath stroke];
    
    //shading
    SetShading shading = self.setCard.shading;
    if (shading == solidShading) { //fill
        [color setFill];
        [figurePath fill];
        
    } else if (shading == stripedShading) {  //empty
        
    } else if (shading == openShading) { //lined
        
        UIBezierPath *shadingPath = [[UIBezierPath alloc] init];
        
        CGContextSaveGState(UIGraphicsGetCurrentContext());
        
        [figurePath addClip];
        
        CGFloat linePadding = [self sizeForFigure].height / 2.5;
        for (int i = 0; i < x + w; i+= linePadding)
        {
            CGFloat step = x + i;
            [shadingPath moveToPoint:CGPointMake(step, y)];
            [shadingPath addLineToPoint:CGPointMake(step, y + h)];
        }
        [shadingPath closePath];
        
        shadingPath.lineWidth = 1.5;
        [color setStroke];
        [shadingPath stroke];
        
        CGContextRestoreGState(UIGraphicsGetCurrentContext());
    }
}

- (Card *)getCard //abstract
{
    return self.setCard;
}

- (void)setCard:(SetCard *)card //abstract
{
    self.setCard = card;
    [self setNeedsDisplay];
}

@end
