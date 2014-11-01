//
//  NameListViewController.m
//  YoPay
//
//  Created by Jonathan Zhu on 11/1/14.
//  Copyright (c) 2014 com.YoPay. All rights reserved.
//

#import "NameListViewController.h"

@interface NameListViewController ()
@property (weak, nonatomic) IBOutlet UITextField *totalPrice;
@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
- (IBAction)clickFinish:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *testButton;
- (IBAction)clickTest:(id)sender;

@end

@implementation NameListViewController 

NSMutableArray *array;

- (void)viewDidLoad {
    array =  [NSMutableArray arrayWithObjects: nil];

    [self.totalPrice addTarget:self
                  action:@selector(textFieldDidChange)
        forControlEvents:UIControlEventEditingChanged];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidChange {
    NSLog(@"I changed");
    [self.listTable reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoubleLabel"];
    
    UILabel *label;
    
    label = (UILabel *)[cell viewWithTag:11];
    label.text = [NSString stringWithFormat:@"%@", [array objectAtIndex:indexPath.row]];
    
    label = (UILabel *)[cell viewWithTag:12];
    label.text = [NSString stringWithFormat:@"%.2f", [[self.totalPrice text] doubleValue]/[array count]];
    
    return cell;
}


- (IBAction)clickFinish:(id)sender {
}
- (IBAction)clickTest:(id)sender {
    NSLog(@"YAY");
    [array addObject:@"Test"];
    [self.listTable reloadData];
}
@end
