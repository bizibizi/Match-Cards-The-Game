//
//  Utility.m
//  MatchCardsTheGame
//
//  Created by igorbizi@mail.ru on 4/22/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (CGFloat)removeDeckOfCardsAnimationDelayWithCardsCount:(NSUInteger)count
{
    return [self restForItem:count] * 4;
}

+ (CGFloat)restForItem:(NSInteger)item
{
    if (item == 0) {
        return 0;
    } else {
        return (item + [self restForItem:item - 1]) * ANIMATION_DELAY_SEC;
        //this is OK for error in logic
    }
    return 0;
}

@end
