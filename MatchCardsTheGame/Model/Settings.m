//
//  Settings.m
//  MatchCardsTheGame
//
//  Created by igorbizi@mail.ru on 4/21/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import "Settings.h"

@implementation Settings

#define kMatchBonusDefault 4
#define kMissmatchPenaltyDefault 2
#define kFlipCostDefault 1
#define kAddedNewCardsDefault 10
#define kCheatedDefault 20

+ (instancetype)sharedInstance
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

- (NSUInteger)matchBonus
{
    return [self getValueForKey:kMatchBonusKey];
}

- (NSUInteger)missmatchPenalty
{
    return [self getValueForKey:kMissmatchPenaltyKey];
}

- (NSUInteger)flipCost
{
    return [self getValueForKey:kFlipCostKey];
}

- (void)setMatchBonus:(NSUInteger)value
{
    [self setInteger:value forKey:kMatchBonusKey];
}

- (void)setMissmatchPenalty:(NSUInteger)value
{
    [self setInteger:value forKey:kMissmatchPenaltyKey];
}

- (void)setFlipCost:(NSUInteger)value
{
    [self setInteger:value forKey:kFlipCostKey];
}

- (void)setInteger:(NSUInteger)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSUInteger)getValueForKey:(NSString *)key
{
    return (NSUInteger)[[NSUserDefaults standardUserDefaults] integerForKey:key];
}

- (NSUInteger)addedNewCardsCost
{
    return kAddedNewCardsDefault;
}

- (NSUInteger)cheatedCost
{
    return kCheatedDefault;
}

- (void)registerDefaults
{
    [[NSUserDefaults standardUserDefaults]
     registerDefaults:@{kMatchBonusKey : @(kMatchBonusDefault),
                        kMissmatchPenaltyKey : @(kMissmatchPenaltyDefault),
                        kFlipCostKey : @(kFlipCostDefault)}];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)restoreDefaults
{
    [[NSUserDefaults standardUserDefaults] setInteger:kMatchBonusDefault forKey:kMatchBonusKey];
    [[NSUserDefaults standardUserDefaults] setInteger:kMissmatchPenaltyDefault forKey:kMissmatchPenaltyKey];
    [[NSUserDefaults standardUserDefaults] setInteger:kFlipCostDefault forKey:kFlipCostKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)saveRatingItemWithScore:(NSInteger)score gameIndex:(NSUInteger)gameIndex duration:(NSTimeInterval)duration
{
    RatingItem *ratingItem = [[RatingItem alloc] initWithScore:score
                                                  withDuration:duration
                                                      withDate:[NSDate date]
                                                      withGame:gameIndex];
    
    NSMutableArray *rating = [[NSMutableArray alloc]init];
    NSArray *ratingTemp = [self getRatingItems];
    if (ratingTemp.count)
        rating = [ratingTemp mutableCopy];
    
    [rating addObject:ratingItem];
    [self saveRatingItems:rating];
}

- (void)saveRatingItems:(NSArray *)rating
{
    NSData *customObjectData = [NSKeyedArchiver archivedDataWithRootObject:rating];
    [[NSUserDefaults standardUserDefaults] setObject:customObjectData forKey:kRatingKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)getRatingItems
{
    NSData *ratingData = [[NSUserDefaults standardUserDefaults] objectForKey:kRatingKey];
    return ratingData? [NSKeyedUnarchiver unarchiveObjectWithData:ratingData] : nil;
}

- (void)removeRatingData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRatingKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
