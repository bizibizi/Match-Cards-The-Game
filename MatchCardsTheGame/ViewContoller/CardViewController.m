//
//  CardViewController.m
//  CardGameUpdated
//
//  Created by igorbizi@mail.ru on 4/16/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import "CardViewController.h"

@interface CardViewController () 
@property (weak, nonatomic) IBOutlet UIView *gridView;
@property (nonatomic, strong) NSMutableArray *cardViews;
@property (nonatomic, strong) Grid *grid;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic) BOOL cardsInPile;
@end

@implementation CardViewController

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.gridView];
    }
    return _animator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateGridSize];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}

- (void)orientationDidChange:(NSNotification *)notification
{
    if (!self.cardsInPile) {
        
        [self updateGridSize];
        
    } else {
        
        [self.animator removeAllBehaviors];
        for (CardView *cv in self.cardViews) {
            UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:cv snapToPoint:self.gridView.center];
            [self.animator addBehavior:snap];
        }
    }
}

//abstract
- (NSUInteger)matchingCardsMode
{
    return 0;
}

//abstract
- (NSUInteger)gameIndex
{
    return 0;
}

//abstact
- (Deck *)createDeck
{
    return nil;
}

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self numberOfInitialCards] usingDeck:[self createDeck]];
        _game.matchingCardsMode = [self matchingCardsMode];
        _game.numberOfPlayers = [self numberOfPlayers];
    }
    return _game;
}

//abstact
- (NSUInteger)numberOfInitialCards
{
    return 0;
}

//abstact
- (NSUInteger)numberOfPlayers
{
    return 1;
}

- (NSMutableArray *)cardViews
{
    if (!_cardViews) {
        _cardViews = [[NSMutableArray alloc] init];
    }
    return _cardViews;
}

- (CGSize)cardSize //abstact
{
    return CGSizeZero;
}

//abstract
- (CardView *)cardViewForCard:(Card *)card
{
    return nil;
}

- (Grid *)grid
{
    if (!_grid) {
        _grid = [[Grid alloc] init];
        _grid.size = self.gridView.frame.size;
        _grid.maxCellHeight = [self cardSize].height;
        _grid.maxCellWidth = [self cardSize].width;
        _grid.cellAspectRatio = self.grid.maxCellWidth / self.grid.maxCellHeight;
        _grid.minimumNumberOfCells = [self numberOfInitialCards];
        if (!_grid.inputsAreValid) {
            NSLog(@"inputs Are NOT Valid");
        }
    }
    return _grid;
}

- (void)updateGridItems
{
    int row = 0;
    int column = 0;
    
    for (int i = 0; i < self.game.numberOfCardsInCurrentGame; i++)
    {
        CardView *cardView;
        if (i < self.cardViews.count) {
            
            cardView = self.cardViews[i];
            
        } else if (i < self.game.cards.count) {
            
            cardView = (id)[self cardViewForCard:self.game.cards[i]];
        }
        
        if (cardView)
        {
            //need to apear from bottom-right
            if (![self.cardViews containsObject:cardView])
            {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardViewTapped:)];
                [cardView addGestureRecognizer:tap];
                
                [self.gridView addSubview:cardView];
                [self.cardViews addObject:cardView];
                
                    CGRect startingFrame = CGRectMake(self.grid.size.width,
                                                   self.grid.size.height,
                                                   self.grid.cellSize.width,
                                                   self.grid.cellSize.height);
                    cardView.frame = startingFrame;
            }
            
            CGRect frame = [self.grid frameOfCellAtRow:row inColumn:column];
            frame = CGRectInset(frame,
                                self.grid.cellSize.width*0.05,
                                self.grid.cellSize.height*0.025);
            
            [UIView animateWithDuration:CARD_ROTATION_TIME
                                  delay:ANIMATION_DELAY_SEC * [self.cardViews indexOfObject:cardView]
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                
                                 cardView.frame = frame;
                                 
                             } completion:nil];
            
            //go next cardView
            column++;
            if (column == self.grid.columnCount)
            {
                column = 0;
                row++;
            }
        }
    }
}

- (void)cardViewTapped:(UITapGestureRecognizer *)gesture
{
    if (self.cardsInPile) {
        
        [self.animator removeAllBehaviors];
        [self updateGridSize];
        self.cardsInPile = NO;
        
    } else {
        
        CardView *cardView = (id)gesture.view;
        Card *card = [cardView getCard];
        if (card) {
            [self animateChooseCardView:cardView];
            NSUInteger index = [self.cardViews indexOfObject:cardView];
            [self.game chooseCardAtIndex:index];
            [cardView setCard:[self.game cardAtIndex:index]];
            [self updateUI];
        }
    }
}

- (void)updateUI
{
    [self updateScore];
    [self updateOtherCards];
}

- (void)updateScore
{
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
}

- (void)updateOtherCards
{
    for (CardView *cardView in self.cardViews)
    {
        [self handleInteractionsForPlayingCardView:cardView];
        [self handleInteractionsForSetCardView:cardView];
    }
}

- (void)handleInteractionsForPlayingCardView:(CardView *)cardView
{
    Card *card = [cardView getCard];
    
    if ([cardView isKindOfClass:[PlayingCardView class]])
    {
        PlayingCardView *playingCardView = (id)cardView;
        
        //chosen/unchosen
        if (playingCardView.isFaceUp && !card.isMatched && !card.isChosen)
        {
            [UIView transitionWithView:cardView
                              duration:CARD_ROTATION_TIME
                               options:[self animationFlipSideForCard:[cardView getCard]] |UIViewAnimationOptionAllowAnimatedContent
                            animations:^{
                                
                                [cardView setNeedsDisplay];
                                
                            } completion:nil];
        }
        
        //match/unmatch
        [UIView animateWithDuration:CARD_ROTATION_TIME
                              delay:CARD_ROTATION_TIME/2
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             [playingCardView setCardMatch:[playingCardView getCard].isMatched];
                             
                         } completion:nil];
    }
}

- (void)handleInteractionsForSetCardView:(CardView *)cardView
{
    if ([cardView isKindOfClass:[SetCardView class]])
    {
        SetCardView *setCardView = (id)cardView;
        
        //chosen/unchosen
        setCardView.chosenView = setCardView.setCard.isChosen;
        if (setCardView.setCard.isChosen && !setCardView.setCard.isMatched)
        {
            [self animateChooseSetCardView:setCardView];
        }
        
        //match/unmatch
        if ([cardView getCard].isMatched)
        {
            [self removeCardView:cardView withDeal:NO];
        }
    }
}

- (void)animateChooseCardView:(CardView *)cardView
{
    if ([cardView isKindOfClass:[PlayingCardView class]])
    {
        if (![cardView getCard].isMatched) {
            [UIView transitionWithView:cardView
                              duration:CARD_ROTATION_TIME
                               options:[self animationFlipSideForCard:[cardView getCard]]
                            animations:^{
                                
                                [cardView setNeedsDisplay];
                                
                            } completion:nil];
        }
    }
    
    if ([cardView isKindOfClass:[SetCardView class]])
    {
        //none
    }
}

- (void)animateChooseSetCardView:(CardView *)cardView
{
    [UIView animateWithDuration:CARD_ROTATION_TIME/2
                          delay:0
                        options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         cardView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:CARD_ROTATION_TIME/2
                                               delay:0
                                             options:UIViewAnimationOptionAllowAnimatedContent
                                          animations:^{
                                              
                                              cardView.transform = CGAffineTransformIdentity;
                                              
                                          } completion:nil];
                         
                     }];
}

- (UIViewAnimationOptions)animationFlipSideForCard:(Card *)card
{
    return card.isChosen? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight;
}

- (void)removeCardView:(CardView *)cardView withDeal:(BOOL)withDeal
{
    [UIView animateWithDuration:CARD_ROTATION_TIME
                          delay:ANIMATION_DELAY_SEC * [self.cardViews indexOfObject:cardView]
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         cardView.frame = CGRectMake(-self.grid.cellSize.width,
                                                     self.grid.size.height,
                                                     self.grid.cellSize.width,
                                                     self.grid.cellSize.height);
                         
                     } completion:^(BOOL finished) {

                         [cardView getCard].matched = NO;
                         [self.game removeCard:[cardView getCard]];
                         [self.cardViews removeObject:cardView];
                         [cardView removeFromSuperview];
                         
                         if (!withDeal) {
                             //TODO:!!!
                             [self updateGridSize];
                         }

                     }];
}

- (IBAction)dealButtonAction:(UIButton *)sender
{
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:@"Deal game"
                                        message:@"Are you sure? "
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 =
    [UIAlertAction actionWithTitle:@"Yes"
                             style:UIAlertActionStyleDestructive
                           handler:^(UIAlertAction *action) {
                               
                               [self.game stopTrackingTimeForGameAtIndex:[self gameIndex]];
                               
                               [self resetCardViews];
                               [self performSelector:@selector(resetCardModel) withObject:nil afterDelay:[Utility removeDeckOfCardsAnimationDelayWithCardsCount:self.cardViews.count]];

                               self.scoreLabel.text = @"Score: 0";
                               
                                                    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Cancel"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)resetCardModel
{
    self.game = nil;
    self.grid = nil;
    [self updateGridSize];
}

- (void)resetCardViews
{
    for (CardView *cardView in self.cardViews)
    {
        [self removeCardView:cardView withDeal:YES];
    }
    
//    [self updateUI];
}

- (IBAction)cheatButtonAction:(UIButton *)sender
{
    //detect are cards are with cheating
    BOOL isCheating = NO;
    for (SetCardView *setCardView in self.cardViews)
    {
        if ([setCardView isKindOfClass:[SetCardView class]])
        {
            if (setCardView.isCheatMark) {
                isCheating = YES;
            }
        }
    }
    
    if (isCheating)
    {
        for (SetCardView *setCardView in self.cardViews)
        {
            if ([setCardView isKindOfClass:[SetCardView class]])
            {
                if (setCardView.isCheatMark)
                {
                    setCardView.cheatMark = NO;
                }
            }
        }
        
    } else {
        
        NSArray *cheatCards = [self.game cheatSetCardsFromCardViews:self.cardViews];
        for (int i = 0; i < cheatCards.count; i++)
        {
            CardView *cardView = [self getCardViewFromCardViewArrayForCard:cheatCards[i]];
            if ([cardView isKindOfClass:[SetCardView class]])
            {
                SetCardView *setCardView = (id)cardView;
                setCardView.cheatMark = YES;
            }
            
            [self.game cheatedScore];
            [self updateScore];
        }
    }
}

- (CardView *)getCardViewFromCardViewArrayForCard:(Card *)card
{
    for (CardView *cv in self.cardViews)
    {
        if ([card isEqual:[cv getCard]])
            return cv;
    }
    return nil;
}

- (IBAction)addCardsInGameButtonAction:(UIButton *)sender
{
    if (self.cardViews.count >= 78)
        return;
    
    NSUInteger count = 3;
    [self.game addCardCount:count];
    [self updateGridSize];

    [self.game addedCardsScore];
    [self updateScore];
    
}

- (void)updateGridSize
{
    self.grid.size = self.gridView.frame.size;
    self.grid.minimumNumberOfCells = self.game.numberOfCardsInCurrentGame;
    [self updateGridItems];
}

- (IBAction)pinchGesture:(UIPinchGestureRecognizer *)sender
{
    if (!self.cardsInPile)
    {
        self.cardsInPile = YES;
        CGPoint point = [sender locationInView:self.gridView];
        
        [self snapBehaviorForCardViewsWithPoint:point];
    }
}

- (IBAction)panGesture:(UIPanGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self.gridView];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        [self.animator removeAllBehaviors];
        
        for (CardView *cv in self.cardViews) {
            UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:cv attachedToAnchor:point];
            [self.animator addBehavior:attachment];
        }
        
    } else
        
        if (sender.state == UIGestureRecognizerStateChanged) {
            for (UIDynamicBehavior *behavior in self.animator.behaviors) {
                
                if ([behavior isKindOfClass:[UIAttachmentBehavior class]]) {
                    UIAttachmentBehavior *attachment = (id)behavior;
                    attachment.anchorPoint = point;
                }
            }
        } else
            
            if (sender.state == UIGestureRecognizerStateEnded) {
                
                [self snapBehaviorForCardViewsWithPoint:point];
                self.cardsInPile = YES;
            }
}

- (void)snapBehaviorForCardViewsWithPoint:(CGPoint)point
{
    [self.animator removeAllBehaviors];
    
    for (CardView *cv in self.cardViews) {
        UISnapBehavior *snap =
        [[UISnapBehavior alloc] initWithItem:cv
                                 snapToPoint:CGPointMake(point.x + [self.cardViews indexOfObject:cv]/10, point.y + [self.cardViews indexOfObject:cv]/10)];
        snap.damping = 0.9;
        [self.animator addBehavior:snap];
    }

}

@end
