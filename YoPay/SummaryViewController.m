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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoubleLabel"];
    
    UILabel *label;
    
    label = (UILabel *)[cell viewWithTag:11];
    label.text = [NSString stringWithFormat:@"%@", [self.array objectAtIndex:indexPath.row]];
    
    label = (UILabel *)[cell viewWithTag:12];
    label.text = [NSString stringWithFormat:@"%.2f", self.totalPrice/(double)[self.array count]];
    
    return cell;
}


@end
