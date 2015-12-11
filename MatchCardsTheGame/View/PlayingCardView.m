//
//  PlayingCardView.m
//  CardGameUpdated
//
//  Created by igorbizi@mail.ru on 4/15/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import "PlayingCardView.h"

@interface PlayingCardView ()
@property (nonatomic) BOOL cardIsChosen;
@property (nonatomic) CGFloat cardImageOffsetFactor;
@end


@implementation PlayingCardView

- (void)setPlayingCard:(PlayingCard *)playingCard
{
    _playingCard = playingCard;

    [self setNeedsDisplay];
}

- (void)setCardMatch:(BOOL)match
{
    self.alpha = match? 0.6 : 1.0;
}

- (BOOL)cardIsChosen
{
    return self.playingCard.isChosen;
}

#define DEFAULT_CARD_NAME_OFFSET 3.0

- (CGFloat)cardNameOffset
{
    return [self cardCornerRadius] / DEFAULT_CARD_NAME_OFFSET;
}

- (CGFloat)cardImageOffsetFactor
{
    return 1.5 * [self cardCornerRadius];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [super drawRect:rect];
    
    if (self.cardIsChosen)
    {
        //draw images
        NSString *imageName = [NSString stringWithFormat:@"%@%@", [PlayingCard validRanks][self.playingCard.rank], self.playingCard.suit];
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            CGRect offsetRect = CGRectInset(self.bounds, [self cardImageOffsetFactor], [self cardImageOffsetFactor]);
            [image drawInRect:offsetRect];
            
        } else { //pips
            [self drawPips];
        }
        
        [self drawCorners];
        
    } else {
        [[UIImage imageNamed:@"cardback"] drawInRect:rect];
    }
    
    self.isFaceUp = self.cardIsChosen;
}


- (void)drawCorners
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    font = [UIFont boldSystemFontOfSize:font.pointSize];
    font = [font fontWithSize:[self cardScaleFactor] * font.pointSize];
    
    NSMutableAttributedString *cardName = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@", [PlayingCard validRanks][self.playingCard.rank], self.playingCard.suit] attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font}];
    
    CGSize cardNameSize = [cardName size];
    CGRect cardNameRect = CGRectMake([self cardNameOffset], [self cardNameOffset], cardNameSize.width, cardNameSize.height);
    [cardName drawInRect:cardNameRect];
    
    //bottom card name
    [self pushContextAndRotateUpsideDown];
    [cardName drawInRect:cardNameRect];
    [self popContext];
}

//restore to default 0.0 drawing system
- (void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

//save curent CTM
- (void)pushContextAndRotateUpsideDown
{
    CGContextRef contex = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contex);
    CGContextTranslateCTM(contex, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(contex, M_PI);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {

    }
    
    return self;
}


#pragma mark - Pips


#define PIP_HOFFSET_PERCENTAGE 0.165
#define PIP_VOFFSET1_PERCENTAGE 0.090
#define PIP_VOFFSET2_PERCENTAGE 0.175
#define PIP_VOFFSET3_PERCENTAGE 0.270

- (void)drawPips
{
    //1 in center
    if ((self.playingCard.rank == 1) ||
        (self.playingCard.rank == 5) ||
        (self.playingCard.rank == 9) ||
        (self.playingCard.rank == 3)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:0
                        mirroredVertically:NO];
    }
    
    //2 in center horizontally
    if ((self.playingCard.rank == 6) ||
        (self.playingCard.rank == 7) ||
        (self.playingCard.rank == 8)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:0
                        mirroredVertically:NO];
    }
    
    //2 in center vertically
    if ((self.playingCard.rank == 2) ||
        (self.playingCard.rank == 3) ||
        (self.playingCard.rank == 7) ||
        (self.playingCard.rank == 8) ||
        (self.playingCard.rank == 10)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:PIP_VOFFSET2_PERCENTAGE
                        mirroredVertically:(self.playingCard.rank != 7)];
    }
    
    //4: 2 up and 2 down
    if ((self.playingCard.rank == 4) ||
        (self.playingCard.rank == 5) ||
        (self.playingCard.rank == 6) ||
        (self.playingCard.rank == 7) ||
        (self.playingCard.rank == 8) ||
        (self.playingCard.rank == 9) ||
        (self.playingCard.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:PIP_VOFFSET3_PERCENTAGE
                        mirroredVertically:YES];
    }
    
    //4 in center
    if ((self.playingCard.rank == 9) ||
        (self.playingCard.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:PIP_VOFFSET1_PERCENTAGE
                        mirroredVertically:YES];
    }
}

#define PIP_FONT_SCALE_FACTOR 0.012

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                          upsideDown:(BOOL)upsideDown
{
    if (upsideDown)
        [self pushContextAndRotateUpsideDown];
    
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    UIFont *pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    pipFont = [pipFont fontWithSize:[pipFont pointSize] * self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
    NSAttributedString *attributedSuit = [[NSAttributedString alloc] initWithString:self.playingCard.suit attributes:@{ NSFontAttributeName : pipFont }];
    CGSize pipSize = [attributedSuit size];
    CGPoint pipOrigin = CGPointMake(middle.x-pipSize.width/2.0-hoffset*self.bounds.size.width,
                                    middle.y-pipSize.height/2.0-voffset*self.bounds.size.height
                                    );
    [attributedSuit drawAtPoint:pipOrigin];
    
    if (hoffset) {
        pipOrigin.x += hoffset*2.0*self.bounds.size.width;
        [attributedSuit drawAtPoint:pipOrigin];
    }
    
    if (upsideDown)
        [self popContext];
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                  mirroredVertically:(BOOL)mirroredVertically
{
    [self drawPipsWithHorizontalOffset:hoffset
                        verticalOffset:voffset
                            upsideDown:NO];
    if (mirroredVertically) {
        [self drawPipsWithHorizontalOffset:hoffset
                            verticalOffset:voffset
                                upsideDown:YES];
    }
}

- (Card *)getCard //abstract
{
    return self.playingCard;
}

- (void)setCard:(PlayingCard *)card //abstract
{
    self.playingCard = card;
    [self setNeedsDisplay];
}

@end
