//
//  CardViewController.h
//  CardGameUpdated
//
//  Created by igorbizi@mail.ru on 4/16/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"
#import "Constants.h"
#import "Stopwatch.h"
#import "RatingItem.h"
#import "CardView.h"
#import "Grid.h"
#import "PlayingCardView.h"
#import "SetCardView.h"
#import "Utility.h"

@interface CardViewController : UIViewController

@property (nonatomic, strong) CardMatchingGame *game;

// ** must implement

// return playing card deck
- (Deck *)createDeck; //abstract

//how many card in matching game?
- (NSUInteger)matchingCardsMode; //abstract

//for separately game
//- (NSArray *)historyStorage; //abstract

// save rating
- (NSUInteger)gameIndex; //abstact

- (NSUInteger)numberOfInitialCards; //abstact

- (CardView *)cardViewForCard:(Card *)card; //abstact

- (CGSize)cardSize; //abstact

- (NSUInteger)numberOfPlayers; //abstact

// **

 


@end
