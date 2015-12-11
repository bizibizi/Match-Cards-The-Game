//
//  PlayingCardView.h
//  CardGameUpdated
//
//  Created by igorbizi@mail.ru on 4/15/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCard.h"
#import "CardView.h"

@interface PlayingCardView : CardView

@property (nonatomic, strong) PlayingCard *playingCard;
@property (nonatomic) BOOL isFaceUp;
- (void)setCardMatch:(BOOL)match;

@end

