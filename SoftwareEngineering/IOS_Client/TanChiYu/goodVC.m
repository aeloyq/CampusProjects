//
//  goodVC.m
//  TanChiYu
//
//  Created by 包子 on 16/5/1.
//  Copyright © 2016年 包子. All rights reserved.
//

#import "goodVC.h"

@interface goodVC ()<UITableViewDataSource,UITableViewDelegate>
{NSString *rcv;
    AppDelegate *md;
    NSMutableArray *goodinfo;
    NSMutableArray *goodpic;
    NSMutableArray *reviewinfo;
    NSMutableArray *reviewpic;
    int reviewnum;
    int goodnum;
    int intt;
    NSMutableArray *sid;
    NSString *iscomplete;
    NSData *iscompletepic;
    NSData *rcvpic;
    NSMutableArray *tid;
    NSString *stid;
    NSString *osid;
    NSData *opic;
    NSString *otaste;
    int times;
    
    NSMutableArray *rpiccid;
}
@end

@implementation goodVC

- (void)viewDidLoad {
    [super viewDidLoad];
        stid=@"0";
    reviewinfo=[NSMutableArray arrayWithCapacity:1];
    reviewpic=[NSMutableArray arrayWithCapacity:1];
    reviewnum=0;
    _numgod.keyboardType=UIKeyboardTypeNumberPad;
    md=[[UIApplication sharedApplication] delegate];
    goodnum=0;
    goodinfo=[NSMutableArray arrayWithCapacity:1];
    goodpic=[NSMutableArray arrayWithCapacity:1];
    sid=[NSMutableArray arrayWithCapacity:1];
    tid=[NSMutableArray arrayWithCapacity:1];
    rpiccid=[NSMutableArray arrayWithCapacity:1];
    otaste=@"";
    osid=md.skid;
    times=0;
    [self initvw];
    // Do any additional setup after loading the view.
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initvw
{
    NSString *send2s=@"detailgoodinfo;";
    send2s=[send2s stringByAppendingString:md.skid];
    [self send:send2s whattag:0];
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dlyinit) userInfo:nil repeats:NO];
}

-(void)send:(NSString *)sendmsg whattag:(int)tags{
    rcv=@"err";
    rcvpic=[[NSData alloc]init];
    iscomplete=@"";
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
            [self.navigationController popViewControllerAnimated:YES];
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
        else if([iscomplete isEqualToString:rcv]&&intt<3)
        {
            intt++;
            [askt readDataWithTimeout:1 tag:0];
            [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dlyinit) userInfo:nil repeats:NO];
            return;
        }
        else if([iscomplete isEqualToString:rcv]&&intt>=3)
        {
            NSArray *rginfo=[rcv componentsSeparatedByString:@";"];
            for (int i=0;i<4;i++)
            {
            [goodinfo addObject:[rginfo objectAtIndex:i]];
            }
            _ngod.text=[@"零食名：" stringByAppendingString:[goodinfo objectAtIndex:0]];
            _dgod.text=[@"详细介绍：\n          " stringByAppendingString:[goodinfo objectAtIndex:1]];
            _pgod.text=[@"价格（元）：" stringByAppendingString:[goodinfo objectAtIndex:3]];
            _wgod.text=[@"重量（g）：" stringByAppendingString:[goodinfo objectAtIndex:2]];
            
            
                NSString *send2s=@"goodpic;";
                send2s=[send2s stringByAppendingString:md.skid];
                intt=0;
                [self send:send2s whattag:5];
                [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dlyinitpic) userInfo:nil repeats:NO];
            NSString *numb=[rginfo objectAtIndex:4];
            goodnum=[numb intValue];
            
            if(goodnum>=1)
            {
                NSArray *rgif=[[rginfo objectAtIndex:5] componentsSeparatedByString:@"#"];
                _bt1.hidden=false;
                [_bt1 setTitle:[rgif objectAtIndex:0] forState:UIControlStateNormal];
                _bt1.backgroundColor=[UIColor yellowColor];
                stid=@"1";
                NSString *rg=[rgif objectAtIndex:0];
                rg=[rg stringByAppendingString:@"#"];
                rg=[rg stringByAppendingString:stid];
                otaste=rg;
            }
            if(goodnum>=2)
            {
                NSArray *rgif=[[rginfo objectAtIndex:6] componentsSeparatedByString:@"#"];
                _bt2.hidden=false;
                [_bt2 setTitle:[rgif objectAtIndex:0] forState:UIControlStateNormal];
            }
            if(goodnum==3)
            {
                NSArray *rgif=[[rginfo objectAtIndex:7] componentsSeparatedByString:@"#"];
                _bt3.hidden=false;
                [_bt3 setTitle:[rgif objectAtIndex:0] forState:UIControlStateNormal];
            }
            _bcar.enabled=true;
        }
        
    }
    
    
    
}

- (void)dlyinitpic{
    if (iscompletepic!=rcvpic)
    {
        iscompletepic=rcvpic;
        intt=0;
        [askt readDataWithTimeout:1 tag:5];
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dlyinitpic) userInfo:nil repeats:NO];
        return;
    }
    else if(iscompletepic==rcvpic&&intt<3)
    {
        intt++;
        [askt readDataWithTimeout:1 tag:5];
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dlyinitpic) userInfo:nil repeats:NO];
        return;
    }
    else if(iscompletepic==rcvpic&&intt>=3)
    {
        _igod.image=[UIImage imageWithData:rcvpic];
        opic=rcvpic;
        NSString *send2s=@"goodreview;";
        send2s=[send2s stringByAppendingString:md.skid];
        intt=0;
        [self send:send2s whattag:0];
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dlyinitreview) userInfo:nil repeats:NO];
    }
    
}
- (void)dlyinitreview{
    if ([rcv isEqualToString:@"err"])
    {
        if (intt>=25)
        {  [reviewinfo addObject:@"系统：#网络不畅，无法显示"];
            reviewnum++;
            [_tgod reloadData];
            return;
        }
        else
        {
            intt++;
            [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dlyinitreview) userInfo:nil repeats:NO];
            return;
        }
    }
    else
    {
        if (![iscomplete isEqualToString:rcv])
        {
            iscomplete=rcv;
            intt=0;
            [askt readDataWithTimeout:1 tag:0];
            [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dlyinitreview) userInfo:nil repeats:NO];
            return;
        }
        else if([iscomplete isEqualToString:rcv]&&intt<2)
        {
            intt++;
            [askt readDataWithTimeout:1 tag:0];
            [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dlyinitreview) userInfo:nil repeats:NO];
            return;
        }
        else if([iscomplete isEqualToString:rcv]&&intt>=2)
        {
            NSArray *rginfo=[rcv componentsSeparatedByString:@";"];
            reviewnum=[[rginfo objectAtIndex:0] intValue];
            for (int i=1;i<=reviewnum;i++)
            {
                [reviewinfo addObject:[rginfo objectAtIndex:i]];
                NSString *xx=[rginfo objectAtIndex:i];
                NSArray *rgg=[xx componentsSeparatedByString:@"#"];
                
                [rpiccid addObject:[rgg objectAtIndex:2]];
            }
            
            [_tgod reloadData];
            
            if(reviewnum==0)
            {
                [reviewinfo addObject:@"系统：#该零食暂无评论 欢迎品尝并给与评价 谢谢！"];
                reviewnum++;
                [_tgod reloadData];
                
                return;
            }
            
            NSString *send2s=@"infopic;";
            send2s=[send2s stringByAppendingString:[rpiccid objectAtIndex:times]];
            [self send:send2s whattag:5];
            [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dlyinitreviewpic) userInfo:nil repeats:NO];
            
           
        }
        
    }
    
}
- (void)dlyinitreviewpic{
    if (iscompletepic!=rcvpic)
    {
        iscompletepic=rcvpic;
        intt=0;
        [askt readDataWithTimeout:1 tag:5];
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dlyinitreviewpic) userInfo:nil repeats:NO];
        return;
    }
    else if(iscompletepic==rcvpic&&intt<5)
    {
        intt++;
        [askt readDataWithTimeout:1 tag:5];
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dlyinitreviewpic) userInfo:nil repeats:NO];
        return;
    }
    else if(iscompletepic==rcvpic&&intt>=5)
    {
        [reviewpic addObject:rcvpic];
        [_tgod reloadData];
        times++;
        if (times<reviewnum)
        {
        NSString *send2s=@"infopic;";
        send2s=[send2s stringByAppendingString:[rpiccid objectAtIndex:times]];
        [self send:send2s whattag:5];
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dlyinitreviewpic) userInfo:nil repeats:NO];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return reviewnum;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            return @"评论区：";
            break;
            
        default:
            return @"请选择商品";
            break;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"godcellre"];
    NSArray *rg;
    switch (indexPath.section) {
        case 0:
        {
            rg=[[reviewinfo objectAtIndex:indexPath.row]componentsSeparatedByString:@"#"];
            cell.textLabel.text=[rg objectAtIndex:0];
            NSString *gdetail=[rg objectAtIndex:1];
            if (gdetail.length>17)
            {gdetail=[gdetail substringToIndex:17];
                gdetail=[gdetail stringByAppendingString:@"..."];}
            cell.detailTextLabel.text=gdetail;
            @try {
                NSData *rgpic=[reviewpic objectAtIndex:indexPath.row];
                if (rgpic.length!=0)
                {
                    cell.imageView.image=[UIImage imageWithData:rgpic];
                }
                else{cell.imageView.image=[UIImage imageNamed:@"icon.png"];}
            }
            @catch (NSException *exception) {
                cell.imageView.image=[UIImage imageNamed:@"icon.png"];
                
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    
}

- (IBAction)bamatn:(id)sender {
    double a=_am.value;
    int b=a;
    _numgod.text=[NSString stringWithFormat:@"%d",b];;
}
- (IBAction)tover:(id)sender {
    [sender resignFirstResponder];
    _am.value=[_ngod.text doubleValue];
}
- (IBAction)btap:(id)sender {
    [_numgod resignFirstResponder];
}
- (IBAction)bt1c:(id)sender {
    _bt1.backgroundColor=[UIColor yellowColor];
    _bt2.backgroundColor=[UIColor whiteColor];
    _bt3.backgroundColor=[UIColor whiteColor];
    stid=@"1";
    NSString *rg=_bt1.titleLabel.text;
    rg=[rg stringByAppendingString:@"#"];
    rg=[rg stringByAppendingString:stid];
    otaste=rg;
}
- (IBAction)bt2c:(id)sender {
    _bt2.backgroundColor=[UIColor yellowColor];
    _bt1.backgroundColor=[UIColor whiteColor];
    _bt3.backgroundColor=[UIColor whiteColor];
    stid=@"2";
    NSString *rg=_bt2.titleLabel.text;
    rg=[rg stringByAppendingString:@"#"];
    rg=[rg stringByAppendingString:stid];
    otaste=rg;
}
- (IBAction)bt3c:(id)sender {
    _bt3.backgroundColor=[UIColor yellowColor];
    _bt2.backgroundColor=[UIColor whiteColor];
    _bt1.backgroundColor=[UIColor whiteColor];
    stid=@"3";
    NSString *rg=_bt3.titleLabel.text;
    rg=[rg stringByAppendingString:@"#"];
    rg=[rg stringByAppendingString:stid];
    otaste=rg;
    
}
- (IBAction)bcarc:(id)sender {
    bool isex=false;
    
    for(int i=0;i<[md.cargood count];i++)
    {
    if ([osid isEqualToString:[md.carsid objectAtIndex:i]]&&[otaste isEqualToString:[md.cartaste objectAtIndex:i]])
    {
        isex=true;
        int sum=0;
        int n=_am.value;
        sum=[[md.carnum objectAtIndex:i] intValue]+n;
        [md.carnum replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",sum]];
        break;
    }
    }
    if(!isex)
    {
        [md.cargood addObject:[goodinfo objectAtIndex:0]];
        int n=_am.value;
        [md.carnum addObject:[NSString stringWithFormat:@"%d",n]];
        [md.carsid addObject:osid];
        [md.carpic addObject:opic];
        [md.cartaste addObject:otaste];
        [md.carsingleprice addObject:[goodinfo objectAtIndex:3]];
        
    }
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
    
    _bt1.backgroundColor=[UIColor yellowColor];
    _bt2.backgroundColor=[UIColor whiteColor];
    _bt3.backgroundColor=[UIColor whiteColor];
    stid=@"1";
    _numgod.text=@"1";
    _am.value=1;
    
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
