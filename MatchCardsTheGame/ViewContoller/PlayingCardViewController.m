//
//  PlayingCardViewController.m
//  MatchCardsTheGame
//
//  Created by igorbizi@mail.ru on 4/20/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import "PlayingCardViewController.h"

@interface PlayingCardViewController ()

@end

@implementation PlayingCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (Deck *)createDeck //abstract
{
    return [[PlayingCardDeck alloc] init];
}

- (NSUInteger)matchingCardsMode //abstract
{
    return 2;
}

- (NSUInteger)numberOfInitialCards //abstact
{
    return 35;
}

- (NSUInteger)gameIndex //abstact
{
    return 0;
}

- (PlayingCardView *)cardViewForCard:(PlayingCard *)card
{
    PlayingCardView *cardView = [[PlayingCardView alloc] init];
    if ([card isKindOfClass:[PlayingCard class]]) {
        cardView.playingCard = (id)card;
    }
    return cardView;
}

- (CGSize)cardSize //abstact
{
    return CGSizeMake(80, 120);
}

@end
