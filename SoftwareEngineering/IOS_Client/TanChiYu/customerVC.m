//
//  customerVC.m
//  TanChiYu
//
//  Created by 包子 on 16/5/1.
//  Copyright © 2016年 包子. All rights reserved.
//

#import "customerVC.h"


@interface customerVC ()<UITableViewDataSource,UITableViewDelegate>
{NSString *rcv;
    NSData *rcvpic;
    bool isFullScreen;
    NSData *iscomplete;
    long rvn;
    long num;
    long intt;
    NSString *daddl;
    NSString *edaddl;
    NSMutableArray *addl;
    NSString *aid;
    UIImage *im;
    int addtway;
    int deladdi;
    UIActivityIndicatorView* activityIndicatorView;
}
@end

@implementation customerVC


-(void)viewDidAppear:(BOOL)animated
{
    AppDelegate *md=[[UIApplication sharedApplication] delegate];
    if([md.isadd isEqualToString:@"yes"])
    {
        rvn=0;
        intt=0;
        md.isadd=@"no";
        [self initvw];
    }
    
}
- (void)viewDidLoad {
    [_tpwd_ps setSecureTextEntry:YES];
    _tpwd_ps.keyboardType=UIKeyboardTypeNamePhonePad;
    [_tpwd_new setSecureTextEntry:YES];
    _tpwd_new.keyboardType=UIKeyboardTypeNamePhonePad;
    rvn=0;
    intt=0;
    [self initvw];
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
-(void)initvw
{
    intt=0;
    [_ev setHidden:false];
    NSString *send2s=@"info;";
    AppDelegate *md=[[UIApplication sharedApplication] delegate];
    send2s=[send2s stringByAppendingString:md.state];
    [self send:send2s whattag:2];
    [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dlyinit) userInfo:nil repeats:NO];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{return 3;}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return num;
            break;
        case 2:
            return 1;
            break;
            
        default:
            return 1;
            break;
    }
    return 1;
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            return @"默认地址";
            break;
        case 1:
            return @"所有地址";
            break;
        case 2:
            return @"操作";
            break;
            
        default:
            return @"所有地址";
            break;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"adbcell"];
    NSString *rgg;
    NSArray *rg;
    switch (indexPath.section) {
        case 0:
            rg=[daddl componentsSeparatedByString:@"#"];
            cell.textLabel.text=[rg objectAtIndex:0];
            return cell;
            break;
            case 1:
            rgg=[addl objectAtIndex:indexPath.row];
            rg=[rgg componentsSeparatedByString:@"#"];
            cell.textLabel.text=[rg objectAtIndex:0];
            return cell;
            
        case 2:
            cell.textLabel.text=@"                                   增加地址";
            return cell;
            break;

        default:
            cell.textLabel.text=[addl objectAtIndex:indexPath.row];
            return cell;
            break;
    }
    
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIActionSheet *sheet;
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    addVC *mvc =[storyboard instantiateViewControllerWithIdentifier:@"addaddvc"];
    NSArray *rg;
    
    switch (indexPath.section) {
            
        case 0:
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];

            break;
        case 1:
            aid=[addl objectAtIndex:indexPath.row];
            rg=[aid componentsSeparatedByString:@"#"];
            aid=[rg objectAtIndex:1];
            sheet  = [[UIActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"设为默认",@"删除地址", nil];
            sheet.tag = 254;
            [sheet showInView:self.view];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            edaddl=[addl objectAtIndex:indexPath.row];
            deladdi=indexPath.row;
            break;

         case 2:
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            mvc.modalPresentationStyle=UIModalPresentationFullScreen;
            mvc.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
            [self presentViewController:mvc animated:YES completion:nil];
            
            break;
        default:
            sheet  = [[UIActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"设为默认",@"删除地址", nil];
            sheet.tag = 254;
            [sheet showInView:self.view];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];

            break;
        
            
    }
    }

- (IBAction)keybordclose:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)kbc2:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)kbc3:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)kbc4:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)kbc5:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)bchg1:(id)sender {
    if(_tchguname.hidden)
    {
        _tchguname.text=@"";
        _tchguname.hidden=false;
        [_bchguname setTitle:@"确认" forState:UIControlStateNormal];
        [_tchguname becomeFirstResponder];
    }
    else
    {
        _tchguname.hidden=true;
        [_bchguname setTitle:@"修改" forState:UIControlStateNormal];
        [_tchguname resignFirstResponder];
        if(_tchguname.text.length!=0)
        {
        NSString *send2c;
        send2c=@"change;uname;";
        AppDelegate *md=[[UIApplication sharedApplication] delegate];
        send2c=[send2c stringByAppendingString:md.state];
        send2c=[send2c stringByAppendingString:@";"];
        send2c=[send2c stringByAppendingString:_tchguname.text];
        [self send:send2c whattag:3];
        activityIndicatorView = [ [ UIActivityIndicatorView alloc ]
                                                          initWithFrame:CGRectMake(157.0,318.0,100.0,100.0)];
        activityIndicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleWhiteLarge;
            activityIndicatorView.backgroundColor=[UIColor yellowColor];
            activityIndicatorView.color=[UIColor blueColor];
        [activityIndicatorView startAnimating];
        [self.view addSubview:activityIndicatorView];
        [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(dlyedit) userInfo:nil repeats:NO];
        }
        else{
            UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不可为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [mBoxView show];
            
        }
    }
}
- (IBAction)bchg2:(id)sender {
    if(_tchgnm.hidden)
    {
        _tchgnm.text=@"";
        _tchgnm.hidden=false;
        [_bchgnm setTitle:@"确认" forState:UIControlStateNormal];
        [_tchgnm becomeFirstResponder];
    }
    else
    {
        _tchgnm.hidden=true;
        [_bchgnm setTitle:@"修改" forState:UIControlStateNormal];
        [_tchgnm resignFirstResponder];
        if(_tchgnm.text.length!=0)
        {
        NSString *send2c;
        send2c=@"change;name;";
        AppDelegate *md=[[UIApplication sharedApplication] delegate];
        send2c=[send2c stringByAppendingString:md.state];
        send2c=[send2c stringByAppendingString:@";"];
        send2c=[send2c stringByAppendingString:_tchgnm.text];
        [self send:send2c whattag:3];
        activityIndicatorView = [ [ UIActivityIndicatorView alloc ]
                                 initWithFrame:CGRectMake(157.0,318.0,100.0,100.0)];
        activityIndicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleWhiteLarge;
        activityIndicatorView.backgroundColor=[UIColor yellowColor];
        activityIndicatorView.color=[UIColor blueColor];
        [activityIndicatorView startAnimating];
        [self.view addSubview:activityIndicatorView];
        [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(dlyedit) userInfo:nil repeats:NO];
        }
        else{
            UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不可为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [mBoxView show];
        }
    }
}

- (IBAction)bchg3:(id)sender {
    if(_tchgtel.hidden)
    {
        _tchgtel.text=@"";
        _tchgtel.hidden=false;
        [_bchgtel setTitle:@"确认" forState:UIControlStateNormal];
        [_tchgtel becomeFirstResponder];
    }
    else
    {
        _tchgtel.hidden=true;
        [_bchgtel setTitle:@"修改" forState:UIControlStateNormal];
        [_tchgtel resignFirstResponder];
        if(_tchgtel.text.length!=0)
        {
        NSString *send2c;
        send2c=@"change;tel;";
        AppDelegate *md=[[UIApplication sharedApplication] delegate];
        send2c=[send2c stringByAppendingString:md.state];
        send2c=[send2c stringByAppendingString:@";"];
        send2c=[send2c stringByAppendingString:_tchgtel.text];
        [self send:send2c whattag:3];
        activityIndicatorView = [ [ UIActivityIndicatorView alloc ]
                                 initWithFrame:CGRectMake(157.0,318.0,100.0,100.0)];
        activityIndicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleWhiteLarge;
            activityIndicatorView.backgroundColor=[UIColor yellowColor];
            activityIndicatorView.color=[UIColor blueColor];
        [activityIndicatorView startAnimating];
        [self.view addSubview:activityIndicatorView];
        [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(dlyedit) userInfo:nil repeats:NO];
        }
        else{
            UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不可为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
              [mBoxView show];
        }
        
    }
}
- (IBAction)pwdchg:(id)sender {
    if(_tpwd_ps.hidden)
    {
        _tpwd_ps.text=@"";
        _tpwd_ps.hidden=false;
        _tpwd_new.text=@"";
        _tpwd_new.hidden=false;
        _lpwd_ps.hidden=false;
        _lpwd_new.hidden=false;
        [_bchgpwd setTitle:@"确认修改" forState:UIControlStateNormal];
        [_tpwd_ps becomeFirstResponder];
    }
    else
    {
        _tpwd_ps.hidden=true;
        _tpwd_new.hidden=true;
        _lpwd_ps.hidden=true;
        _lpwd_new.hidden=true;
        [_bchgpwd setTitle:@"修改密码" forState:UIControlStateNormal];
        [_tpwd_ps resignFirstResponder];
        [_tpwd_new resignFirstResponder];
        if(_tpwd_new.text.length!=0)
        {
        NSString *send2c;
        send2c=@"change;pwd;";
        AppDelegate *md=[[UIApplication sharedApplication] delegate];
        send2c=[send2c stringByAppendingString:md.state];
        send2c=[send2c stringByAppendingString:@";"];
        send2c=[send2c stringByAppendingString:_tpwd_ps.text];
            send2c=[send2c stringByAppendingString:@";"];
            send2c=[send2c stringByAppendingString:_tpwd_new.text];
        [self send:send2c whattag:3];
        activityIndicatorView = [ [ UIActivityIndicatorView alloc ]
                                 initWithFrame:CGRectMake(157.0,318.0,100.0,100.0)];
        activityIndicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleWhiteLarge;
            activityIndicatorView.backgroundColor=[UIColor yellowColor];
            activityIndicatorView.color=[UIColor blueColor];
        [activityIndicatorView startAnimating];
        [self.view addSubview:activityIndicatorView];
        [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(dlyeditpwd) userInfo:nil repeats:NO];
        }
        else{
            UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不可为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
  [mBoxView show];
        }
    }
}
-(void)send:(NSString *)sendmsg whattag:(long)howtag{
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
        [askt readDataWithTimeout:1 tag:howtag];
        astr=[[NSString alloc] initWithData:rdata encoding:NSUTF8StringEncoding];    }
    else{
        rcv=@"err";
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)breturn_click:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dlyinit{
    
    if ([rcv isEqualToString:@"err"] ||[rcv isEqualToString:@"nerr"] )
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
            //[askt readDataWithTimeout:1 tag:2];
        [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(dlyinit) userInfo:nil repeats:NO];
        }
    }
    else
    {
        @try {
      
        NSArray *myinfo=[rcv componentsSeparatedByString:@";"];
        NSString *rgst;
        rgst=@"用户名：";
        rgst=[rgst stringByAppendingString:[myinfo objectAtIndex:1]];
        _lusername.text=rgst;
        rgst=@"姓    名：";
        rgst=[rgst stringByAppendingString:[myinfo objectAtIndex:0]];
        _lname.text =rgst;
        rgst=@"电    话：";
        rgst=[rgst stringByAppendingString:[myinfo objectAtIndex:4]];
        _ltel.text=rgst;
        if(![[myinfo objectAtIndex:5] isEqualToString:@""])
        {
            NSString *add;
            num=[[myinfo objectAtIndex:6] intValue];
            add=[myinfo objectAtIndex:7];
            for (int i=8; i<8+num-1; i++) {
                add=[add stringByAppendingString:@";"];
                add=[add stringByAppendingString:[myinfo objectAtIndex:i]];
            }
            addl= [add componentsSeparatedByString:@";"];
            daddl=[myinfo objectAtIndex:5];
            [_tbad reloadData];

        }
                rvn=0;
            
            _ev.hidden=true;
            NSString *send2s=@"infopic;";
            AppDelegate *md=[[UIApplication sharedApplication] delegate];
            send2s=[send2s stringByAppendingString:md.state];
            [self send:send2s whattag:5];
        if([[myinfo objectAtIndex:3] isEqualToString:@""])
        {
            _ev.hidden=true;
        }
        else {
            _trevpic=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dlyinitpic) userInfo:nil repeats:YES];
        }
        }
        @catch (NSException *exception) {
            if (intt>=25)
            {
            UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [mBoxView show];
            [self dismissViewControllerAnimated:YES completion:nil];
            }
            else{
            intt++;
            [askt readDataWithTimeout:1 tag:2];
            [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(dlyinit) userInfo:nil repeats:NO];
            }
          
        } @finally {
            
        }
        
    }
    
}


- (void)dlyinitpic{
    NSData *rg;
    rg=iscomplete;
    
    if([rcvpic isEqual:rg] && rvn>5)
    {
        if(rcvpic != nil)
        {
            _ipic.image=[UIImage imageWithData:rcvpic];
            [_bpic setTitle:@"" forState:UIControlStateNormal];
        }
        [_trevpic invalidate];
    }
    else
    {
        if([rcvpic isEqual:rg])
        {rvn++;}
        else{
        [askt readDataWithTimeout:1 tag:5];
        iscomplete=rcvpic;
            rvn=0;}
        
        
    }
    
}
- (void)dlyedit{
    if ([rcv isEqualToString:@"err"] ||[rcv isEqualToString:@"nerr"] )
    {
        if ([rcv isEqualToString:@"err"] )
        {
            UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [mBoxView show];
        }
        if([rcv isEqualToString:@"nerr"])
        {
            UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名重复" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [mBoxView show];
            
        }
    }
    else
    {
        UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"修改成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        NSString *rgst;
        if(_tchguname.text.length!=0)
        {
            rgst=@"用户名：";
            rgst=[rgst stringByAppendingString:_tchguname.text];
            _lusername.text=rgst;
        }
        else if(_tchgnm.text.length!=0)
        {
            rgst=@"姓    名：";
            rgst=[rgst stringByAppendingString:_tchgnm.text];
            _lname.text =rgst;
            
        }
        else if(_tchgtel.text.length!=0)
        {
            rgst=@"电    话：";
            rgst=[rgst stringByAppendingString:_tchgtel.text];
            _ltel.text=rgst;
        }
        [mBoxView show];
        
    }
    
    [activityIndicatorView stopAnimating];


}
- (void)dlyeditpwd{
    if ([rcv isEqualToString:@"err"] ||[rcv isEqualToString:@"nerr"] )
    {
        if ([rcv isEqualToString:@"err"] )
        {
            UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [mBoxView show];
        }
        if([rcv isEqualToString:@"nerr"])
        {
            UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [mBoxView show];
        }
    }
    else
    {
        UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"修改成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [mBoxView show];
        
    }
    
    [activityIndicatorView stopAnimating];
    
    
}
- (void)dlyeditadd{
    if ([rcv isEqualToString:@"err"] ||[rcv isEqualToString:@"nerr"] )
    {
        if ([rcv isEqualToString:@"err"] )
        {
            UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [mBoxView show];
        }
        if([rcv isEqualToString:@"nerr"])
        {
            UIAlertView *mBoxView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名重复" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            [mBoxView show];
            
            
        }
    }
    else
    {
        if(addtway==1)
        {
        intt=0;
            daddl=edaddl;}
        else
        {
            [addl removeObjectAtIndex:deladdi];
            num--;
        }
        [_tbad reloadData];
    }
    
    [activityIndicatorView stopAnimating];
    
    
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
    if (rcvpic.length!=0 && tag==5)
    {
        NSMutableData *p=[[NSMutableData alloc] init];
        [p appendData:rcvpic];
        [p appendData:data];
        rcvpic=p;
    }
    else if(tag==5){
        rcvpic=data;
    }
}

#pragma mark - 保存图片至沙盒

- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName

{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    
    
    [imageData writeToFile:fullPath atomically:NO];
    
}
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    // 保存图片至本地，方法见下文
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    im=image;
    
    isFullScreen = NO;
    [self.ipic setImage:savedImage];
    
    self.ipic.tag = 100;
    
    
    
    
    NSString *send2s=@"changepic;";
    AppDelegate *md=[[UIApplication sharedApplication] delegate];
    send2s=[send2s stringByAppendingString:md.state];
    send2s=[send2s stringByAppendingString:@";@@@;@@@;@@@;@@@;@@@;@@@;@@@;@@@;"];
    send2s=[send2s substringToIndex:25];
    NSMutableData *picc=[[NSMutableData alloc] init];;
    
    rcv=@"err";
    askt=[[AsyncSocket alloc]initWithDelegate:self];
    NSError *err=nil;
    int port=[md.port intValue];
    if([askt connectToHost:md.ipadrs onPort:port error:&err])
    {
        NSData *xmldata=UIImageJPEGRepresentation(im,0.01);
        NSData *xmldata2=[send2s dataUsingEncoding:NSUTF8StringEncoding];
        [picc appendData:xmldata2];
        [picc appendData:xmldata];
        [askt writeData:picc withTimeout:-1 tag:0];
        
        [askt readDataWithTimeout:1 tag:9]; }
    else{
        rcv=@"err";
    }
    
    
    
    
    
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    isFullScreen = !isFullScreen;
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self.view];
    
    CGPoint imagePoint = self.ipic.frame.origin;
    //touchPoint.x ，touchPoint.y 就是触点的坐标
    
    // 触点在imageView内，点击imageView时 放大,再次点击时缩小
    if(imagePoint.x <= touchPoint.x && imagePoint.x +self.ipic.frame.size.width >=touchPoint.x && imagePoint.y <=  touchPoint.y && imagePoint.y+self.ipic.frame.size.height >= touchPoint.y)
    {
        // 设置图片放大动画
        [UIView beginAnimations:nil context:nil];
        // 动画时间
        [UIView setAnimationDuration:1];
        
        if (isFullScreen) {
            // 放大尺寸
            
            self.ipic.frame = CGRectMake(0, 0, 320, 480);
        }
        else {
            // 缩小尺寸
            self.ipic.frame = CGRectMake(50, 65, 90, 115);
        }
        
        // commit动画
        [UIView commitAnimations];
        
    }
    
}
-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }
    if (actionSheet.tag == 254)
    {
        NSString *send2c;
        
        AppDelegate *md=[[UIApplication sharedApplication] delegate];
        switch (buttonIndex) {
            case 0:
                // 取消
                return;
            case 1:
                
                send2c=@"change;add;";
                send2c=[send2c stringByAppendingString:md.state];
                send2c=[send2c stringByAppendingString:@";"];
                
                send2c=[send2c stringByAppendingString:aid];
                [self send:send2c whattag:3];
                activityIndicatorView = [ [ UIActivityIndicatorView alloc ]
                                         initWithFrame:CGRectMake(157.0,318.0,100.0,100.0)];
                activityIndicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleWhiteLarge;
                activityIndicatorView.backgroundColor=[UIColor yellowColor];
                activityIndicatorView.color=[UIColor blueColor];
                [activityIndicatorView startAnimating];
                [self.view addSubview:activityIndicatorView];
                [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(dlyeditadd) userInfo:nil repeats:NO];
                addtway=1;
                break;
                
            case 2:
                addtway=2;
                send2c=@"deladd;";
                send2c=[send2c stringByAppendingString:md.state];
                send2c=[send2c stringByAppendingString:@";"];
                send2c=[send2c stringByAppendingString:aid];
                [self send:send2c whattag:3];
                activityIndicatorView = [ [ UIActivityIndicatorView alloc ]
                                         initWithFrame:CGRectMake(157.0,318.0,100.0,100.0)];
                activityIndicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleWhiteLarge;
                activityIndicatorView.backgroundColor=[UIColor yellowColor];
                activityIndicatorView.color=[UIColor blueColor];
                [activityIndicatorView startAnimating];
                [self.view addSubview:activityIndicatorView];
                [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(dlyeditadd) userInfo:nil repeats:NO];
                break;
        }

    
    }
}

-(IBAction)chooseImage:(id)sender
{
    
    
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
        
    }
    
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
        
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)wthod_c:(id)sender {
    
    
}

@end
