//
//  Set.h
//  CardGame
//
//  Created by igorbizi@mail.ru on 4/10/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import "Card.h"

typedef enum {
    redColor = 1,
    greenColor,
    blueColor,
    colorCount
} SetColor;

typedef enum {
    squiggleFigure = 1,
    diamondFigure,
    ovalFigure,
    figureCount
} SetFigure;

typedef enum {
    oneNumber = 1,
    twoNumber,
    threeNumber,
    numberCount
} SetNumber;

typedef enum {
    solidShading = 1, //fill
    stripedShading, //empty
    openShading, //lined
    shadingCount
} SetShading;

@interface SetCard : Card

@property (nonatomic) SetColor color;
@property (nonatomic) SetFigure figure;
@property (nonatomic) SetNumber number;
@property (nonatomic) SetShading shading;

@end
