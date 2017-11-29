//
//  AppDelegate.h
//  TanChiYu
//
//  Created by 包子 on 16/4/29.
//  Copyright © 2016年 包子. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *ipadrs;
@property (strong, nonatomic) NSString *port;
@property (strong, nonatomic) NSString *isadd;
@property (strong, nonatomic) NSString *skid;
@property (strong, nonatomic) NSString *rsid;
@property (strong, nonatomic) NSMutableArray *cargood;
@property (strong, nonatomic) NSMutableArray *cartaste;
@property (strong, nonatomic) NSMutableArray *carnum;
@property (strong, nonatomic) NSMutableArray *carsingleprice;
@property (strong, nonatomic) NSMutableArray *carsid;
@property (strong, nonatomic) NSMutableArray *carpic;
@end

