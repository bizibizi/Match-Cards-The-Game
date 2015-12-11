//
//  SetGameViewController.m
//  MatchCardsTheGame
//
//  Created by igorbizi@mail.ru on 4/21/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import "SetGameViewController.h"

@interface SetGameViewController ()

@end

@implementation SetGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (Deck *)createDeck //abstract
{
    return [[SetCardDeck alloc] init];
}

- (NSUInteger)matchingCardsMode //abstract
{
    return 3;
}

- (NSUInteger)numberOfInitialCards //abstact
{
    return 12;
}

- (NSUInteger)gameIndex //abstact
{
    return 1;
}

- (SetCardView *)cardViewForCard:(SetCard *)card
{
    SetCardView *cardView = [[SetCardView alloc] init];
    if ([card isKindOfClass:[SetCard class]]) {
        cardView.setCard = (id)card;
    }
    return cardView;
}

- (CGSize)cardSize //abstact
{
    return CGSizeMake(120, 120);
}
@end
