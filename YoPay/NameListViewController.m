//
//  NameListViewController.m
//  YoPay
//
//  Created by Jonathan Zhu on 11/1/14.
//  Copyright (c) 2014 com.YoPay. All rights reserved.
//

#import "NameListViewController.h"
#import "SummaryViewController.h"
#import "SocketIOPacket.h"

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
SocketIO *socketio;
NSString *server = @"yopay.herokuapp.com";
NSURLSession *session;

- (void)viewDidLoad {
    [self init];
    
    array =  [NSMutableArray arrayWithObjects: nil];

    [self.totalPrice addTarget:self
                  action:@selector(textFieldDidChange)
        forControlEvents:UIControlEventEditingChanged];
    
    [super viewDidLoad];
    
}

- (instancetype)init {
    NSLog(@"INITTING!");
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    sessionConfig.allowsCellularAccess = true;
    sessionConfig.timeoutIntervalForRequest = 30;
    sessionConfig.timeoutIntervalForResource = 60;
    sessionConfig.HTTPMaximumConnectionsPerHost = 1;
    
    self = [super init];
    
    session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    NSLog(@"Beginning Connection");
    socketio = [[SocketIO alloc] initWithDelegate:self];
    [socketio connectToHost:server onPort: nil withParams: nil withNamespace:@"/generic"];

    return self;
}

- (void) socketIODidConnect:(SocketIO *)socket
{
    NSLog(@"WE CONNECTED!!!");
    NSLog(@"%@", socket);
}

// event delegate
- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    NSLog(@"didReceiveEvent >>> data: %@", packet.data);
    NSArray *array = [packet.data componentsSeparatedByString:@":"];
    NSLog(@"%@", [array lastObject]);
    NSString *name = [array lastObject];
    long nameLength = [name length];
    NSString * strippedName = [[name substringToIndex:nameLength-3] substringFromIndex:2];
    NSLog(@"%@", strippedName);
    [self addNew:strippedName];
}



- (void)textFieldDidChange {
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

- (BOOL) addNew:(NSString *)username {
    if(![array containsObject:username]) {
        [array insertObject:username atIndex:0];
        [self.listTable reloadData];
        return true;
    }
    return false;
}


- (IBAction)clickFinish:(id)sender {
    
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if([segue.identifier isEqualToString:@"toSummarySegue"]){
//        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
//        SummaryViewController *controller = (SummaryViewController *)navController.topViewController;
//        controller.array = array;
//        controller.totalPrice = [[self.totalPrice text] doubleValue];
//    }
//}

- (IBAction)clickTest:(id)sender {
    [self addNew:[NSString stringWithFormat:@"Test Person %ld", [array count]]];
}

@end