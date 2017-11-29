//
//  orderVC.h
//  TanChiYu
//
//  Created by 包子 on 16/5/7.
//  Copyright © 2016年 包子. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
#import "AsyncSocket.h"
#import "goodVC.h"
#import "AppDelegate.h"
@interface orderVC : UIViewController
{AsyncSocket *askt;}
@property (weak, nonatomic) IBOutlet UITableView *tod;
@property (weak, nonatomic) IBOutlet UITextField *rt;


@end
