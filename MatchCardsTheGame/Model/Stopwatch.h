//
//  Stopwatch.h
//  CardGame
//
//  Created by igorbizi@mail.ru on 4/12/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingItem.h"
#import "Constants.h"

@interface Stopwatch : NSObject

- (void)start;
- (NSTimeInterval)stopWithSeconds;


@end
