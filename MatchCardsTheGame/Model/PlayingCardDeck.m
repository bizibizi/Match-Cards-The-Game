//
//  PlayingCardDeck.m
//  CardGame
//
//  Created by igorbizi@mail.ru on 4/8/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import "PlayingCardDeck.h"

@implementation PlayingCardDeck

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
    for (NSString *suit in [PlayingCard validSuits])
    {
        for (NSUInteger rank = 1; rank <= [PlayingCard maxRank]; rank++)
        {
            PlayingCard *card = [[PlayingCard alloc]init];
            card.suit = suit;
            card.rank = rank;
            [self addCard:card];
        }
    }
}

@end
