//
//  registerVC.m
//  TanChiYu
//
//  Created by 包子 on 16/5/1.
//  Copyright © 2016年 包子. All rights reserved.
//

#import "registerVC.h"

@interface registerVC ()
{NSString *rcv;
}

@end

@implementation registerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tpsw1 setSecureTextEntry:YES];
    _tpsw1.keyboardType=UIKeyboardTypeNamePhonePad;
    [_tpsw2 setSecureTextEntry:YES];
    _tpsw2.keyboardType=UIKeyboardTypeNamePhonePad;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tp1:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)tp2:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)tu:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)btap_click:(id)sender {
    [_tusername resignFirstResponder];
    [_tpsw1 resignFirstResponder];
    [_tpsw2 resignFirstResponder];
}

- (IBAction)breturn_click:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)br_click:(id)sender {
    
    if(_tusername.text.length==0)
    {
    UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [mBoxView show];
    }
    else if(![_tpsw1.text isEqual:_tpsw2.text] || _tpsw2.text.length==0)
    {
        UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"两次密码输入不匹配" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [mBoxView show];
    }
    else
    {
        [_ev setHidden:false];
        NSString *send2s=@"register;";
        send2s=[send2s stringByAppendingString:_tusername.text];
        send2s=[send2s stringByAppendingString:@";"];
        send2s=[send2s stringByAppendingString:_tpsw2.text];
        [self send:send2s];
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
    }
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
            UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名已存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [mBoxView show];
        }
    }
    else
    {
        UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注册成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [mBoxView show];
        AppDelegate *md=[[UIApplication sharedApplication] delegate];
        md.state=_tusername.text;
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            UNC *mvc =[storyboard instantiateViewControllerWithIdentifier:@"loginvc1"];
            mvc.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:mvc animated:YES completion:nil];
        
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
