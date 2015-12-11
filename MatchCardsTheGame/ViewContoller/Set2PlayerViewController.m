//
//  Set2PlayerViewController.m
//  MatchCardsTheGame
//
//  Created by igorbizi@mail.ru on 4/22/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import "Set2PlayerViewController.h"

@interface Set2PlayerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *score1Label;
@property (weak, nonatomic) IBOutlet UILabel *score2Label;
@property (weak, nonatomic) IBOutlet UILabel *player1NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *player2NameLabel;

@end

@implementation Set2PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (IBAction)changeNamesAction:(UIButton *)sender
{
    UITextField *player1NameTextField;
    UITextField *player2NameTextField;
    UIAlertController *alertViewController =
    [UIAlertController alertControllerWithTitle:@"Welcome to 2 Players Set game!"
                                        message:@"Please enter players names"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [alertViewController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = self.player1NameLabel.text;
    }];
    [alertViewController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = self.player2NameLabel.text;
    }];
    player1NameTextField = alertViewController.textFields[0];
    player2NameTextField = alertViewController.textFields[1];
    UIAlertAction *okAction =
    [UIAlertAction actionWithTitle:@"Ok"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction *action) {
                               
                               if (player1NameTextField.text.length && player2NameTextField.text.length) {
                                   self.player1NameLabel.text = player1NameTextField.text;
                                   self.player2NameLabel.text = player2NameTextField.text;
                               }

                           }];
    UIAlertAction *cancelAction =
    [UIAlertAction actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDestructive
                           handler:^(UIAlertAction *action) {

                           }];
    [alertViewController addAction:okAction];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:^{
        
    }];
}

- (NSUInteger)numberOfPlayers
{
    return 2;
}

- (void)updateScore
{
    self.score1Label.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score1];
    self.score2Label.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score2];
    
    if (self.game.activePlayer == 1) {
        self.player1NameLabel.backgroundColor = [UIColor redColor];
        self.player2NameLabel.backgroundColor = [UIColor clearColor];
    } else if (self.game.activePlayer == 2) {
        self.player1NameLabel.backgroundColor = [UIColor clearColor];
        self.player2NameLabel.backgroundColor = [UIColor redColor];
    }
}

- (NSUInteger)gameIndex //abstract
{
    return 2;
}

@end
