//
//  Deck.m
//  CardGame
//
//  Created by igorbizi@mail.ru on 4/8/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import "Deck.h"

@interface Deck ()
@property (nonatomic, strong) NSMutableArray *cards;// of Cards

@end

@implementation Deck

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc]init];
    }
    return _cards;
}

- (void)addCard:(Card *)card
{
    [self addCard:card AtTop:NO];
}

- (void)addCard:(Card *)card AtTop:(BOOL)atTop
{
    if (atTop) {
        [self.cards insertObject:card atIndex:0];
    } else {
        [self.cards addObject:card];
    }
}

//abstract
- (void)createCards
{
}

//was bad idea
//created 2 arrays of cards
//then we return card from primary array, we move it to secondary
//then primary array empties, we use cards from secondary array
//so cards can not end

- (Card *)drawRandomCard
{
    Card *card = nil;
    
    if (!self.cards.count)
    {
        [self createCards];
    }
    
    if (self.cards.count)
    {
        NSUInteger index = arc4random() % self.cards.count;
        card = [self.cards objectAtIndex:index];
        [self.cards removeObjectAtIndex:index];
    }
    
    card.matched = NO;
    card.chosen = NO;
    
    return card;
 }

@end
