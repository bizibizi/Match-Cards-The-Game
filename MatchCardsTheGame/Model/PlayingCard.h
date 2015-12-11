//
//  PlayingCard.h
//  CardGame
//
//  Created by igorbizi@mail.ru on 4/8/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (nonatomic, strong) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSUInteger)maxRank;
+ (NSArray *)validSuits;
+ (NSArray *)validRanks;

@end
