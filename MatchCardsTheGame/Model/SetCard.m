//
//  Set.m
//  CardGame
//
//  Created by igorbizi@mail.ru on 4/10/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

const int MATCH_SET = 3;

- (NSInteger)match:(NSArray *)otherCards
{
    NSInteger score = 0;
    
    id object = [otherCards firstObject]; // firstObject returns id
    
    if ([object isKindOfClass:[SetCard class]])
    {
        NSMutableArray *cardsToMatch = [NSMutableArray arrayWithArray:otherCards];
        [cardsToMatch addObject:self];
        
        //define sets of properties to find match
        NSMutableSet *colorSet = [[NSMutableSet alloc]init];
        NSMutableSet *figureSet = [[NSMutableSet alloc]init];
        NSMutableSet *numberSet = [[NSMutableSet alloc]init];
        NSMutableSet *shadingSet = [[NSMutableSet alloc]init];

        for (SetCard *setCard in cardsToMatch)
        {
            [colorSet addObject:@(setCard.color)];
            [figureSet addObject:@(setCard.figure)];
            [numberSet addObject:@(setCard.number)];
            [shadingSet addObject:@(setCard.shading)];
        }
        
        //if set count is max - all cards diferent, if set count is 1 - all cards are the same
        NSUInteger max = cardsToMatch.count;
        NSUInteger min = 1;

        if ((colorSet.count == min || colorSet.count == max) &&
            (figureSet.count == min || figureSet.count == max) &&
            (numberSet.count == min || numberSet.count == max) &&
            (shadingSet.count == min || shadingSet.count == max))
        {
            score = MATCH_SET;
        }
    }
    
    return score;
}

//draw card titles
- (NSAttributedString *)contents
{
    return nil;
}

/*
//draw card titles
- (NSAttributedString *)contents
{
    // used drawing
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]init];
    
    NSAttributedString *figure;
    switch (self.figure) {
        case squareFigure:
        {
            figure = [[NSAttributedString alloc]initWithString:@"■"];
        }
            break;
            
        case circleFigure:
        {
            figure = [[NSAttributedString alloc]initWithString:@"●"];
        }
            break;
            
        case triangleFigure:
        {
            figure = [[NSAttributedString alloc]initWithString:@"▲"];
        }
            break;
            
        default:
        {
            figure = [[NSAttributedString alloc]initWithString:@"?"];
        }
            break;
    }
    
    NSUInteger number = self.number;
    while (number) {
        [string appendAttributedString:figure];
        if (number != 1) {
            [string appendAttributedString:[[NSAttributedString alloc]initWithString:@"\n"]];
        }
        number--;
    }
    
    //make color as stroke color
    UIColor *color;
    switch (self.color) {
        case redColor:
        {
            color = [UIColor redColor];
        }
            break;
            
        case greenColor:
        {
            color = [UIColor greenColor];
        }
            break;
            
        case blueColor:
        {
            color = [UIColor blueColor];
        }
            break;
            
        default:
        {
            color = [UIColor blackColor];
        }
            break;
    }
    [string addAttribute:NSStrokeColorAttributeName value:color range:NSMakeRange(0, string.length)];
    
    NSNumber *shading;
    switch (self.shading) {
        case solidShading:
        {
            shading = @-10;
        }
            break;
            
        case stripedShading:
        {
            shading = @10;
        }
            break;
            
        case openShading:
        {
            shading = @-10;
        }
            break;
            
        default:
        {
            shading = @0;
        }
            break;
    }
    [string addAttribute:NSStrokeWidthAttributeName value:shading range:NSMakeRange(0, string.length)];
    
    //if openShading we reduce the alpha of original color and fill foreground with it
    //if not we fill foreground with original color
    if (self.shading == openShading)
    {
        UIColor *shadingForegroundColor = [color colorWithAlphaComponent:0.35];
        [string addAttribute:NSForegroundColorAttributeName value:shadingForegroundColor range:NSMakeRange(0, string.length)];
    } else {
        [string addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, string.length)];

    }


    return string;
}
*/


@end
