//
//  SetCardDeck.m
//  CardGame
//
//  Created by igorbizi@mail.ru on 4/11/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import "SetCardDeck.h"

@implementation SetCardDeck

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self createCards];
    }
    
    return self;
}

- (void)createCards
{
    for (int shading = 1; shading < shadingCount; shading++)
    {
        for (int color = 1; color < colorCount; color++)
        {
            for (int number = 1; number < numberCount; number++)
            {
                for (int figure = 1; figure < figureCount; figure++)
                {
                    SetCard *setCard = [[SetCard alloc]init];
                    setCard.shading = shading;
                    setCard.color = color;
                    setCard.number = number;
                    setCard.figure = figure;
                    [self addCard:setCard];
                }
            }
        }
    }
}

@end
