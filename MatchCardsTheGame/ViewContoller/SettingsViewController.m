//
//  SettingsViewController.m
//  MatchCardsTheGame
//
//  Created by igorbizi@mail.ru on 4/21/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISlider *matchBonuesSlider;
@property (weak, nonatomic) IBOutlet UISlider *missmatchPenaltySlider;
@property (weak, nonatomic) IBOutlet UISlider *flipCostSlider;
@property (weak, nonatomic) IBOutlet UILabel *matchBonusLabel;
@property (weak, nonatomic) IBOutlet UILabel *missmatchPenaltyLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipCostLabel;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setValues];
}

- (void)setValues
{
    self.matchBonuesSlider.value = [[Settings sharedInstance] matchBonus];
    self.missmatchPenaltySlider.value = [[Settings sharedInstance] missmatchPenalty];
    self.flipCostSlider.value = [[Settings sharedInstance] flipCost];
    
    self.matchBonusLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[[Settings sharedInstance] matchBonus]];
    self.missmatchPenaltyLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[[Settings sharedInstance] missmatchPenalty]];
    self.flipCostLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[[Settings sharedInstance] flipCost]];
}

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    NSUInteger value = sender.value;
    if (sender == self.matchBonuesSlider) {
        [[Settings sharedInstance] setMatchBonus:value];
        self.matchBonusLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)value];
    } else if (sender == self.missmatchPenaltySlider) {
        [[Settings sharedInstance] setMissmatchPenalty:value];
        self.missmatchPenaltyLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)value];
    } else if (sender == self.flipCostSlider) {
        [[Settings sharedInstance] setFlipCost:value];
        self.flipCostLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)value];
    }
}

- (IBAction)restoreDefaults:(UIButton *)sender
{
    [[Settings sharedInstance] restoreDefaults];
    [self setValues];
}

- (IBAction)resetRating:(UIButton *)sender
{
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:@"Reset rating"
                                        message:@"Are you sure?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction =
    [UIAlertAction actionWithTitle:@"Ok"
                             style:UIAlertActionStyleDestructive
                           handler:^(UIAlertAction *action) {
                               [[Settings sharedInstance] removeRatingData];
                           }];
    UIAlertAction *cancelAction =
    [UIAlertAction actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                           handler:nil];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}


@end
