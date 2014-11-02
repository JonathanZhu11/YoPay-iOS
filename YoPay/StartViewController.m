//
//  StartViewController.m
//  YoPay
//
//  Created by Jonathan Zhu on 11/1/14.
//  Copyright (c) 2014 com.YoPay. All rights reserved.
//

#import "StartViewController.h"
#import "NameListViewController.h"

@interface StartViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startButton;
- (IBAction)pressStart:(id)sender;
-(IBAction)textFieldReturn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@end

@implementation StartViewController
BOOL allOK = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.usernameField isFirstResponder] && [touch view] != self.usernameField) {
        [self.usernameField resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)pressStart:(id)sender {
    
    NSString *server = @"yopay.herokuapp.com";
    NSString *username = [[self.usernameField text] uppercaseString];
    
    if(![username isEqualToString:@""]) {
        
        [[self errorLabel] setHidden:YES];
        
        NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://%@/users/%@" ,server, username]]];
        NSURLResponse * response = nil;
        NSError * error = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                              returningResponse:&response
                                                          error:&error];
        
        if (error == nil)
        {
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            
            if([jsonDictionary count] == 0) {
                allOK = YES;
                [self performSegueWithIdentifier:@"StartToListSegue" sender:self];
            } else {
                
                NSString *url = [jsonDictionary objectForKey:@"url"];
                [[self errorLabel] setText:@"Send a Yo to YOPAYMAN to set up an account!"];
                [[self errorLabel] setHidden:NO];
            }
            
            NSLog(@"%@", [jsonDictionary objectForKey:@"url"]);
        }
        
    } else {
        allOK = NO;
        [[self errorLabel] setHidden:NO];
        
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if(allOK) {
        return YES;
    }
    return NO;
}


@end
