//
//  Stopwatch.m
//  CardGame
//
//  Created by igorbizi@mail.ru on 4/12/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import "Stopwatch.h"
@interface Stopwatch ()
@property (nonatomic) CGFloat seconds;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation Stopwatch

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)start
{
    self.seconds = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                  target:self
                                                selector:@selector(tic)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)tic
{
    self.seconds+= 0.5;
}

- (NSTimeInterval)stopWithSeconds
{
    [self.timer invalidate];
    return self.seconds;
}


@end
