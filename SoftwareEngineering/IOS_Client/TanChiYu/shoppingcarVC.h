//
//  shoppingcarVC.h
//  TanChiYu
//
//  Created by 包子 on 16/5/1.
//  Copyright © 2016年 包子. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
#import "AsyncSocket.h"
#import "cartvc.h"
#import "AppDelegate.h"
@interface shoppingcarVC : UIViewController
{AsyncSocket *askt;}
@property (weak, nonatomic) IBOutlet UITableView *tod;
@property (weak, nonatomic) IBOutlet UILabel *lspr;
@property (weak, nonatomic) IBOutlet UIButton *oder;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *ev;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *lwai;
@property (weak, nonatomic) IBOutlet UILabel *ldj;

@end
