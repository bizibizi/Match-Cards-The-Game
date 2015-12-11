//
//  HistoryStorage.m
//  CardGame
//
//  Created by igorbizi@mail.ru on 4/11/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import "HistoryStorage.h"

@implementation HistoryStorage

- (NSMutableArray *)setCardHistory
{
    if (!_setCardHistory) {
        _setCardHistory = [[NSMutableArray alloc]init];
    }
    return _setCardHistory;
}

- (NSMutableArray *)playingCardHistory
{
    if (!_playingCardHistory) {
        _playingCardHistory = [[NSMutableArray alloc]init];
    }
    return _playingCardHistory;
}

- (void)addCards:(NSArray *)cards withEntryType:(EntryType)entryType withScore:(NSInteger)score
{
    if (entryType == unChosen || entryType == chosen)
    {
        NSString *descAction = (entryType == unChosen) ? @"unchosen" : @"chosen";
        if (cards.count == 1)
        {
            Card *card = [cards firstObject];
            if ([card isKindOfClass:[Card class]])
            {
                NSString *unchosen = [NSString stringWithFormat:@"%@ %@", card.contents, descAction];
                if ([card isKindOfClass:[SetCard class]]) {
                    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]init];
                    [string appendAttributedString:[self stringDescriptionOfSetCards:@[card]]];
                    [string appendAttributedString:[[NSAttributedString alloc]initWithString:descAction]];
                    [self.setCardHistory addObject:string];
                } else if ([card isKindOfClass:[PlayingCard class]]) {
                    [self.playingCardHistory addObject:unchosen];
                }
            }
        }
    }
    
    else if (entryType == match || entryType == notMatch)
    {
        NSMutableAttributedString *selectedSetCards = [[NSMutableAttributedString alloc]init];
        Card *card = [cards firstObject];
        
        if (entryType == match)
        {
            if ([card isKindOfClass:[SetCard class]]) {
                [selectedSetCards appendAttributedString:[[NSAttributedString alloc]initWithString:@"Matched "]];
                [selectedSetCards appendAttributedString:[self stringDescriptionOfSetCards:cards]];
                [selectedSetCards appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" for %ld points", (long)score]]];
                [self.setCardHistory addObject:selectedSetCards];
                
            } else if ([card isKindOfClass:[PlayingCard class]]) {
                [self.playingCardHistory addObject:[NSString stringWithFormat:@"Matched %@ for %ld points", [self stringDescriptionOfPlayingCards:cards], (long)score]];
            }
        }
        
        if (entryType == notMatch)
        {
            if ([card isKindOfClass:[SetCard class]]) {
                [selectedSetCards appendAttributedString:[self stringDescriptionOfSetCards:cards]];
                [selectedSetCards appendAttributedString:[[NSAttributedString alloc]initWithString:@" don’t match! "]];
                [selectedSetCards appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld point penalty!", (long)score]]];
                [self.setCardHistory addObject:selectedSetCards];
                
            } else if ([card isKindOfClass:[PlayingCard class]]) {
                [self.playingCardHistory addObject:[NSString stringWithFormat:@"%@ don’t match! %ld point penalty!", [self stringDescriptionOfPlayingCards:cards], (long)score]];
            }
        }
    }
}


- (void)addEntryType:(EntryType)entryType withSender:(id)sender
{
    if (entryType == startGame)
    {
        NSString *str = @"Game started!";
        if (sender == [PlayingCard class]) {
            [self.playingCardHistory addObject:str];
        } else if (sender == [SetCard class]) {
            [self.setCardHistory addObject:[[NSAttributedString alloc]initWithString:str]];
        }
    }
}

- (NSString *)stringDescriptionOfPlayingCards:(NSArray *)cards
{
    NSMutableString *desc = [NSMutableString string];
    for (PlayingCard *card in cards)
    {
        [desc appendString:card.contents];
        if (card != [cards lastObject]) {
            [desc appendString:@" "];
        }
    }
    
    return desc;
}

- (NSAttributedString *)stringDescriptionOfSetCards:(NSArray *)cards
{
    NSMutableAttributedString *desc = [[NSMutableAttributedString alloc]init];
    for (SetCard *card in cards)
    {
        [desc appendAttributedString:(NSAttributedString *)card.contents];
        if (card != [cards lastObject]) {
            [desc appendAttributedString:[[NSAttributedString alloc]initWithString:@" "]];
        }
    }
    
    [[desc mutableString] replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, desc.length)];
    
    return desc;
}

@end
