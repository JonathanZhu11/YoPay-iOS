//
//  NameListViewController.h
//  YoPay
//
//  Created by Jonathan Zhu on 11/1/14.
//  Copyright (c) 2014 com.YoPay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketIO.h"


@interface NameListViewController : UIViewController <SocketIODelegate, UITableViewDelegate, UITableViewDataSource>
@property NSString *user;
@end
