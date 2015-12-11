//
//  Utility.h
//  MatchCardsTheGame
//
//  Created by igorbizi@mail.ru on 4/22/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ANIMATION_DELAY_SEC 0.02

@interface Utility : NSObject

+ (CGFloat)removeDeckOfCardsAnimationDelayWithCardsCount:(NSUInteger)count;

@end
