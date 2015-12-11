//
//  RatingItem.h
//  CardGame
//
//  Created by igorbizi@mail.ru on 4/12/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingItem : NSObject

@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *game;

- (instancetype)initWithScore:(NSInteger)score withDuration:(NSTimeInterval)duration withDate:(NSDate *)date withGame:(NSUInteger)game;

@end
