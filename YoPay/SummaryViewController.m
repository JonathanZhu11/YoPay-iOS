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
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation SummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.moneyLabel setText:[NSString stringWithFormat:@"$%.2f", self.personPrice]];

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
    cell.backgroundColor = [self.colorArray objectAtIndex:indexPath.row];
    UILabel *label;
    
    NSString *user = [self.array objectAtIndex:indexPath.row];
    label = (UILabel *)[cell viewWithTag:11];
    if ([self.failedUsers containsObject:user])
    {
        label.textColor = [UIColor colorWithRed:231/255.0f green:76/255.0f blue:60/255.0f alpha:1.0f];
    }
    else
    {
        label.textColor = [UIColor whiteColor];
    }
    
    
    label.text = [NSString stringWithFormat:@"%@", user];
    
    return cell;
}


@end
