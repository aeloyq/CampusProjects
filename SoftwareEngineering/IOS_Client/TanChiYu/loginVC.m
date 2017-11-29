//
//  loginVC.m
//  TanChiYu
//
//  Created by 包子 on 16/5/1.
//  Copyright © 2016年 包子. All rights reserved.
//

#import "loginVC.h"
@interface loginVC ()
{
    NSString *pwd;
    NSString *iscomplete;
}

@end

@implementation loginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tpwd setSecureTextEntry:YES];
    _tusername.keyboardType=UIKeyboardTypeNamePhonePad;
    AppDelegate *md=[[UIApplication sharedApplication] delegate];
    if([md.state isEqualToString:@"unlogin"])
    {
        return;
    }
    else
    {
        [_tusername setOpaque:false];
        [_bcustomer setHidden:false];
        [_lpwd setHidden:true];
        [_tpwd setHidden:true];
        [_blogin setTitle:@"注销" forState:UIControlStateNormal];
        [_bregister setHidden:true];
        _tusername.enabled=false;
        UIColor *color = [UIColor colorWithRed:254.0/255.0 green:1.0/255.0 blue:50.0/255.0 alpha:1];
        [_blogin setBackgroundColor:color];
        _tusername.text=md.state;
    }
    // Do any additional setup after loading the view.
}

- (IBAction)bfinish:(id)sender {
    [_tpwd resignFirstResponder];
    [_tusername resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tpwdfinish:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)tusnmfinish:(id)sender {
    [sender resignFirstResponder];
}


- (IBAction)blogin_cick:(id)sender {
    
    AppDelegate *md=[[UIApplication sharedApplication] delegate];
    if([md.state isEqual:@"unlogin"])
    {
    [_ev setHidden:false];
    NSString *send2s=@"login;";
    send2s=[send2s stringByAppendingString:_tusername.text];
    send2s=[send2s stringByAppendingString:@";"];
    send2s=[send2s stringByAppendingString:_tpwd.text];
    [self send:send2s];
       _timer=[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(delayMethod) userInfo:nil repeats:YES];
    }

else
{
    [_tusername setOpaque:true];
    [_bcustomer setHidden:true];
    [_lpwd setHidden:false];
    [_tpwd setHidden:false];
    [_blogin setTitle:@"登陆" forState:UIControlStateNormal];
    [_bregister setHidden:false];
    _tusername.enabled=true;
    UIColor *color = [UIColor colorWithRed:117.0/255.0 green:198.0/255.0 blue:255.0/255.0 alpha:1];
    _tpwd.text=@"";
    [_blogin setBackgroundColor:color];
    AppDelegate *md=[[UIApplication sharedApplication] delegate];
    md.state=@"unlogin";
    
}
}

-(void)send:(NSString *)sendmsg{
    pwd=@"err";
    iscomplete=@"err";
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
        [askt readDataWithTimeout:1 tag:3];
        astr=[[NSString alloc] initWithData:rdata encoding:NSUTF8StringEncoding];    }
    else{
        pwd=@"err";
    }
    
}
- (void)delayMethod{
    if([pwd isEqual:iscomplete])
    {
        if(pwd != nil)
        {
            [_ev setHidden:true];
            if ([pwd isEqualToString:@"err"] ||[pwd isEqualToString:@"nerr"] )
            {
                if ([pwd isEqualToString:@"err"] )
                {
                    UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [mBoxView show];
                    [mBoxView show];
                }
                if([pwd isEqualToString:@"nerr"])
                {
                    UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [mBoxView show];
                }
            }
            else
            {
                if ([pwd isEqualToString:@"1"])
                {
                    AppDelegate *md=[[UIApplication sharedApplication] delegate];
                    md.state=_tusername.text;
                    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                    UNC *mvc =[storyboard instantiateViewControllerWithIdentifier:@"UNC1"];
                    mvc.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
                    [self presentViewController:mvc animated:YES completion:nil];
                }
                else
                {
                    UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [mBoxView show];
                }
            }
        }
        
        [_timer invalidate];
    }
    else
    {
        iscomplete=pwd;
    }
    
      

}
    
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    NSString * sting =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
        pwd=sting;
    
    
    
   
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
