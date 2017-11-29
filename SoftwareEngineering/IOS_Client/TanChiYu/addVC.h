//
//  addVC.h
//  TanChiYu
//
//  Created by 包子 on 16/5/7.
//  Copyright © 2016年 包子. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
#import "AsyncSocket.h"
#import "AppDelegate.h"

@interface addVC : UIViewController
{AsyncSocket *askt;}
@property (weak, nonatomic) IBOutlet UIButton *backtap;
@property (weak, nonatomic) IBOutlet UITextField *tshen;
@property (weak, nonatomic) IBOutlet UITextField *tshi;
@property (weak, nonatomic) IBOutlet UITextField *tqu;
@property (weak, nonatomic) IBOutlet UITextField *tdetail;
@property (weak, nonatomic) IBOutlet UIButton *badd;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *ev;

@end
