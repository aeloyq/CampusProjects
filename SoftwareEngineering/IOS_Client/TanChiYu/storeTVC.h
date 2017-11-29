//
//  storeTVC.h
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
#import "goodVC.h"
#import "AppDelegate.h"
#import "ctvc.h"
#import "storecell2.h"

@interface storeTVC : UITableViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{AsyncSocket *askt;}
@property (weak, nonatomic) IBOutlet UIButton *nlbtn;
@property (strong, nonatomic) IBOutlet UITableView *tgod;
@property (weak, nonatomic) IBOutlet UIImageView *cim;
@property (weak, nonatomic) IBOutlet UILabel *cl1;
@property (weak, nonatomic) IBOutlet UILabel *cl2;
@property (weak, nonatomic) IBOutlet UIButton *btocar;
@property (weak, nonatomic) IBOutlet UISearchBar *tsb;


@end
