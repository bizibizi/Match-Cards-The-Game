//
//  RatingItem.m
//  CardGame
//
//  Created by igorbizi@mail.ru on 4/12/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import "RatingItem.h"

@interface RatingItem ()

@end

@implementation RatingItem

- (instancetype)initWithScore:(NSInteger)score withDuration:(NSTimeInterval)duration withDate:(NSDate *)date withGame:(NSUInteger)game
{
    self = [super init];
    if (self)
    {
        self.score = [RatingItem scoreStrFromScore:score];
        self.duration = [RatingItem durationStrFromDuration:duration];
        self.date = [RatingItem dateStrFromDate:date];
        self.game = [RatingItem gameStrFromGame:game];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.score forKey:@"score"];
    [coder encodeObject:self.date forKey:@"date"];
    [coder encodeObject:self.duration forKey:@"duration"];
    [coder encodeObject:self.game forKey:@"game"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self)
    {
        self.score = [coder decodeObjectForKey:@"score"];
        self.date = [coder decodeObjectForKey:@"date"];
        self.duration = [coder decodeObjectForKey:@"duration"];
        self.game = [coder decodeObjectForKey:@"game"];

    }
    return self;
}

+ (NSString *)gameStrFromGame:(NSUInteger)game
{
    NSString *gameStr;
    switch (game) {
        case 0:
            gameStr = @"Cards";
            break;
            
        case 1:
        case 2:
            gameStr = @"Set";
            break;
            
        default:
            gameStr = @"?";
            break;
    }
    return gameStr;
}

+ (NSString *)scoreStrFromScore:(NSInteger)score
{
    return [NSString stringWithFormat:@"%ld", (long)score];
}

+ (NSString *)durationStrFromDuration:(NSTimeInterval)duration
{
    int min = duration / 60;
    int sec = (int)duration % 60;
    NSMutableString *string = [[NSMutableString alloc] init];
    if (min) {
        [string appendString:[NSString stringWithFormat:@"%dm ", min]];
    }
    
    [string appendString:[NSString stringWithFormat:@"%ds", sec]];
    
    return string;
}

+ (NSString *)dateStrFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM.dd hh:mm"];
    NSString *keyDate = [dateFormatter stringFromDate:date];
    return keyDate;
}

@end
