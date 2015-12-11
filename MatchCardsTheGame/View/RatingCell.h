//
//  RatingCell.h
//  CardGame
//
//  Created by igorbizi@mail.ru on 4/12/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
