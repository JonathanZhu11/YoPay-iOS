//
//  NameListViewController.h
//  YoPay
//
//  Created by Jonathan Zhu on 11/1/14.
//  Copyright (c) 2014 com.YoPay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRWebSocket.h"


@interface NameListViewController : UIViewController <SRWebSocketDelegate, UITableViewDelegate, UITableViewDataSource>

@end
