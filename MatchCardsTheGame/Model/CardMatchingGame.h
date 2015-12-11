//
//  CardMatchingGame.h
//  CardGame
//
//  Created by igorbizi@mail.ru on 4/8/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "PlayingCard.h"
#import "SetCard.h"
#import "HistoryStorage.h"
#import "Constants.h"
#import "CardView.h"
#import "Settings.h"
#import "Stopwatch.h"

@interface CardMatchingGame : NSObject

//designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;

@property (nonatomic, strong) NSMutableArray *cards; // of Cards

//add cards to game
- (void)addCardCount:(NSUInteger)count;

@property (nonatomic) NSUInteger numberOfCardsInCurrentGame;
@property (nonatomic) NSUInteger numberOfCardsInInitialGame;

//remove card from game
- (void)removeCard:(Card *)card;

- (void)stopTrackingTimeForGameAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;
- (void)chooseCardAtIndex:(NSUInteger)index;
@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSInteger score1;
@property (nonatomic, readonly) NSInteger score2;
@property (nonatomic) NSUInteger matchingCardsMode;
@property (nonatomic, strong) HistoryStorage *historyStorage;
- (void)addedCardsScore;
- (void)cheatedScore;
- (NSArray *)cheatSetCardsFromCardViews:(NSArray *)cardViews;

@property (nonatomic) NSUInteger numberOfPlayers;
@property (nonatomic) NSUInteger activePlayer;

@end
