//
//  shoppingcarVC.m
//  TanChiYu
//
//  Created by 包子 on 16/5/1.
//  Copyright © 2016年 包子. All rights reserved.
//

#import "shoppingcarVC.h"

@interface shoppingcarVC ()<UITableViewDataSource,UITableViewDelegate>
{
    AppDelegate *md;
    int intt;
    NSString *iscomplete;
    NSData *iscompletepic;
    NSData *rcvpic;
    int onum;
    int money;
    NSString *rcv;
    NSString *send2ss;
    
}
@end

@implementation shoppingcarVC


- (void)viewDidLoad {
    [super viewDidLoad];
    md=[[UIApplication sharedApplication] delegate];
    onum=1;
    money=0;
    [self initvw];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)initvw
{
    onum=[md.cargood count];
    [_tod reloadData];
    [self sumprice];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([md.cargood count]!=0)
    {
        return onum;}
    else
    {return 1;}
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            return @"您的购物车：";
            break;
            
        default:
            return @"您的购物车：";
            break;
    }
    
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            
            return @"                                                           谢谢惠顾";
            break;
            
        default:
            return @"";
            break;
}
}
-(void)sumprice
{
    double sum=0;
    NSString *rg=@"总价格：";
    for (int i=0;i<[md.cargood count];i++)
    {
        sum =sum +[[md.carsingleprice objectAtIndex:i] doubleValue]*[[md.carnum objectAtIndex:i] doubleValue];
    }
    if([md.cargood count]!=0)
    {
        rg=[rg stringByAppendingString:[NSString stringWithFormat:@"%.2f",sum]];
        
    }
    else{rg=@"";}
    _lspr.text=rg;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
    cartvc *cell = [tableView dequeueReusableCellWithIdentifier:@"carcvc1"];
    switch (indexPath.section) {
        case 0:
        {
            if ([md.cargood count]==0)
            {
                cell.im.image=[UIImage imageNamed:@"icon.png"];
                cell.l1.hidden=true;
                cell.l2.hidden=true;
                cell.l3.hidden=true;
                cell.ct.hidden=true;
                cell.am.hidden=true;
                cell.cl1.text=@"您的购物车空空如也...";
                cell.cl2.text=@"";
                cell.lsp.hidden=true;
                cell.lt.hidden=true;
                cell.ldj.hidden=true;
            }
            else
            {
                cell.im.image=[UIImage imageWithData:[md.carpic objectAtIndex:indexPath.row]];
                cell.ct.text=[md.carnum objectAtIndex:indexPath.row];
                cell.am.value=[[md.carnum objectAtIndex:indexPath.row] doubleValue];
                cell.cl1.text=[md.cargood objectAtIndex:indexPath.row];
                cell.am.tag=indexPath.row;
                cell.ct.tag=indexPath.row;
                cell.ct.keyboardType=UIKeyboardTypeNumberPad;
                double a1=[[md.carsingleprice objectAtIndex:indexPath.row] doubleValue];
                double a2=[[md.carnum objectAtIndex:indexPath.row] doubleValue];
                double sum=a1*a2;
                cell.cl2.text=[NSString stringWithFormat:@"%.2f",sum];
                NSArray *rg=[[md.cartaste objectAtIndex:indexPath.row] componentsSeparatedByString:@"#"];
                cell.lt.text=[rg objectAtIndex:0];
                cell.lsp.text=[md.carsingleprice objectAtIndex:indexPath.row];
                
                
            }
            
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
    if([md.cargood count]!=0)
    {
    md.skid=[md.carsid objectAtIndex:indexPath.row];
    }
    else
    {md.skid=@"1";}
    
}

- (IBAction)ctcg:(UITextField *)sender {
    [md.carnum replaceObjectAtIndex:sender.tag withObject:sender.text];
    [sender resignFirstResponder];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:sender.tag inSection:0];
    [_tod reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    if ([sender.text intValue]<=0)
    {
        [md.cargood removeObjectAtIndex:indexPath.row];
        [md.carsid removeObjectAtIndex:indexPath.row];
        [md.carpic removeObjectAtIndex:indexPath.row];
        [md.carsingleprice removeObjectAtIndex:indexPath.row];
        [md.cartaste removeObjectAtIndex:indexPath.row];
        [md.carnum removeObjectAtIndex:indexPath.row];
        if([md.cargood count]!=0)
        {
            [_tod deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationFade];
        }
        else{
            [_tod reloadData];
        }
    }
    [self sumprice];
}

- (IBAction)camc:(UIStepper *)sender {
    [md.carnum replaceObjectAtIndex:sender.tag withObject:[NSString stringWithFormat:@"%.0f",sender.value]];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:sender.tag inSection:0];
    [_tod reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self sumprice];
    if (sender.value<=0)
    {
        [md.cargood removeObjectAtIndex:indexPath.row];
        [md.carsid removeObjectAtIndex:indexPath.row];
        [md.carpic removeObjectAtIndex:indexPath.row];
        [md.carsingleprice removeObjectAtIndex:indexPath.row];
        [md.cartaste removeObjectAtIndex:indexPath.row];
        [md.carnum removeObjectAtIndex:indexPath.row];
        
            [_tod reloadData];
        
    }
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [md.cargood removeObjectAtIndex:indexPath.row];
        [md.carsid removeObjectAtIndex:indexPath.row];
        [md.carpic removeObjectAtIndex:indexPath.row];
        [md.carsingleprice removeObjectAtIndex:indexPath.row];
        [md.cartaste removeObjectAtIndex:indexPath.row];
        [md.carnum removeObjectAtIndex:indexPath.row];
        
            [_tod reloadData];
        
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
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


- (IBAction)oder_c:(id)sender {
    if([md.state isEqualToString:@"unlogin"])
    {
        UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [mBoxView show];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if([md.cargood count]==0)
    {
        UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有零食在购物车中，请先选购" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [mBoxView show];
    
    }
    else
    {
        _ev.hidden=false;
        [_lwai startAnimating];
        send2ss=@"order;";
        send2ss=[send2ss stringByAppendingString:md.state];
        for(int i=0;i<[md.cargood count];i++)
        {
            send2ss=[send2ss stringByAppendingString:@";"];
            send2ss=[send2ss stringByAppendingString:[md.carsid objectAtIndex:i]];
            send2ss=[send2ss stringByAppendingString:@"#"];
            NSArray *rg=[[md.cartaste objectAtIndex:i] componentsSeparatedByString:@"#"];
            send2ss=[send2ss stringByAppendingString:[rg objectAtIndex:1]];
            send2ss=[send2ss stringByAppendingString:@"#"];
            send2ss=[send2ss stringByAppendingString:[md.carnum objectAtIndex:i]];
        }
        
        
        [self send:send2ss whattag:0];
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(dlyo) userInfo:nil repeats:NO];
    
    }
    
}
-(void)dlyo
{
    if ([rcv isEqualToString:@"err"] ||[rcv isEqualToString:@"nerr"] )
    {
        if ([rcv isEqualToString:@"err"] )
        {
            UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [mBoxView show];
        }
        if([rcv isEqualToString:@"nerr"])
        {
            UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"订单错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [mBoxView show];
        }
    }
    else
    {
        UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"下单成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [mBoxView show];
        md.cargood=[NSMutableArray arrayWithCapacity:1];
        md.cartaste=[NSMutableArray arrayWithCapacity:1];
        md.carnum=[NSMutableArray arrayWithCapacity:1];
        md.carsingleprice=[NSMutableArray arrayWithCapacity:1];
        md.carsid=[NSMutableArray arrayWithCapacity:1];
        md.carpic=[NSMutableArray arrayWithCapacity:1];
        [_tod reloadData];
        
    }
    
    [_lwai stopAnimating];
    _ev.hidden=true;

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
