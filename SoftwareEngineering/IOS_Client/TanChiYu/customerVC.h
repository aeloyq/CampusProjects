//
//  customerVC.h
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
#import "UNC.h"
#import "AppDelegate.h"
#import "addVC.h"
@interface customerVC : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{AsyncSocket *askt;}
-(IBAction)chooseImage:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *breturn;
@property (weak, nonatomic) IBOutlet UIButton *bchgpwd;
@property (weak, nonatomic) IBOutlet UILabel *lusername;
@property (weak, nonatomic) IBOutlet UILabel *lname;
@property (weak, nonatomic) IBOutlet UILabel *ltel;
@property (weak, nonatomic) IBOutlet UIButton *bpic;
@property (weak, nonatomic) IBOutlet UIImageView *ipic;
@property (weak, nonatomic) IBOutlet UILabel *lpwd_ps;
@property (weak, nonatomic) IBOutlet UITextField *tpwd_ps;
@property (weak, nonatomic) IBOutlet UILabel *lpwd_new;
@property (weak, nonatomic) IBOutlet UITextField *tpwd_new;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *ev;
@property (weak, nonatomic) IBOutlet UITextField *tchguname;
@property (weak, nonatomic) IBOutlet UIButton *bchguname;
@property (weak, nonatomic) IBOutlet UITextField *tchgnm;
@property (weak, nonatomic) IBOutlet UIButton *bchgnm;
@property (weak, nonatomic) IBOutlet UITextField *tchgtel;
@property (weak, nonatomic) IBOutlet UIButton *bchgtel;
@property (weak, nonatomic) IBOutlet UITableView *tbad;
@property (weak, nonatomic) IBOutlet UILabel *tbod;
@property (weak, nonatomic) IBOutlet UITableView *tbodr;

@property(nonatomic,retain) NSTimer *trevpic;
@property (weak, nonatomic) IBOutlet UIButton *wthod;


@end
