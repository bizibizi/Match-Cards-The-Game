//
//  Settings.h
//  MatchCardsTheGame
//
//  Created by igorbizi@mail.ru on 4/21/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "RatingItem.h"

@interface Settings : NSObject

- (NSUInteger)matchBonus;
- (NSUInteger)missmatchPenalty;
- (NSUInteger)flipCost;

- (void)setMatchBonus:(NSUInteger)value;
- (void)setMissmatchPenalty:(NSUInteger)value;
- (void)setFlipCost:(NSUInteger)value;

+ (instancetype)sharedInstance;
- (NSUInteger)addedNewCardsCost;
- (NSUInteger)cheatedCost;

- (void)restoreDefaults;
- (void)registerDefaults;

//rating
- (NSArray *)getRatingItems;
- (void)saveRatingItemWithScore:(NSInteger)score gameIndex:(NSUInteger)gameIndex duration:(NSTimeInterval)duration;
- (void)removeRatingData;

@end
