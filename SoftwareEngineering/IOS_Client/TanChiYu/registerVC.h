//
//  registerVC.h
//  TanChiYu
//
//  Created by 包子 on 16/5/1.
//  Copyright © 2016年 包子. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
#import "AsyncSocket.h"
#import "UNC.h"
#import "AppDelegate.h"
@interface registerVC : UIViewController
{AsyncSocket *askt;}
@property (weak, nonatomic) IBOutlet UITextField *tusername;
@property (weak, nonatomic) IBOutlet UITextField *tpsw1;
@property (weak, nonatomic) IBOutlet UITextField *tpsw2;
@property (weak, nonatomic) IBOutlet UIButton *bregister;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *ev;
@property (weak, nonatomic) IBOutlet UIButton *breturn;
@end
