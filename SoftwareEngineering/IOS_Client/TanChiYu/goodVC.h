//
//  goodVC.h
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
#import "AppDelegate.h"
@interface goodVC : UIViewController
{AsyncSocket *askt;}
@property (weak, nonatomic) IBOutlet UITableView *tgod;
@property (weak, nonatomic) IBOutlet UIImageView *igod;
@property (weak, nonatomic) IBOutlet UILabel *ngod;
@property (weak, nonatomic) IBOutlet UILabel *wgod;
@property (weak, nonatomic) IBOutlet UILabel *pgod;
@property (weak, nonatomic) IBOutlet UITextView *dgod;
@property (weak, nonatomic) IBOutlet UITextField *numgod;
@property (weak, nonatomic) IBOutlet UIStepper *am;
@property (weak, nonatomic) IBOutlet UIButton *bcar;
@property (weak, nonatomic) IBOutlet UIButton *bt1;
@property (weak, nonatomic) IBOutlet UIButton *bt2;
@property (weak, nonatomic) IBOutlet UIButton *bt3;
@property (weak, nonatomic) IBOutlet UIButton *btocar;

@end
