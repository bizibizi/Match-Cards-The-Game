//
//  RatingViewController.m
//  MatchCardsTheGame
//
//  Created by igorbizi@mail.ru on 4/21/15.
//  Copyright (c) 2015 Igor Bizi Mineev. All rights reserved.
//

#import "RatingViewController.h"

@interface RatingViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIButton *scoreButton;
@property (weak, nonatomic) IBOutlet UIButton *gameButton;
@property (weak, nonatomic) IBOutlet UIButton *durationButton;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (nonatomic) BOOL ascending;
@end

@implementation RatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[[Settings sharedInstance] getRatingItems] mutableCopy];
    }
    return _dataSource;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dataSource = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RatingCell *cell = [tableView dequeueReusableCellWithIdentifier:kRatingCellIdentifier];
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(RatingCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    RatingItem *item = self.dataSource[indexPath.row];
    cell.scoreLabel.text = item.score;
    cell.durationLabel.text = item.duration;
    cell.dateLabel.text = item.date;
    cell.gameLabel.text = item.game;
}

- (IBAction)sortButtonAction:(UIButton *)sender
{
    NSString *key;
    if (sender == self.scoreButton) {
        key = @"score";
    } else if (sender == self.gameButton) {
        key = @"game";
    } else if (sender == self.durationButton) {
        key = @"duration";
    } else if (sender == self.dateButton) {
        key = @"date";
    }
    NSSortDescriptor *sortDesciptor = [[NSSortDescriptor alloc] initWithKey:key ascending:self.ascending];
    [self.dataSource sortUsingDescriptors:@[sortDesciptor]];
    [self.tableView reloadData];
    
    self.ascending = !self.ascending;
}




@end
