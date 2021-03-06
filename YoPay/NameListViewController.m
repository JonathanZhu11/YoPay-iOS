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
@property (weak, nonatomic) IBOutlet UILabel *perPersonLabel;

@end

@implementation NameListViewController 

NSMutableArray *array;
NSMutableArray *colorArray;
SocketIO *socketio;
NSString *server = @"yopay.herokuapp.com";
NSURLSession *session;
NSArray *colors;

- (void)viewDidLoad {
    [self init];
    
    array =  [NSMutableArray arrayWithObjects: nil];
    colorArray =  [NSMutableArray arrayWithObjects: nil];

    [self addNew: @"YOU"];
    
    [self.totalPrice addTarget:self
                  action:@selector(textFieldDidChange)
        forControlEvents:UIControlEventEditingChanged];
    [self.finishButton setEnabled:NO];
    [super viewDidLoad];
    
}

- (instancetype)init {
    [self createColorSet];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    sessionConfig.allowsCellularAccess = true;
    sessionConfig.timeoutIntervalForRequest = 30;
    sessionConfig.timeoutIntervalForResource = 60;
    sessionConfig.HTTPMaximumConnectionsPerHost = 1;
    
    self = [super init];
    
    session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    NSLog(@"Beginning Connection");
    socketio = [[SocketIO alloc] initWithDelegate:self];
    [socketio connectToHost:server onPort: nil];

    return self;
}

- (void) createColorSet {
    UIColor *turqoise = [UIColor colorWithRed:26/255. green:188/255. blue:156/255. alpha:1];
    UIColor *emerald = [UIColor colorWithRed:46/255. green:204/255. blue:113/255. alpha:1];
    UIColor *peter = [UIColor colorWithRed:52/255. green:152/255. blue:219/255. alpha:1];
    UIColor *asphalt = [UIColor colorWithRed:52/255. green:73/255. blue:94/255. alpha:1];
    UIColor *green = [UIColor colorWithRed:22/255. green:160/255. blue:133/255. alpha:1];
    UIColor *sunflower = [UIColor colorWithRed:241/255. green:196/255. blue:15/255. alpha:1];
    UIColor *belize = [UIColor colorWithRed:41/255. green:128/255. blue:185/255. alpha:1];
    UIColor *wisteria = [UIColor colorWithRed:142/255. green:68/255. blue:173/255. alpha:1];
    UIColor *alizarin = [UIColor colorWithRed:231/255. green:76/255. blue:60/255. alpha:1];
    UIColor *amethyst = [UIColor colorWithRed:155/255. green:89/255. blue:182/255. alpha:1];
    
    colors = [[NSArray alloc] initWithObjects:turqoise, emerald, peter, asphalt, green, sunflower, belize, wisteria, alizarin, amethyst, nil];
}

- (void) socketIODidConnect:(SocketIO *)socket
{
    NSLog(@"Successful Connection");
}

// event delegate
- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    NSLog(@"didReceiveEvent >>> data: %@", packet.data);
    NSArray *array = [packet.data componentsSeparatedByString:@":"];
    NSString *name = [array lastObject];
    NSString *event = [array objectAtIndex:[array count] - 2];
    long nameLength = [name length];
    NSString * strippedName = [[name substringToIndex:nameLength-3] substringFromIndex:2];
    if ([event containsString:@"demo"])
    {
        NSLog(@"DEMO");
        [self addNew:[@"demo " stringByAppendingString:strippedName]];
    }
    else
    {
        [self addNew:strippedName];
    }
}

- (void)textFieldDidChange {
    if(![[self.totalPrice text] isEqualToString:@""] && [array count] > 1)
    {
        [self.finishButton setEnabled:YES];
    }
    else
    {
        [self.finishButton setEnabled:NO];
    }
    [self.listTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //int x = arc4random()%[colors ];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoubleLabel"];
    
    UIColor *chosenColor = [colorArray objectAtIndex:indexPath.row];
    NSLog(@"%@" , chosenColor);
    cell.backgroundColor = chosenColor;
    
    UILabel *label;
    
    label = (UILabel *)[cell viewWithTag:11];
    NSString *name = (NSString *)[array objectAtIndex:indexPath.row];
    if ([name containsString:@"demo "])
    {
        label.text = [name substringFromIndex:5];
    }
    else
    {
        label.text = [NSString stringWithFormat:@"%@", name];
    }
    
    self.perPersonLabel.text = [NSString stringWithFormat:@"$%.2f", [[self.totalPrice text] doubleValue]/[array count]];
    
    return cell;
}

- (BOOL) addNew:(NSString *)username {
    if (![[self.totalPrice text] isEqualToString:@""])
    {
        [self.finishButton setEnabled:YES];
    }
    if(![array containsObject:username] && ![array containsObject:[@"demo " stringByAppendingString:username]]) {
        [array insertObject:username atIndex:0];
        
        while(true) {
            UIColor *chosenColor = [colors objectAtIndex:rand()%7];
            if(chosenColor != [colorArray firstObject]) {
                [colorArray insertObject:chosenColor atIndex:0];
                break;
            }
        }
        
        [self.listTable reloadData];
        return true;
    }
    return false;
}


- (IBAction)clickFinish:(id)sender {
    if ([array count] == 1) return;
    if ([[self.totalPrice text] isEqualToString: @""]) return;
    [socketio disconnect];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ListToSummarySegue"]){
        SummaryViewController *controller = (SummaryViewController *)segue.destinationViewController;
        
        double price = (int)([[self.totalPrice text] doubleValue]/[array count] * 100) / 100.0;
        controller.personPrice = price;

        [array removeLastObject];
        controller.array = array;
        
        [colorArray removeLastObject];
        controller.colorArray = colorArray;
        
        if ([array count] == 0) return;
        
        NSMutableArray *demoUsers = [NSMutableArray arrayWithObjects:nil];
        NSMutableArray *fullUsers = [NSMutableArray arrayWithObjects:nil];
        
        for (int i = 0; i < [array count]; i++) {
            NSString *user = [array objectAtIndex:i];
            if ([user containsString:@"demo "])
            {
                [demoUsers addObject:[user substringFromIndex:5]];
            }
            else
            {
                [fullUsers addObject:user];
            }
        }
        
        if ([fullUsers count] > 0)
        {
            NSDictionary *body = @{@"users": fullUsers, @"amount": [NSNumber numberWithDouble:price]};
        
            NSData *bodyData = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
        
            NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://yopay.herokuapp.com/finish/%@", self.user]]];
        
            [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [urlRequest setHTTPMethod:@"POST"];
            [urlRequest setHTTPBody: bodyData];
            NSLog(@"%@", urlRequest);
            NSURLResponse * response = nil;
            NSError * error = nil;
            NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                              returningResponse:&response
                                                          error:&error];
            if (error == nil)
            {
                NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
                controller.failedUsers = jsonDictionary[@"failed_users"];
                NSLog(@"%@", jsonDictionary);
            }
        }
        
        if ([demoUsers count] > 0)
        {
            NSDictionary *body = @{@"users": demoUsers, @"amount": [NSNumber numberWithDouble:price]};
            NSData *bodyData = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
            
            NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://yopay.herokuapp.com/finish_demo/%@", self.user]]];
            
            [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [urlRequest setHTTPMethod:@"POST"];
            [urlRequest setHTTPBody: bodyData];
            NSLog(@"%@", urlRequest);
            NSURLResponse * response = nil;
            NSError * error = nil;
            NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                                  returningResponse:&response
                                                              error:&error];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.totalPrice isFirstResponder] && [touch view] != self.totalPrice) {
        [self.totalPrice resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([array count] == 1) return NO;
    if ([[self.totalPrice text] isEqualToString:@""]) return NO;
    return YES;
}
@end