//
//  loginVC.h
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
@interface loginVC : UIViewController{
    AsyncSocket *askt;
}

@property (weak, nonatomic) IBOutlet UIButton *bcustomer;
@property (weak, nonatomic) IBOutlet UILabel *lpwd;
@property (weak, nonatomic) IBOutlet UILabel *lusername;
@property (weak, nonatomic) IBOutlet UITextField *tusername;
@property (weak, nonatomic) IBOutlet UITextField *tpwd;
@property (weak, nonatomic) IBOutlet UIButton *blogin;
@property (weak, nonatomic) IBOutlet UIButton *bregister;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *ev;
@property (weak, nonatomic) IBOutlet UIImageView *backtap;
@property(nonatomic,retain) NSTimer *timer;
@end
