//
//  CardView.h
//  CardGameUpdated
//
//  Created by igorbizi@mail.ru on 4/15/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface CardView : UIView

- (CGFloat)cardScaleFactor;
- (CGFloat)cardCornerRadius;

- (Card *)getCard; //abstract
- (void)setCard:(Card *)card; //abstract

@end
