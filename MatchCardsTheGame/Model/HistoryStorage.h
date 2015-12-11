//
//  HistoryStorage.h
//  CardGame
//
//  Created by igorbizi@mail.ru on 4/11/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayingCard.h"
#import "SetCard.h"


typedef enum {
    playingCard,
    setCard
} CardType;

typedef enum {
    match,
    notMatch,
    chosen,
    unChosen,
    startGame,
    restartGame
} EntryType;

@interface HistoryStorage : NSObject

@property (nonatomic, strong) NSMutableArray *playingCardHistory; //of NSStrings
@property (nonatomic, strong) NSMutableArray *setCardHistory; // of NSAttributedStrings

- (void)addCards:(NSArray *)cards withEntryType:(EntryType)entryType withScore:(NSInteger)score;
- (void)addEntryType:(EntryType)entryType withSender:(id)sender;
@end
