//
//  orderVC.m
//  TanChiYu
//
//  Created by 包子 on 16/5/7.
//  Copyright © 2016年 包子. All rights reserved.
//

#import "orderVC.h"

@interface orderVC ()<UITableViewDataSource,UITableViewDelegate>
{NSString *rcv;
    AppDelegate *md;
    NSMutableArray *odinfo;
    NSMutableArray *odpic;
    int odnum;
    NSMutableArray *odsnum;
    int intt;
    NSMutableArray *sid;
    NSString *iscomplete;
    NSData *iscompletepic;
    NSData *rcvpic;
    int times;
    NSArray *rginv;
    NSArray *rgginv;
    NSMutableArray *oid;
    NSMutableArray *odate;
    NSMutableArray *oad;
    NSMutableArray *ostate;
    NSMutableArray *odetl;
    NSMutableArray *sidp;
    NSString *rtxt;
    int pnum;
    int ccs;
    int setn;
    int rows;
    NSString *rsid;
    int loc;
}
@end

@implementation orderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    md=[[UIApplication sharedApplication] delegate];
    odnum=0;
    odinfo=[NSMutableArray arrayWithCapacity:1];
    odpic=[NSMutableArray arrayWithCapacity:1];
    odsnum=[NSMutableArray arrayWithCapacity:1];
    sid=[NSMutableArray arrayWithCapacity:1];
    oid=[NSMutableArray arrayWithCapacity:1];
    odate=[NSMutableArray arrayWithCapacity:1];
    oad=[NSMutableArray arrayWithCapacity:1];
    ostate=[NSMutableArray arrayWithCapacity:1];
    odetl=[NSMutableArray arrayWithCapacity:1];
    sidp=[NSMutableArray arrayWithCapacity:1];
    times=0;
    pnum=0;
[self initvw];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initvw
{
    NSString *send2s=@"orderinfo;";
    send2s=[send2s stringByAppendingString:md.state];
    [self send:send2s whattag:0];
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dlyinit) userInfo:nil repeats:NO];

}
-(void)send:(NSString *)sendmsg whattag:(int)tags{
    rcv=@"err";
    rcvpic=[[NSData alloc]init];
    askt=[[AsyncSocket alloc]initWithDelegate:self];
    NSError *err=nil;
    int port=[md.port intValue];
    if([askt connectToHost:md.ipadrs onPort:port error:&err])
    {
        NSData *xmldata=[sendmsg dataUsingEncoding:NSUTF8StringEncoding];
        [askt writeData:xmldata withTimeout:-1 tag:tags];
        NSData *rdata;
        NSString* astr;
        [askt readDataWithTimeout:1 tag:tags];
        astr=[[NSString alloc] initWithData:rdata encoding:NSUTF8StringEncoding];    }
    else{
        rcv=@"err";
        
    }
}
- (void)dlyinit{
    
    if ([rcv isEqualToString:@"err"])
    {
        if (intt>=25)
        {
            UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [mBoxView show];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            intt++;
            [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dlyinit) userInfo:nil repeats:NO];
        }
    }
    else
    {
        
        if(![iscomplete isEqualToString:rcv])
        {iscomplete=rcv;
            intt=0;
            [askt readDataWithTimeout:1 tag:0];
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dlyinit) userInfo:nil repeats:NO];
        }
        else if([iscomplete isEqualToString:rcv] && intt<2)
        {intt++;
            [askt readDataWithTimeout:1 tag:0];
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dlyinit) userInfo:nil repeats:NO];
        }
        else if([iscomplete isEqualToString:rcv] && intt>=2)
        {
        
        NSArray *rg=[rcv componentsSeparatedByString:@";"];
        for(int i=1;i<[rg count];i++)
        {
            
            [odinfo addObject:[rg objectAtIndex:i]];
            NSArray *aa=[[odinfo objectAtIndex:i-1] componentsSeparatedByString:@"#"];
            NSArray *bb=[[aa objectAtIndex:0] componentsSeparatedByString:@"@"];
            [ostate addObject:[bb objectAtIndex:2]];
            
        }
        
        
        for(int k=0;k<[[rg objectAtIndex:0] intValue];k++)
        {
        NSArray *a=[[odinfo objectAtIndex:k] componentsSeparatedByString:@"#"];
        for(int i=1;i<[a count];i++)
        {
        NSArray *b=[[a objectAtIndex:i] componentsSeparatedByString:@"@"];
            NSString *c=[b objectAtIndex:0];
            bool isex=false;
            for(int j=0;j<[sid count];j++)
            {
             if([[sid objectAtIndex:j] isEqualToString:c])
             {
                 isex=true;
             }
            }
            if(!isex)
            {
            [sid addObject:c];
            }
            
        }
        }
        odnum=[[rg objectAtIndex:0] intValue];
        [_tod reloadData];
        pnum=(int)[sid count];
        if([sid count]!=0)
        {
            NSString *send2s=@"goodpic;";
            send2s=[send2s stringByAppendingString:[sid objectAtIndex:times]];
            intt=0;
            [self send:send2s whattag:5];
            [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(delayinitpic) userInfo:nil repeats:NO];
            
        }
        }
        
    }
    
    
    
}
- (void)delayinitpic{
    if (iscompletepic!=rcvpic)
    {
        iscompletepic=rcvpic;
        intt=0;
        [askt readDataWithTimeout:1 tag:5];
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(delayinitpic) userInfo:nil repeats:NO];
        return;
    }
    else if(iscompletepic==rcvpic&&intt<2)
    {
        intt++;
        [askt readDataWithTimeout:1 tag:5];
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(delayinitpic) userInfo:nil repeats:NO];
        return;
    }
    else if(iscompletepic==rcvpic&&intt>=2)
    {
        [odpic addObject:rcvpic];
        [_tod reloadData];
        times++;
        if(times < pnum)
        {
            NSString *send2s=@"goodpic;";
            send2s=[send2s stringByAppendingString:[sid objectAtIndex:times]];
            [self send:send2s whattag:5];
            [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(delayinitpic) userInfo:nil repeats:NO];
        }
        
    }
    
}
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString * sting =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if ((![rcv isEqualToString:@"err"]&&sting.length!=0)&&tag!=5)
    {
        rcv=[rcv stringByAppendingString:sting];
    }
    else if(tag!=5){
        rcv=sting;
    }
    else if(rcvpic.length!=0&&data.length!=0&&tag==5)
    {
        NSMutableData *p=[[NSMutableData alloc] init];
        [p appendData:rcvpic];
        [p appendData:data];
        rcvpic=p;
    }
    else if(rcvpic.length==0&&data.length!=0&&tag==5)
    {
        rcvpic=data;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return odnum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *a=[[odinfo objectAtIndex:section] componentsSeparatedByString:@"#"];
   if ([ostate count]!=0)
   {
    if([[ostate objectAtIndex:section] isEqualToString:@"0"] || [[ostate objectAtIndex:section] isEqualToString:@"3"])
    { return [a count];}
   }
    return [a count]-1;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSArray *a=[[odinfo objectAtIndex:section] componentsSeparatedByString:@"#"];
    NSArray *b=[[a objectAtIndex:0] componentsSeparatedByString:@"@"];
    return [b objectAtIndex:0];
    
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSArray *a=[[odinfo objectAtIndex:section] componentsSeparatedByString:@"#"];
    NSArray *b=[[a objectAtIndex:0] componentsSeparatedByString:@"@"];
    return [b objectAtIndex:1];
    


}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *c=[[odinfo objectAtIndex:indexPath.section] componentsSeparatedByString:@"#"];
    if(indexPath.row==[c count]-1 && [[ostate objectAtIndex:indexPath.section]isEqualToString:@"0"])
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"odcancel"];
        return cell;
    }
    if(indexPath.row==[c count]-1 && [[ostate objectAtIndex:indexPath.section]isEqualToString:@"3"])
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"odr"];
        return cell;
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"odcell"];
    cell.imageView.image=[UIImage imageNamed:@"icon.png"];
    NSArray *b=[[odinfo objectAtIndex:indexPath.section] componentsSeparatedByString:@"#"];
    NSArray *a=[[b objectAtIndex:indexPath.row+1] componentsSeparatedByString:@"@"];
    cell.textLabel.text=[a objectAtIndex:1];
    cell.detailTextLabel.text=[a objectAtIndex:2];
    @try {
        int x;
        for (int i=0;i<[sid count];i++)
        {
        if ([[a objectAtIndex:0]isEqualToString:[sid objectAtIndex:i]])
        {x=i;break;}
        }
        cell.imageView.image=[UIImage imageWithData:[odpic objectAtIndex:x]];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    return cell;
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(![[ostate objectAtIndex:indexPath.section] isEqualToString:@"0"]){return;}
    NSArray *c=[[odinfo objectAtIndex:indexPath.section] componentsSeparatedByString:@"#"];
    if(indexPath.row==[c count]-1)
    {
        ccs=(int)indexPath.section;
        NSString *send2s=@"cancelod;";
        NSArray *a=[[odinfo objectAtIndex:indexPath.section] componentsSeparatedByString:@"#"];
        NSArray *b=[[a objectAtIndex:0] componentsSeparatedByString:@"@"];
        NSString *d=[b objectAtIndex:0];
        d=[d substringFromIndex:4];
        d=[d substringToIndex:6];
        send2s=[send2s stringByAppendingString:d];
        [self send:send2s whattag:0];
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dlycancel) userInfo:nil repeats:NO];
    }
    
    
    
}

- (IBAction)rbr_c:(id)sender {
    
    
    
}


-(void)dlycancel
{
    if ([rcv isEqualToString:@"err"])
    {
        if (intt>=25)
        {
            UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"失败" message:@"网络错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [mBoxView show];
            
        }
        else
        {
            intt++;
            [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dlycancel) userInfo:nil repeats:NO];
        }
    }
    else
    {
        
        [ostate replaceObjectAtIndex:ccs withObject:@"2"];
        
        [_tod reloadData];
    }
    
    

}

-(void)dlyr
{
    if ([rcv isEqualToString:@"err"])
    {
        if (intt>=25)
        {
            UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"失败" message:@"网络错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [mBoxView show];
            
        }
        else
        {
            intt++;
            [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dlyr) userInfo:nil repeats:NO];
        }
    }
    else
    {
        UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"评论成功" delegate:nil cancelButtonTitle:@"谢谢您的努力" otherButtonTitles:nil];
        [mBoxView show];
        
        
    }
    
    
    
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
  
    
    if([[ostate objectAtIndex:indexPath.section] isEqualToString:@"1"])
    {
        return  YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [ostate replaceObjectAtIndex:setn withObject:@"0"];
    [_tod reloadData];
    
    setn=(int)indexPath.section;
    rows=(int)indexPath.row;
    [ostate replaceObjectAtIndex:indexPath.section withObject:@"3"];
    [_tod reloadData];
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"评论";
}
- (IBAction)rbr:(id)sender {
    NSString *send2s=@"review;";
    send2s=[send2s stringByAppendingString:md.state];
    send2s=[send2s stringByAppendingString:@";"];
    NSArray *b=[[odinfo objectAtIndex:setn] componentsSeparatedByString:@"#"];
    NSArray *a=[[b objectAtIndex:rows+1] componentsSeparatedByString:@"@"];
    NSString *c=[a objectAtIndex:0];
    send2s=[send2s stringByAppendingString:c];
    send2s=[send2s stringByAppendingString:@";"];
    send2s=[send2s stringByAppendingString:rtxt];
    [self send:send2s whattag:0];
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dlyr) userInfo:nil repeats:NO];
    [ostate replaceObjectAtIndex:setn withObject:@"1"];
    [_tod reloadData];
}
- (IBAction)vlchged:(id)sender {
    
    [sender resignFirstResponder];
}


- (IBAction)ec:(UITextField *)sender {
    rtxt=sender.text;
}

- (IBAction)ecc:(UITextField *)sender {
    rtxt=sender.text;
}

- (IBAction)rbrr:(UITextField *)sender {
    
    CGRect frame = sender.frame;
    
    int offset = frame.origin.y + 70 - (self.view.frame.size.height - 216.0);//iPhone键盘高度216，iPad的为352
    
    
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
    [UIView setAnimationDuration:0.5f];
    
    
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    
    if(offset > 0)
        
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    
    
    [UIView commitAnimations];
}

- (IBAction)edee:(UITextField *)sender {
    rtxt=sender.text;
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}
- (IBAction)rtj:(UITextField *)sender {
    rtxt=sender.text;
    [sender resignFirstResponder];
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
