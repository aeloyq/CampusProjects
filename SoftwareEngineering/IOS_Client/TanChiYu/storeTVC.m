//
//  storeTVC.m
//  TanChiYu
//
//  Created by 包子 on 16/5/1.
//  Copyright © 2016年 包子. All rights reserved.
//

#import "storeTVC.h"

@interface storeTVC ()
{NSString *rcv;
    AppDelegate *md;
    NSMutableArray *goodinfo;
    NSMutableArray *goodpic;
    int goodnum;
    int intt;
    NSMutableArray *sid;
    NSString *iscomplete;
    NSData *iscompletepic;
    NSData *rcvpic;
    int times;
    NSArray *rginv;
    NSArray *rgginv;
    int st;
    int st2;
    NSMutableArray *rows;
    NSTimer *tmr;
    UIButton *vw1;
}
@end

@implementation storeTVC

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    md=[[UIApplication sharedApplication] delegate];
    goodnum=0;
    goodinfo=[NSMutableArray arrayWithCapacity:1];
    goodpic=[NSMutableArray arrayWithCapacity:1];
    sid=[NSMutableArray arrayWithCapacity:1];
    rows=[NSMutableArray arrayWithCapacity:1];
    times=0;
    st=0;
    st2=0;
    vw1=[[UIButton alloc] initWithFrame:CGRectMake(0, 44, 414, 736)];
    [vw1 setBackgroundColor:[UIColor blackColor]];
    [vw1 setAlpha:0.5f];
    [vw1 addTarget:self action:@selector(ClickControlAction:) forControlEvents:UIControlEventTouchUpInside];
 
 
    [self initvw];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewDidAppear:(BOOL)animated
{
    NSString *rgg=@"   购物车➡️";
    rgg=[rgg stringByAppendingString:[NSString stringWithFormat:@"%lu",(unsigned long)[md.cargood count]]];
    if ([md.cargood count]!=0 )
    {
        [_btocar setTitle:rgg forState:UIControlStateNormal];
    }
    else
    {
        [_btocar setTitle:@"           购物车" forState:UIControlStateNormal];
    }
}

-(void)initvw
{
    if([md.state isEqualToString:@"unlogin"])
    {
        [_nlbtn setTitle:@"登陆                                           " forState:UIControlStateNormal];
    }
    else
    {
        [_nlbtn setTitle:@"注销                                           " forState:UIControlStateNormal];
    }
    intt=0;
    NSString *send2s=@"goodinfo;";
    NSString *stt=[NSString stringWithFormat:@"%d",st];
    
    send2s=[send2s stringByAppendingString:stt];
    send2s=[send2s stringByAppendingString:@";"];
    if(st2!=0){
        send2s=[send2s stringByAppendingString:_tsb.text];
    }
    [self send:send2s whattag:0];
    [tmr invalidate];
    tmr=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dlyinit) userInfo:nil repeats:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        if (![iscomplete isEqualToString:rcv])
        {
            iscomplete=rcv;
            intt=0;
            [askt readDataWithTimeout:1 tag:0];
            [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dlyinit) userInfo:nil repeats:NO];
            return;
        }
        else if([iscomplete isEqualToString:rcv]&&intt<5)
        {
            intt++;
            [askt readDataWithTimeout:1 tag:0];
            [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dlyinit) userInfo:nil repeats:NO];
            return;
        }
        else if([iscomplete isEqualToString:rcv]&&intt>=5)
        {
            NSArray *rginfo=[rcv componentsSeparatedByString:@";"];
            goodnum=[[rginfo objectAtIndex:0] intValue];
            for(int i=1;i<=goodnum;i++)
            {
                NSString *rgf=[rginfo objectAtIndex:i];
                [goodinfo addObject:rgf];
            }
            [_tgod reloadData];
            
            for(int i=0;i<goodnum;i++)
            {
            rginv=[[goodinfo objectAtIndex:i]componentsSeparatedByString:@"@"];
            rgginv=[[rginv objectAtIndex:3]componentsSeparatedByString:@"#"];
            [sid addObject:[rgginv objectAtIndex:1]];
            }
            if([[rginfo objectAtIndex:0] intValue]==0){return;}
                NSString *send2s=@"goodpic;";
            times=0;
                send2s=[send2s stringByAppendingString:[sid objectAtIndex:times]];
                intt=0;
                [self send:send2s whattag:5];
            [tmr invalidate];
            tmr=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(delayinitpic) userInfo:nil repeats:NO];
            
            
        }
        
    }
    
    
    
}
- (void)delayinitpic{
    if (iscompletepic!=rcvpic)
    {
        iscompletepic=rcvpic;
        intt=0;
        [askt readDataWithTimeout:1 tag:5];
        [tmr invalidate];
        tmr=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(delayinitpic) userInfo:nil repeats:NO];
        return;
    }
    else if(iscompletepic==rcvpic&&intt<1)
    {
        intt++;
        [askt readDataWithTimeout:1 tag:5];
        [tmr invalidate];
        tmr=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(delayinitpic) userInfo:nil repeats:NO];
        return;
    }
    else if(iscompletepic==rcvpic&&intt>=1)
    {
        [goodpic addObject:rcvpic];
        [_tgod reloadData];
        times++;
        if(times < goodnum)
        {
            NSString *send2s=@"goodpic;";
            send2s=[send2s stringByAppendingString:[sid objectAtIndex:times]];
            intt=0;
            [self send:send2s whattag:5];
            [tmr invalidate];
            tmr=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(delayinitpic) userInfo:nil repeats:NO];
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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return goodnum+1;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            return @"请选择商品";
            break;
            
        default:
            return @"请选择商品";
            break;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {return 60;}
    else
    {return 150;}
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
    storecell2 *cell2=[tableView dequeueReusableCellWithIdentifier:@"goodcell2"];
        cell2.b0.hidden=false;
        if(st==0)
        {
            cell2.b0.hidden=true;
            [cell2.b2 setTitle:@"价格" forState:UIControlStateNormal];
            [cell2.b1 setTitle:@"销量" forState:UIControlStateNormal];
        }
        else if(st==1)
        {
            [cell2.b2 setTitle:@"价格⬆️" forState:UIControlStateNormal];
             [cell2.b1 setTitle:@"销量" forState:UIControlStateNormal];
        }
        else if(st==2)
        {
            [cell2.b2 setTitle:@"价格⬇️" forState:UIControlStateNormal];
             [cell2.b1 setTitle:@"销量" forState:UIControlStateNormal];
        }
        else if(st==3)
        {
            [cell2.b1 setTitle:@"销量⬇️" forState:UIControlStateNormal];
            [cell2.b2 setTitle:@"价格" forState:UIControlStateNormal];
        }
        else if(st==4)
        {
            [cell2.b1 setTitle:@"销量⬆️" forState:UIControlStateNormal];
            [cell2.b2 setTitle:@"价格" forState:UIControlStateNormal];
        }
        return cell2;
    }
    
    ctvc *cell = [tableView dequeueReusableCellWithIdentifier:@"goodcell1"];
    NSArray *rgg;
    NSArray *rg;
    
    switch (indexPath.section) {
        case 0:
        {
            rg=[[goodinfo objectAtIndex:indexPath.row-1]componentsSeparatedByString:@"@"];
            cell.cl1.text=[rg objectAtIndex:0];
            rgg=[[rg objectAtIndex:3]componentsSeparatedByString:@"#"];
            NSString *gdetail=[rg objectAtIndex:1];
            if (gdetail.length>17)
            {gdetail=[gdetail substringToIndex:17];}
            gdetail=[gdetail stringByAppendingString:@"..."];
            cell.cl2.text=gdetail;
            cell.cpr.text=[[@"价格：" stringByAppendingString:[rg objectAtIndex:2]] stringByAppendingString:@"元"];
            cell.cxl.text=[@"销量：" stringByAppendingString:[rgg objectAtIndex:0]];
            @try {
                NSData *rgpic=[goodpic objectAtIndex:indexPath.row-1];
                if (rgpic.length!=0)
                {
                    cell.cim.image=[UIImage imageWithData:rgpic];
                }
                else{cell.cim.image=[UIImage imageNamed:@"icon.png"];}
            }
            @catch (NSException *exception) {
                cell.cim.image=[UIImage imageNamed:@"icon.png"];
                
            } @finally {}
            return cell;
            break;
        }
        default:
            return cell;
            break;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.row==0)
    {return;}
    md.skid=[sid objectAtIndex:indexPath.row-1];
    
    
    
    
}
- (IBAction)bxl_c:(id)sender {
    if(st==3)
    {
        st=4;
        
    }
    else
    {
        st=3;
        
    }

    goodnum=0;
    goodinfo=[NSMutableArray arrayWithCapacity:1];
    goodpic=[NSMutableArray arrayWithCapacity:1];
    sid=[NSMutableArray arrayWithCapacity:1];
    rows=[NSMutableArray arrayWithCapacity:1];
    times=0;
    
    [self initvw];
}
- (IBAction)bjg_c:(id)sender {
    if(st==1)
    {
        st=2;
        
    }
    else
    {
        st=1;
        
    }
    goodnum=0;
    goodinfo=[NSMutableArray arrayWithCapacity:1];
    goodpic=[NSMutableArray arrayWithCapacity:1];
    sid=[NSMutableArray arrayWithCapacity:1];
    rows=[NSMutableArray arrayWithCapacity:1];
    times=0;
    
    [self initvw];
}
- (IBAction)bcancel_c:(id)sender {
    st=0;
    goodnum=0;
    goodinfo=[NSMutableArray arrayWithCapacity:1];
    goodpic=[NSMutableArray arrayWithCapacity:1];
    sid=[NSMutableArray arrayWithCapacity:1];
    rows=[NSMutableArray arrayWithCapacity:1];
    times=0;
    
    [self initvw];
}
// 遮盖层




// 控制遮罩层的透明度




// UISearchBar得到焦点并开始编辑时，执行该方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.tsb setShowsCancelButton:YES animated:YES];
    return YES;
    
}

// 取消按钮被按下时，执行的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.tsb resignFirstResponder];
    [self.tsb setShowsCancelButton:NO animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if(st2!=0){st2=0;
        goodnum=0;
        goodinfo=[NSMutableArray arrayWithCapacity:1];
        goodpic=[NSMutableArray arrayWithCapacity:1];
        sid=[NSMutableArray arrayWithCapacity:1];
        rows=[NSMutableArray arrayWithCapacity:1];
        times=0;
        
        
        [self initvw];
    }
    
}

// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"---%@",searchBar.text);
    [self.tsb resignFirstResponder];// 放弃第一响应者
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    goodnum=0;
    goodinfo=[NSMutableArray arrayWithCapacity:1];
    goodpic=[NSMutableArray arrayWithCapacity:1];
    sid=[NSMutableArray arrayWithCapacity:1];
    rows=[NSMutableArray arrayWithCapacity:1];
    times=0;
    st2=1;
    
    
    [self initvw];
    
    
}

// 当搜索内容变化时，执行该方法。很有用，可以实现时实搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;{
    
}


/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
