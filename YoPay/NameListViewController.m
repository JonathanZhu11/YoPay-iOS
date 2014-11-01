//
//  NameListViewController.m
//  YoPay
//
//  Created by Jonathan Zhu on 11/1/14.
//  Copyright (c) 2014 com.YoPay. All rights reserved.
//

#import "NameListViewController.h"
#import "SummaryViewController.h"
#import <SIOSocket/SIOSocket.h>

@interface NameListViewController ()
@property (weak, nonatomic) IBOutlet UITextField *totalPrice;
@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
- (IBAction)clickFinish:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *testButton;
- (IBAction)clickTest:(id)sender;

@property SIOSocket *socket;

@end

@implementation NameListViewController 

NSMutableArray *array;
SRWebSocket *socketio;
NSString *server = @"yopay.herokuapp.com";
NSURLSession *session;

- (void)viewDidLoad {
    [self init];
    
//    [SIOSocket socketWithHost: @"http://yopay.herokuapp.com" response: ^(SIOSocket *socket) {
//        self.socket = socket;
//        
//        self.socket.onConnect = ^()
//        {
//            NSLog(@"Hello! We have connected!");
//        };
//    }];
    
    array =  [NSMutableArray arrayWithObjects: nil];

    [self.totalPrice addTarget:self
                  action:@selector(textFieldDidChange)
        forControlEvents:UIControlEventEditingChanged];
    
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSLog(@"Beginning Handshake");
    [self initHandshake];
    
    return self;
}

- (void) initHandshake {
    NSString *time = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *endpoint = [NSString stringWithFormat: @"http://%@/socket.io/1?t=%@", server, time ];
    
    NSURLSessionTask *handshakeTask = [session dataTaskWithURL:[NSURL URLWithString:endpoint] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *stringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray *handshakeToken = [stringData componentsSeparatedByString:@":"];
        NSLog(@"Handshake: %@", handshakeToken);
        [self socketConnectWithToken:handshakeToken];
    }];
    
    [handshakeTask resume];
}

-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"Message: %@", message);
    
}

- (void) socketConnectWithToken: (NSArray *)token {
    NSString *time = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *string = [NSString stringWithFormat:@"ws://%@/socket.io/1/xhr-polling/%@?t=%@", server, [token firstObject], time];
    NSLog(@"URL : %@", string);
    NSURL *url = [[NSURL alloc] initWithString:string];
    NSLog(@"URL : %@", url);
    socketio = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL: url]];
    socketio.delegate = self;
    [socketio open];
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
        [array addObject:username];
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