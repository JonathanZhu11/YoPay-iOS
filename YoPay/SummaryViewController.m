//
//  SummaryViewController.m
//  YoPay
//
//  Created by Jonathan Zhu on 11/1/14.
//  Copyright (c) 2014 com.YoPay. All rights reserved.
//

#import "SummaryViewController.h"

@interface SummaryViewController ()
@property (weak, nonatomic) IBOutlet UITableView *summaryTable;

@end

@implementation SummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.array = [[NSArray alloc] initWithObjects:@"Jonathan Zhu", @"David Hao", @"Kai Yue", @"Kevin Shen", @"Your Mom", nil];

    [self.summaryTable reloadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Name"];
    
    UILabel *label;
    
    label = (UILabel *)[cell viewWithTag:11];
    label.text = [NSString stringWithFormat:@"%@", [[self.array objectAtIndex:indexPath.row] uppercaseString]];
    
    return cell;
}


@end
