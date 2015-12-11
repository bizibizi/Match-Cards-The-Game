//
//  PlayingCard.m
//  CardGame
//
//  Created by igorbizi@mail.ru on 4/8/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (NSString *)contents
{
    
    return [[PlayingCard validRanks][self.rank] stringByAppendingString:self.suit];
}

+ (NSArray *)validRanks
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank
{
    return [PlayingCard validRanks].count - 1;
}

+ (NSArray *)validSuits
{
    return @[@"♥", @"♦", @"♠", @"♣"];
}

@synthesize suit = _suit;

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}
- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank])
        _rank = rank;
}

- (NSString *)suit
{
    return _suit? _suit : @"?";
}

const int MATCH_RANK = 4;
const int MATCH_SUIT = 1;

- (NSInteger)match:(NSArray *)otherCards
{
    NSInteger score = 0;
    
    id object = [otherCards firstObject]; // firstObject returns id
    
    if ([object isKindOfClass:[PlayingCard class]])
    {
        NSMutableArray *otherCardsMutable = [otherCards mutableCopy];
        [otherCardsMutable addObject:self];
        
        while (otherCardsMutable.count) {
            
            PlayingCard *firstCard = [otherCardsMutable firstObject];
            [otherCardsMutable removeObject:firstCard];
            
            for (PlayingCard *card in otherCardsMutable)
            {
                if ([firstCard.suit isEqualToString:card.suit]) {
                    score += MATCH_SUIT;
                } else if (firstCard.rank == card.rank) {
                    score += MATCH_RANK;
                }
            }
        }
    }
    
    return score;
}


@end

