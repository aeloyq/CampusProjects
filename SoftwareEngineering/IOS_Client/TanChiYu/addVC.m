//
//  addVC.m
//  TanChiYu
//
//  Created by 包子 on 16/5/7.
//  Copyright © 2016年 包子. All rights reserved.
//

#import "addVC.h"
#import "customerVC.h"
@interface addVC ()
{NSString *rcv;
    AppDelegate *md;}

@end

@implementation addVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    md=[[UIApplication sharedApplication] delegate];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tsn:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)tsh:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)tq:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)tdt:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)badd:(id)sender {
    if(_tshen.text.length==0||_tshi.text.length==0||_tqu.text.length==0||_tdetail.text.length==0)
    {
        UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不能留空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [mBoxView show];
    }
    else
    {
        
        [_ev setHidden:false];
        NSString *send2s=@"addadd;";
        send2s=[send2s stringByAppendingString:md.state];
        send2s=[send2s stringByAppendingString:@";"];
        send2s=[send2s stringByAppendingString:_tshen.text];
        send2s=[send2s stringByAppendingString:@";"];
        send2s=[send2s stringByAppendingString:_tshi.text];
        send2s=[send2s stringByAppendingString:@";"];
        send2s=[send2s stringByAppendingString:_tqu.text];
        send2s=[send2s stringByAppendingString:@";"];
        send2s=[send2s stringByAppendingString:_tdetail.text];
        [self send:send2s];
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
    }
    
    
}
- (IBAction)brtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btap:(id)sender {
    [_tshen resignFirstResponder];
    [_tshi resignFirstResponder];
    [_tqu resignFirstResponder];
    [_tdetail resignFirstResponder];
    
}
-(void)send:(NSString *)sendmsg{
    rcv=@"err";
    askt=[[AsyncSocket alloc]initWithDelegate:self];
    NSError *err=nil;
    AppDelegate *md=[[UIApplication sharedApplication] delegate];
    int port=[md.port intValue];
    if([askt connectToHost:md.ipadrs onPort:port error:&err])
    {
        NSData *xmldata=[sendmsg dataUsingEncoding:NSUTF8StringEncoding];
        [askt writeData:xmldata withTimeout:-1 tag:0];
        NSData *rdata;
        NSString* astr;
        [askt readDataWithTimeout:1 tag:0];
        astr=[[NSString alloc] initWithData:rdata encoding:NSUTF8StringEncoding];    }
    else{
        rcv=@"err";
        
    }
}
- (void)delayMethod{
    
    if ([rcv isEqualToString:@"err"] ||[rcv isEqualToString:@"nerr"] )
    {
        if ([rcv isEqualToString:@"err"] )
        {
            UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [mBoxView show];
        }
        if([rcv isEqualToString:@"nerr"])
        {
            UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未知" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [mBoxView show];
        }
    }
    else
    {
        UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"添加成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [mBoxView show];
        [self dismissViewControllerAnimated:YES completion:nil];
        md.isadd=@"yes";
    }
    [_ev setHidden:true];
}
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString * sting =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    rcv=sting;}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
