//
//  SetCardView.h
//  CardGameUpdated
//
//  Created by igorbizi@mail.ru on 4/16/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import "CardView.h"
#import "SetCard.h"

@interface SetCardView : CardView

@property (nonatomic, strong) SetCard *setCard;
@property (nonatomic, getter=isChosenView) BOOL chosenView;
@property (nonatomic, getter=isCheatMark) BOOL cheatMark;

@end
