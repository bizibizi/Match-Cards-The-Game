//
//  CardMatchingGame.m
//  CardGame
//
//  Created by igorbizi@mail.ru on 4/8/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//


#import "CardMatchingGame.h"

@interface CardMatchingGame ()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSInteger score1;
@property (nonatomic, readwrite) NSInteger score2;
@property (nonatomic, strong) Deck *deck;
@property (nonatomic, strong) Stopwatch *gameStopWatch;
@end

@implementation CardMatchingGame

- (NSUInteger)numberOfCardsInCurrentGame
{
    return _numberOfCardsInCurrentGame? _numberOfCardsInCurrentGame : self.numberOfCardsInInitialGame;
}

// 2 users game

- (NSUInteger)activePlayer
{
    return _activePlayer? _activePlayer : 1;
}

- (void)setNextActivePlayer
{
    NSUInteger prevActive = self.activePlayer;
    if (prevActive >= self.numberOfPlayers) {
        self.activePlayer = 1;
    } else {
        self.activePlayer = prevActive + 1;
    }
}

//

- (HistoryStorage *)historyStorage
{
    if (!_historyStorage) {
        _historyStorage = [[HistoryStorage alloc]init];
    }
    return _historyStorage;
}

/// Stopwatch

- (Stopwatch *)gameStopWatch
{
    if (!_gameStopWatch) {
        _gameStopWatch = [[Stopwatch alloc] init];
    }
    return _gameStopWatch;
}

- (void)stopTrackingTimeForGameAtIndex:(NSUInteger)index
{
    if (self.score) {
        [[Settings sharedInstance] saveRatingItemWithScore:self.score gameIndex:index duration:self.gameStopWatch.stopWithSeconds];
    }
    if (self.score1) {
        [[Settings sharedInstance] saveRatingItemWithScore:self.score1 gameIndex:index duration:self.gameStopWatch.stopWithSeconds];
    }
    if (self.score2) {
        [[Settings sharedInstance] saveRatingItemWithScore:self.score2 gameIndex:index duration:self.gameStopWatch.stopWithSeconds];
    }
}

///

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    if (self)
    {
        self.deck = deck;
        [self addCardCount:count];
        [self.gameStopWatch start];
        self.numberOfCardsInInitialGame = count;
    }
    
    return self;
}

- (void)addCardCount:(NSUInteger)count
{
    for (NSInteger i = 0; i < count; i++) {
        Card *card = [self.deck drawRandomCard];
        if (card) {
            [self.cards addObject:card];
             self.numberOfCardsInCurrentGame++;
        } else {
            NSLog(@"nil card");
        }
    }
}

- (void)addedCardsScore
{
    NSUInteger cost = [[Settings sharedInstance] addedNewCardsCost];
    if (self.numberOfPlayers == 1) {
        self.score -= cost;
    } else if (self.activePlayer == 1) {
        self.score1 -= cost;
    } else if (self.activePlayer == 2) {
        self.score2 -= cost;
    }
}

- (void)cheatedScore
{
    NSUInteger cost = [[Settings sharedInstance] cheatedCost];
    if (self.numberOfPlayers == 1) {
        self.score -= cost;
    } else if (self.activePlayer == 1) {
        self.score1 -= cost;
    } else if (self.activePlayer == 2) {
        self.score2 -= cost;
    }
}

- (void)removeCard:(Card *)card
{
    if ([self.cards containsObject:card]) {
        [self.cards removeObject:card];
    } else {
        NSLog(@"no object to remove");
    }
    self.numberOfCardsInCurrentGame--;
}

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc]init];
    }
    return _cards;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

- (void)chooseCardAtIndex:(NSUInteger)index;
{
    Card *card = [self cardAtIndex:index];
    if (!card.isMatched) {
        if (card.isChosen) {
            
            card.chosen = NO;
            
            //add history
            //[self.historyStorage addCards:@[card] withEntryType:unChosen withScore:0];
            
        } else {  //check for chosen different cards
            
            //add history
            //[self.historyStorage addCards:@[card] withEntryType:chosen withScore:0];
            
            //other cards
            NSMutableArray *otherCards = [[NSMutableArray alloc]init];
            for (Card *otherCard in self.cards)
            {
                if (!otherCard.isMatched && otherCard.isChosen) {
                    [otherCards addObject:otherCard];
                }
            }
            
            //selected max cards for matchingCardsMode
            //+ 1 for current card which not in array 'otherCards'
            
            if (otherCards.count + 1 == self.matchingCardsMode)
            {
                NSInteger matchScore = [card match:otherCards];
                
                //chosenCards for history entry
                NSMutableArray *allChosenCards = [otherCards mutableCopy];
                [allChosenCards addObject:card];
                
                if (matchScore) { //match
                                        
                    NSInteger savedMatchScore = matchScore * [[Settings sharedInstance] matchBonus];
                    if (self.numberOfPlayers == 1) {
                        self.score += savedMatchScore;
                    } else if (self.activePlayer == 1) {
                        self.score1 += savedMatchScore;
                        [self setNextActivePlayer];
                    } else if (self.activePlayer == 2) {
                        self.score2 += savedMatchScore;
                        [self setNextActivePlayer];
                    }
                    
                    card.matched = YES;
                    [otherCards setValue:@YES forKey:@"matched"];
                    
                    //add history
                    //[self.historyStorage addCards:allChosenCards withEntryType:match withScore:savedMatchScore];
                    
                } else {
                    
                    [otherCards setValue:@NO forKey:@"chosen"];
                    [otherCards setValue:@NO forKey:@"matched"];
                    
                    NSUInteger missmatchPenaltyCost = [[Settings sharedInstance] missmatchPenalty];
                    if (self.numberOfPlayers == 1) {
                        self.score -= missmatchPenaltyCost;
                    } else if (self.activePlayer == 1) {
                        self.score1 -= missmatchPenaltyCost;
                        [self setNextActivePlayer];
                    } else if (self.activePlayer == 2) {
                        self.score2 -= missmatchPenaltyCost;
                        [self setNextActivePlayer];
                    }
                    
                    //add history
//                    [self.historyStorage addCards:allChosenCards withEntryType:notMatch withScore:MISMATCH_PENALTY];
                }
            }
            
            NSUInteger flipCost = [[Settings sharedInstance] flipCost];
            if (self.numberOfPlayers == 1) {
                self.score -= flipCost;
            } else if (self.activePlayer == 1) {
                self.score1 -= flipCost;
            } else if (self.activePlayer == 2) {
                self.score2 -= flipCost;
            }

            card.chosen = YES;
        }
    }
}

- (NSUInteger)matchingCardsMode
{
    return _matchingCardsMode? _matchingCardsMode : 2;
}

- (NSArray *)cheatSetCardsFromCardViews:(NSArray *)cardViews
{
    NSMutableArray *cards = [[NSMutableArray alloc] initWithCapacity:cardViews.count];
    for (CardView *cv in cardViews)
    {
        [cards addObject:[cv getCard]];
    }
    
    return [self cheatCardsFromCards:cards];
}

- (NSArray *)cheatCardsFromCards:(NSArray *)cards
{
    NSMutableArray *cheatCards = [NSMutableArray array];
    NSUInteger count = cards.count;
    
    //find combinations of 3 cards
    for (int i1 = 0; i1 < count; i1++)
    {
        for (int i2 = 0; i2 < count; i2++)
        {
            for (int i3 = 0; i3 < count; i3++)
            {
                if (i1 != i2 &&
                    i2 != i3 &&
                    i3 != i1) {
                    
                    Card *card1 = cards[i1];
                    NSUInteger score = [card1 match:@[cards[i2], cards[i3]]];
                    if (score) {
                        [cheatCards addObjectsFromArray:@[cards[i1], cards[i2], cards[i3]]];
                        return cheatCards;
                    } else {
                        continue;
                    }
                }
            }
        }
    }
    
    return nil;
}







@end
