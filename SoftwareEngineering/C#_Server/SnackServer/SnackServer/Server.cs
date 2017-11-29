using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Net.Sockets;
using System.Net;
using System.Threading;
using System.Data.SqlClient;
using System.IO;


namespace SnackServer
{
    public partial class Server : Form
    {
        public Server()
        {
            InitializeComponent();
        }
        public string[] recv = new string[10000000];
        public int index = 1;
        public string[] recv_s = new string[10000000];
        public int index_c = 1;
        public delegate void th2log(string str);
        public delegate void logcg();
        public byte[] chgim;
        public string path_log = "./log/" + System.DateTime.Now.Date.ToString().Substring(0, 10) + "--" + System.DateTime.Now.TimeOfDay.Hours.ToString() + "-" + System.DateTime.Now.TimeOfDay.Minutes.ToString() +"-"+ System.DateTime.Now.TimeOfDay.Seconds.ToString();
        private void Server_Load(object sender, EventArgs e)
        {
            sql sc = new sql("use Snack update Orders set Ostate='1' where Odate<convert(varchar(10),'" + System.DateTime.Now.AddDays(-1) + "',120) and Ostate='0';");
            sc.zx();
        }
        public void tlogchg(string str)
        {
        tlog.Text+=System.Environment.NewLine+ str;
        }
        public void log_cchg(string str)
        {
            log_c.Text += System.Environment.NewLine + str;
            log_c.Focus();
            log_c.SelectionStart = log_c.Text.Length;
        }
        public void cipchg(string str)
        {
            cip_c.Items.Add(str);
            cip_c.Text =str;
        }
        public void logmove()
        {
            tlog.Focus();
            tlog.SelectionStart = tlog.Text.Length;
            log_c.Focus();
            log_c.SelectionStart = log_c.Text.Length;
        }
        class sokect
        {
            public byte[] result = new byte[10240000];
            public static int myProt = 8885;   //端口  
            public static Socket serverSocket;
            public Server frm;
            public string server_ip="192.168.3.100";
            public int port_c ;
            public string vstr = "";
            public sokect(Server fm)
            {
                frm=fm;
                myProt =Convert.ToInt16( frm.tport.Text);
                server_ip=frm.tip.Text;
                port_c = Convert.ToInt16(frm.tport_c.Text);
            }
            public void init()
            {
                //服务器IP地址  
                IPAddress ip = IPAddress.Parse(server_ip);
                serverSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
                serverSocket.Bind(new IPEndPoint(ip, myProt));  //绑定IP地址：端口  
                serverSocket.Listen(10);    //设定最多10个排队连接请求  
                vstr = System.DateTime.Now.ToString() + System.Environment.NewLine + "启动监听" + serverSocket.LocalEndPoint.ToString() + "成功";
                Server.th2log out2log = new th2log(frm.tlogchg);
                frm.BeginInvoke(out2log,vstr);
                //通过Clientsoket发送数据  
                Thread myThread = new Thread(ListenClientConnect);
                myThread.IsBackground = true;
                myThread.Start();
            }

            /// <summary>  
            /// 监听客户端连接  
            /// </summary>  
            private void ListenClientConnect()
            {
                while (true)
                {
                   
                        Socket clientSocket = serverSocket.Accept();
                        Thread receiveThread = new Thread(new ParameterizedThreadStart(ReceiveMessage));
                        receiveThread.IsBackground = true;
                        receiveThread.Start(clientSocket);
                }
            }

            /// <summary>  
            /// 接收消息  
            /// </summary>  
            /// <param name="clientSocket"></param>  
            private void ReceiveMessage(object clientSocket)
            {
                Socket myClientSocket = (Socket)clientSocket;
                
                    try
                    {
                        //通过clientSocket接收数据  
                        int receiveNumber=0;
                        receiveNumber = myClientSocket.Receive(result);
                        byte[] rgt = new byte[600000];
                        for (int i = 0; i < receiveNumber; i++)
                        {
                            rgt[i] = result[i];
                        }
                            if (receiveNumber > 4000)
                            {
                                int nn = 0;
                                while (true)
                                {
                                    byte[] bff = new byte[4096];
                                    int bf = myClientSocket.Receive(bff);
                                    if (bf == 0&&nn>1000000) { break; }
                                    else if(bf == 0&&nn<=1000000){nn++;}
                                    receiveNumber += bf;
                                    int xx = 0;
                                    for (int i = receiveNumber - bf; i < receiveNumber; i++)
                                    {
                                        rgt[i] = bff[xx++];
                                    }
                                }
                               
                            }
                        string vrv = Encoding.UTF8.GetString(result, 0, receiveNumber);
                        if (vrv.Length < 100)
                        {
                            vstr = System.DateTime.Now.ToString() + ":接收客户端" + myClientSocket.RemoteEndPoint.ToString() + "消息" + vrv;
                        }
                        else
                        {
                            vstr = System.DateTime.Now.ToString() + ":接收客户端" + myClientSocket.RemoteEndPoint.ToString() + "消息" + "长文本（图片？）";
                          
                             Server.th2log out2log2 = new th2log(frm.tlogchg);
                            frm.BeginInvoke(out2log2, vstr);
                            vrv = Encoding.UTF8.GetString(rgt, 0, 25);
                            frm.chgim = new byte[receiveNumber - 25];
                            for (int i = 0; i < receiveNumber - 25; i++)
                            {
                               frm.chgim[i] = rgt[i+25];
                            }
                            frm.recv_s[frm.index] = vrv;
                            frm.index++;
                            string[] vcip2 = new string[2];
                            vcip2 = myClientSocket.RemoteEndPoint.ToString().Split(':');
                            Server.th2log out2cip2 = new th2log(frm.cipchg);
                            frm.BeginInvoke(out2cip2, vcip2[0]);
                            //frm.wrt2txt(frm.path_log+"___log_recv.txt", frm.tlog.Text);
                            frm.echo(myClientSocket, vrv, frm);
                
                        myClientSocket.Shutdown(SocketShutdown.Both);
                        myClientSocket.Close();
                        
                        Thread.CurrentThread.Abort();
                        return;
                        }
                            Server.th2log out2log = new th2log(frm.tlogchg);
                            frm.BeginInvoke(out2log, vstr);
                            frm.recv_s[frm.index] = vrv;
                            frm.index++;
                            string[] vcip = new string[2];
                            vcip = myClientSocket.RemoteEndPoint.ToString().Split(':');
                            Server.th2log out2cip = new th2log(frm.cipchg);
                            frm.BeginInvoke(out2cip, vcip[0]);
                            //frm.wrt2txt(frm.path_log+"___log_recv.txt", frm.tlog.Text);
                            frm.echo(myClientSocket,vrv,frm);
                    }
                    catch (Exception ex)
                    {
                    }
                        myClientSocket.Shutdown(SocketShutdown.Both);
                        myClientSocket.Close();
                        
                        Thread.CurrentThread.Abort();
                }
            
            private byte[] result_send = new byte[1024];
            public void send(IPAddress ip_c, int port = 8885, string sendMessage = "")
            {
                //设定服务器IP地址 
                port_c = port;
                Socket clientSocket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
                Server.th2log out2log = new th2log(frm.log_cchg);
                try
                {
                    clientSocket.Connect(new IPEndPoint(ip_c, port_c)); //配置服务器IP与端口  
                    vstr = System.Environment.NewLine + "连接服务器成功";
                    frm.BeginInvoke(out2log, vstr);
                }
                catch
                {
                    vstr = System.Environment.NewLine + "连接服务器失败，请按回车键退出！";
                    frm.BeginInvoke(out2log, vstr);
                    return;
                }
                //通过clientSocket接收数据  
                int receiveLength = clientSocket.Receive(result);
               vstr="接收服务器消息："+Encoding.ASCII.GetString(result,0,receiveLength);
               frm.BeginInvoke(out2log, vstr);
                //通过 clientSocket 发送数据  
                try
                {
                    clientSocket.Send(Encoding.ASCII.GetBytes(sendMessage));
                    vstr = "向服务器发送消息：" + sendMessage;
                    frm.BeginInvoke(out2log, vstr);
                    frm.recv[frm.index] = sendMessage;
                    frm.index_c++;
                }
                catch
                {

                    clientSocket.Shutdown(SocketShutdown.Both);
                    clientSocket.Close();

                }
                Thread.CurrentThread.Abort();


            }
        }//socket通信类
        private void button1_Click(object sender, EventArgs e)
        {
            sokect skt = new sokect(this);
            skt.init();
            button1.Enabled = false;
        }
        public void echo(Socket ms, string str,Server frm)
        { 
          string[] send2c=new string[10000];
          string[] revfromc = new string[10000];
          revfromc = str.Split(';');
          if (revfromc[0]== "login")
          {
              sql sc = new sql("use Snack select Cpassword from Customer where Cnickname='" + revfromc[1] + "'");
              send2c=sc.cx1();
              if (send2c[0] == null) { send2c[0] = "nerr"; }
                  send2c[0] = send2c[0].Trim();
                  if (revfromc[2] == send2c[0]) { send2c[0] = "1"; }
                  else { send2c[0] = "0"; }
                  byte[] s2c = Encoding.UTF8.GetBytes(send2c[0]);
                  ms.Send(s2c);
          }
            else if (revfromc[0]== "register")
          {
              sql sc = new sql("use Snack select count(*) from Customer where Cnickname='" + revfromc[1] + "'");
              send2c = sc.cx1();
              if (Convert.ToInt16(send2c[0])==0)
              {
                  sc = new sql("use Snack select count(*) FROM Customer;");
                  send2c = sc.cx1();
                  sc = new sql("Use Snack insert into Customer  values('" + (Convert.ToInt16(send2c[0])+1).ToString() + "','','" + revfromc[1] + "','" + revfromc[2] + "','','');");
                  sc.zx();
                  send2c[0] = "sucess";
              }
              else
              {
                  send2c[0] = "nerr";
              }
              send2c[0] = send2c[0].Trim();
              byte[] s2c = Encoding.UTF8.GetBytes(send2c[0]);
              ms.Send(s2c);
          }
          else if (revfromc[0] == "info")
          {
              sql sc = new sql("use Snack select * FROM Customer where Cnickname='"+revfromc[1]+"';",6);
              send2c = sc.cx1();
              string cid=send2c[0];
              for (int i = 2; i < 6; i++)
              {
                  send2c[1] += ";" + send2c[i];
              }
              sc = new sql("use Snack select COUNT(*) from Address where Cid='"+cid+"';",1,1);
              string[,] rg = sc.cx12();
              int num = Convert.ToInt16(rg[0,0]);
              sc = new sql("use Snack select * from Address where Cid='" + cid + "' and Ais_usual='1';",7,num);
              rg = sc.cx12();
              if (num != 0)
              {
                  for (int i = 3; i < 6; i++)
                  {
                      rg[0, 2] += " " + rg[0, i];
                  }
                  send2c[1] += ";" + rg[0, 2] + "#" + rg[0, 1] + ";" + num.ToString();
              }
              else
              {
                  send2c[1] += ";;" + num.ToString();
              }
              if (num != 0)
              {
                  sc = new sql("use Snack select * from Address where Cid='" + cid + "'", 7, num);
                  rg = sc.cx12();
                  for (int i = 0; i < num; i++)
                  {
                      for (int k = 3; k < 6; k++)
                      {
                          rg[i, 2] += " " + rg[i, k];
                      }
                      send2c[1] += ";" + rg[i, 2] + "#" + rg[i, 1];
                  }
              }
              else
              {
                  send2c[1] += ";";
              
              }

              byte[] s2c = Encoding.UTF8.GetBytes(send2c[1]);
              ms.Send(s2c);
              send2c[0] = send2c[1];
              Image image = Image.FromFile(send2c[4]);
              MemoryStream mss = new MemoryStream();
              image.Save(mss, System.Drawing.Imaging.ImageFormat.Jpeg);
              byte[] buffer = new byte[mss.Length];
              mss.Seek(0, SeekOrigin.Begin);
              mss.Read(buffer, 0, buffer.Length);
             // ms.Send(buffer);
          }
 else if (revfromc[0] == "infopic")
          {
              sql sc = new sql("use Snack select * FROM Customer where Cnickname='"+revfromc[1]+"';",6);
              send2c = sc.cx1();
              Image image = Image.FromFile(send2c[4]);
              MemoryStream mss = new MemoryStream();
              image.Save(mss, System.Drawing.Imaging.ImageFormat.Jpeg);
              byte[] buffer = new byte[mss.Length];
              mss.Seek(0, SeekOrigin.Begin);
              mss.Read(buffer, 0, buffer.Length);
              mss.Close();
              ms.Send(buffer);
              send2c[0] = "#用户图片";
          }
          else if (revfromc[0] == "deladd")
          {
             
              sql sc = new sql("use Snack select Cid FROM Customer where Cnickname='" + revfromc[1] + "';");
              string[] rg2 = sc.cx1();
              int numb = Convert.ToInt16(rg2[0]);
              sc = new sql("Use Snack update Address set Cid='"+(0-numb).ToString()+"' where Aid='"+revfromc[2]+"'");
              sc.zx();
              send2c[0] = "sucess";
              send2c[0] = send2c[0].Trim();
              byte[] s2c = Encoding.UTF8.GetBytes(send2c[0]);
              ms.Send(s2c);
          }
          else if (revfromc[0] == "addadd")
          {
              sql sc = new sql("use Snack select count(*) FROM Address;");
              string[] rg1 = sc.cx1();
              int numb = Convert.ToInt16(rg1[0]);
              numb++;
              sc = new sql("use Snack select Cid FROM Customer where Cnickname='" + revfromc[1] + "';");
              string[] rg2 = sc.cx1();
              sc = new sql("Use Snack insert into Address  values('" + rg2[0] + "','" + numb.ToString() + "','" + revfromc[2] + "','" + revfromc[3] + "','" + revfromc[4] + "','" + revfromc[5] + "','0');");
              sc.zx();
              send2c[0] = "sucess";
              send2c[0] = send2c[0].Trim();
              byte[] s2c = Encoding.UTF8.GetBytes(send2c[0]);
              ms.Send(s2c);
          }
          else if (revfromc[0] == "changepic")
          {
              sql sc = new sql("use Snack select Cid FROM Customer where Cnickname='" + revfromc[1] + "';");
              string[] rg2 = sc.cx1();
              string cid = rg2[0];
              byte[] pic = frm.chgim;
              MemoryStream mss = new MemoryStream(pic);
              Image im=Image.FromStream(mss);
              im.Save("./customer_pic/"+cid+".jpg", System.Drawing.Imaging.ImageFormat.Jpeg);
              sc = new sql("use Snack update Customer set Cpic='./customer_pic/" + cid + ".jpg' where Cid='"+cid+"'; ");
              sc.zx();
              send2c[0] = "sucess";
          }
          else if (revfromc[0] == "change")
          {
              if (revfromc[1] == "uname")
              {
                  sql sc = new sql("use Snack select * from Customer where Cnickname='" + revfromc[3] + "'");
                  string[] rg = new string[10];
                  rg[0] = "";
                  rg = sc.cx1();
                  if (rg[0] == "")
                  {
                      sc = new sql("use Snack update Customer set Cnickname='" + revfromc[3] + "' where Cnickname='" + revfromc[2] + "';");
                      sc.zx();
                      send2c[0] = "sucess";
                  }
                  else
                  {
                      send2c[0] = "nerr";
                  }
              }
              else if (revfromc[1] == "name")
              {
                  
                      sql sc = new sql("use Snack update Customer set Cname='" + revfromc[3] + "' where Cnickname='" + revfromc[2] + "';");
                      sc.zx();
                      send2c[0] = "sucess";
                  
              }
              else if (revfromc[1] == "tel")
              {
                 
                      sql sc = new sql("use Snack update Customer set Cphonenumber='" + revfromc[3] + "' where Cnickname='" + revfromc[2] + "';");
                      sc.zx();
                      send2c[0] = "sucess";
                 
              }
              else if (revfromc[1] == "pwd")
              {
                  sql sc = new sql("use Snack select Cpassword from Customer where Cnickname='" + revfromc[2] + "'");
                  string[] rg = new string[10];
                  rg[0] = "";
                  rg = sc.cx1();
                  if (rg[0] == revfromc[3])
                  {
                      sc = new sql("use Snack update Customer set Cpassword='" + revfromc[4] + "' where Cnickname='" + revfromc[2] + "';");
                      sc.zx();
                      send2c[0] = "sucess";
                  }
                  else
                  {
                      send2c[0] = "nerr";
                  }
              }
              else if (revfromc[1] == "add")
              {
                  sql sc = new sql("use Snack select Cid FROM Customer where Cnickname='" + revfromc[2] + "';");
                  string[] rg2 = sc.cx1();
                  sc = new sql("use Snack select Aid FROM Address where Ais_usual='1' and Cid='" + rg2[0] + "';");
                  string[] rg1=new string[10];
                  rg1[0]="";
                  rg1= sc.cx1();
                  if (rg1[0] != "")
                  {
                      sc = new sql("Use Snack update Address set Ais_usual='0' where Aid='" + rg1[0] + "';");
                      sc.zx();
                  }
                  sc = new sql("Use Snack update Address set Ais_usual='1' where Aid='" + revfromc[3] + "';");
                  sc.zx();
                  send2c[0] = "sucess";
                  send2c[0] = send2c[0].Trim();
                  
              }


              byte[] s2c = Encoding.UTF8.GetBytes(send2c[0]);
              ms.Send(s2c);

          }
          else if (revfromc[0] == "goodinfo")
          {
              sql sc = new sql("use Snack select count(*) from Snack where Sname like '%" + revfromc[2] + "%'");
              send2c = sc.cx1();
              string num = send2c[0].Trim();
              if (revfromc[1].Trim() == "1")
              {
                  sc = new sql("use Snack select Sname,Sdescribe,Sid,Sprice from Snack  where Sname like '%" + revfromc[2] + "%' order by Sprice asc", 4, Convert.ToInt16(num));
                  string[,] rg = new string[1000, 3];
              rg = sc.cx12();
              send2c[0] = num+";";
              for(int i=0;i<Convert.ToInt16(num);i++)
              {
                  sc = new sql("use Snack select count(*) from Orders where Sid='"+rg[i,2].Trim()+"'");
                  string[] rg2;
                  rg2 = sc.cx1();
                  string str1 = String.Format("{0:F}", Convert.ToDouble(rg[i,3]));
                  send2c[0] += rg[i, 0] + "@" + rg[i, 1] + "@" + str1 + "@" + rg2[0] + "#" + rg[i, 2] + ";";
              }
              byte[] s2c = Encoding.UTF8.GetBytes(send2c[0]);
              ms.Send(s2c);
              }
              else if (revfromc[1].Trim() == "2")
              {

                  sc = new sql("use Snack select Sname,Sdescribe,Sid,Sprice from Snack  where Sname like '%" + revfromc[2] + "%' order by Sprice desc", 4, Convert.ToInt16(num));
                 string[,] rg = new string[1000, 3];
              rg = sc.cx12();
              send2c[0] = num+";";
              for(int i=0;i<Convert.ToInt16(num);i++)
              {
                  sc = new sql("use Snack select count(*) from Orders where Sid='"+rg[i,2].Trim()+"'");
                  string[] rg2;
                  rg2 = sc.cx1();
                  string str1 = String.Format("{0:F}", Convert.ToDouble(rg[i,3]));
                  send2c[0] += rg[i, 0] + "@" + rg[i, 1] + "@" + str1 + "@" + rg2[0] + "#" + rg[i, 2] + ";";
              }
              byte[] s2c = Encoding.UTF8.GetBytes(send2c[0]);
              ms.Send(s2c);
              }
              
              else if (revfromc[1].Trim() == "3")
              {
                  sc = new sql("with t as (select top 100 percent Sid from Orders where Sid in (select Sid from Snack where Sname like '%" + revfromc[2] + "%') group by Sid) select count(*) from t;");
                  string[] numxl=sc.cx1();

                  sc = new sql("select Sid from Orders where Sid in (select Sid from Snack where Sname like '%" + revfromc[2] + "%') group by Sid order by COUNT(*) desc;", Convert.ToInt16(numxl[0]));
                  string[] rggg=sc.cx2();
                  send2c[0] = num + ";";
                  for (int k = 0; k < Convert.ToInt16(numxl[0]); k++)
                  {
                      sc = new sql("use Snack select Sname,Sdescribe,Sid,Sprice from Snack where Sid='" + rggg[k] + "'", 4);
                      string[] rg;
                      rg = sc.cx1();
                      sc = new sql("use Snack select count(*) from Orders where Sid='" + rg[2].Trim() + "'");
                      string[] rg2;
                      rg2 = sc.cx1();
                      string str1 = String.Format("{0:F}", Convert.ToDouble(rg[3]));
                      send2c[0] += rg[0] + "@" + rg[1] + "@" + str1 + "@" + rg2[0] + "#" + rg[2] + ";";
                  }
                  if (numxl[0].Trim() != num && revfromc[2].Trim() == "")
                  {
                      numxl[0] = (Convert.ToInt16(num) - Convert.ToInt16(numxl[0])).ToString();

                      sc = new sql("select Sid from Snack where Sid not in(select distinct Sid from Orders);", Convert.ToInt16(numxl[0]));
                      rggg = sc.cx2();
                      for (int k = 0; k < Convert.ToInt16(numxl[0]); k++)
                      {
                          sc = new sql("use Snack select Sname,Sdescribe,Sid,Sprice from Snack where Sid='" + rggg[k] + "'", 4);
                          string[] rg;
                          rg = sc.cx1();
                          sc = new sql("use Snack select count(*) from Orders where Sid='" + rg[2].Trim() + "'");
                          string[] rg2;
                          rg2 = sc.cx1();
                          string str1 = String.Format("{0:F}", Convert.ToDouble(rg[3]));
                          send2c[0] += rg[0] + "@" + rg[1] + "@" + str1 + "@" + rg2[0] + "#" + rg[2] + ";";
                      }

                  }
                  byte[] s2c = Encoding.UTF8.GetBytes(send2c[0]);
                  ms.Send(s2c);
                  
              }
              else if (revfromc[1].Trim() == "4")
              {

                  sc = new sql("with t as (select top 100 percent Sid from Orders where Sid in (select Sid from Snack  where Sname like '%" + revfromc[2] + "%') group by Sid) select count(*) from t;");
                  string[] numxl = sc.cx1();
                  string[] rggg;

                  send2c[0] = num + ";";
                  if (numxl[0].Trim() != num && revfromc[2].Trim()=="")
                  {
                      numxl[0] = (Convert.ToInt16(num) - Convert.ToInt16(numxl[0])).ToString();

                      sc = new sql("select Sid from Snack where Sid not in(select distinct Sid from Orders);", Convert.ToInt16(numxl[0]));
                      rggg = sc.cx2();
                      for (int k = 0; k < Convert.ToInt16(numxl[0]); k++)
                      {
                          sc = new sql("use Snack select Sname,Sdescribe,Sid,Sprice from Snack where Sid='" + rggg[k] + "'", 4);
                          string[] rg;
                          rg = sc.cx1();
                          sc = new sql("use Snack select count(*) from Orders where Sid='" + rg[2].Trim() + "'");
                          string[] rg2;
                          rg2 = sc.cx1();
                          string str1 = String.Format("{0:F}", Convert.ToDouble(rg[3]));
                          send2c[0] += rg[0] + "@" + rg[1] + "@" + str1 + "@" + rg2[0] + "#" + rg[2] + ";";
                      }
                      numxl[0] = (Convert.ToInt16(num) - Convert.ToInt16(numxl[0])).ToString();
                  }
                  
                  sc = new sql("select Sid from Orders where Sid in (select Sid from Snack  where Sname like '%" + revfromc[2] + "%') group by Sid order by COUNT(*) asc;", Convert.ToInt16(numxl[0]));
                  rggg = sc.cx2();
                  for (int k = 0; k < Convert.ToInt16(numxl[0]); k++)
                  {
                      sc = new sql("use Snack select Sname,Sdescribe,Sid,Sprice from Snack where Sid='" + rggg[k] + "'", 4);
                      string[] rg;
                      rg = sc.cx1();
                      sc = new sql("use Snack select count(*) from Orders where Sid='" + rg[2].Trim() + "'");
                      string[] rg2;
                      rg2 = sc.cx1();
                      string str1 = String.Format("{0:F}", Convert.ToDouble(rg[3]));
                      send2c[0] += rg[0] + "@" + rg[1] + "@" + str1 + "@" + rg2[0] + "#" + rg[2] + ";";
                  }

                  byte[] s2c = Encoding.UTF8.GetBytes(send2c[0]);
                  ms.Send(s2c);

              }
              else
              {
                    sc = new sql("use Snack select Sname,Sdescribe,Sid,Sprice from Snack where Sname like '%"+revfromc[2]+"%'", 4, Convert.ToInt16(num));
                  string[,] rg = new string[1000, 3];
                  rg = sc.cx12();
                  send2c[0] = num + ";";
                  for (int i = 0; i < Convert.ToInt16(num); i++)
                  {
                      sc = new sql("use Snack select count(*) from Orders where Sid='" + rg[i, 2].Trim() + "'");
                      string[] rg2;
                      rg2 = sc.cx1();
                      string str1 = String.Format("{0:F}", Convert.ToDouble(rg[i, 3]));
                      send2c[0] += rg[i, 0] + "@" + rg[i, 1] + "@" + str1 + "@" + rg2[0] + "#" + rg[i, 2] + ";";
                  }
                  byte[] s2c = Encoding.UTF8.GetBytes(send2c[0]);
                  ms.Send(s2c);
              }
             
          }
          else if (revfromc[0] == "goodpic")
          {
              sql sc = new sql("use Snack select Spic from Snack where Sid='" + revfromc[1] + "';");
              send2c = sc.cx1();
              string path = send2c[0];
              Image image = Image.FromFile(path);
              MemoryStream mss = new MemoryStream();
              image.Save(mss, System.Drawing.Imaging.ImageFormat.Jpeg);
              byte[] buffer = new byte[mss.Length];
              mss.Seek(0, SeekOrigin.Begin);
              mss.Read(buffer, 0, buffer.Length);
              mss.Close();
              ms.Send(buffer);
              send2c[0] = "#零食图片";
          }
          else if (revfromc[0] == "detailgoodinfo")
          {
              sql sc = new sql("use Snack select Sname,Sdescribe,Sweight,Sprice from Snack where Sid='"+revfromc[1]+"'",4);
              send2c = sc.cx1();
              string rg = send2c[0] + ";" + send2c[1] + ";"+send2c[2]+";" +send2c[3] + ";";
              sc = new sql("use Snack select count(*) from Taste where Sid='" + revfromc[1] + "'");
              send2c = sc.cx1();
              int num = Convert.ToInt16(send2c[0]);
              rg += num + ";";
              string[,] rgg=new string[num,2];
              sc = new sql("use Snack select Taste,Tid from Taste where Sid='" + revfromc[1] + "'",2,num);
              rgg = sc.cx12();
              for (int i = 0; i < num; i++)
              {
                  rg += rgg[i, 0] + "#" + rgg[i, 1] + ";";
              }
              byte[] s2c = Encoding.UTF8.GetBytes(rg);
              ms.Send(s2c);
              send2c[0] = rg;
          }
          else if (revfromc[0] == "goodreview")
          {
              sql sc = new sql("use Snack select COUNT(*) from Review where Sid='" + revfromc[1] + "'", 1);
              send2c = sc.cx1();
              int num = Convert.ToInt16(send2c[0].Trim());
              string rg="";
              rg += num + ";";
              if (num == 0)
              {
                  byte[] s2c2 = Encoding.UTF8.GetBytes(rg);
                  ms.Send(s2c2);
                  send2c[0] = rg;
                  return;
              }
              string[,] rgg = new string[num, 3];
              sc = new sql("use Snack select Cid,Rtext,Rdate from Review where Sid='" + revfromc[1] + "' order by Rdate desc;", 3, num);
              rgg = sc.cx12();
              for (int i = 0; i < num; i++)
              {
                  sc = new sql("select Cname,Cnickname from Customer where Cid='" +rgg[i,0] + "';",2);
                  string[] rggg =new string[2];
                  rggg[0] = "";
                  rggg=sc.cx1();
                  rggg[0] = rggg[0].Trim();
                  if (rggg[0] == "")
                  {
                      rggg[0] = "匿名";
                  }
                  rg +=rggg[0].Trim()+"于"+rgg[i,2]+"评论：" + "#" + rgg[i,1] +"#"+rggg[1]+ ";";
              }
              byte[] s2c = Encoding.UTF8.GetBytes(rg);
              ms.Send(s2c);
              send2c[0] = rg;
          }
          else if (revfromc[0] == "order")
          {
              sql sc = new sql("use Snack select Cid FROM Customer where Cnickname='" + revfromc[1] + "';");
              string[] rg2 = sc.cx1();
              string cid = rg2[0];
              sc = new sql("use Snack select Oid FROM Orders order by Oid desc;");
              rg2 = sc.cx1();
              int oid =Convert.ToInt16(rg2[0])+1;
              DateTime odate = System.DateTime.Now;
              sc = new sql("use Snack select Aid from Address where Cid='" + cid + "' and Ais_usual='1';");
              rg2 = sc.cx1();
              string aid=rg2[0];
              int otime = revfromc.Length - 2;
              for (int i = 2; i < otime+2; i++)
              {
                  string []rg=revfromc[i].Split('#');
                  sc = new sql("use Snack insert into Orders VALUES ('"+oid.ToString()+"','"+cid+"','"+rg[0]+"','"+rg[1]+"','"+aid+"','"+rg[2]+"','0','"+odate+"');");
                  sc.zx();
              }
              byte[] s2c = Encoding.UTF8.GetBytes("done");
              ms.Send(s2c);
              send2c[0] = "order done";
          
          }
          else if (revfromc[0] == "cancelod")
          {
              string a= revfromc[1].Trim();
              sql sc=new sql("use Snack update Orders set Ostate='2' where Oid='"+a+"';");
              sc.zx();
              byte[] s2c = Encoding.UTF8.GetBytes("done");
              ms.Send(s2c);
              send2c[0] = "cancel done";
          
          
          }
          else if (revfromc[0] == "review")
          {
              sql sc = new sql("use Snack select Cid FROM Customer where Cnickname='" + revfromc[1] + "';");
              string[] rg2 = sc.cx1();
              string cid = rg2[0];
              sc = new sql("use Snack select Rid FROM Review order by Rid desc;");
              rg2 = sc.cx1();
              string rid = (Convert.ToInt16(rg2[0])+1).ToString();
              sc = new sql("use Snack insert into Review values('" + rid + "','" + revfromc[2] + "','" + cid + "','" + revfromc[3] + "','"+System.DateTime.Now+"');");
              sc.zx();
              byte[] s2c = Encoding.UTF8.GetBytes("done");
              ms.Send(s2c);
              send2c[0] = "review done";
          }
          else if (revfromc[0] == "orderinfo")
          {
              string send = "";
              string sendp = "";
              double sum = 0;
              int mnum = 0;
              sql sc = new sql("use Snack select Cid FROM Customer where Cnickname='" + revfromc[1] + "';");
              string[] rg2 = sc.cx1();
              string cid = rg2[0];
              sc = new sql("use Snack select count(*) FROM Orders where Cid='" + cid + "';");
              rg2 = sc.cx1();
              string onum = rg2[0];
              sc = new sql("use Snack select * FROM Orders where Cid='" + cid + "' order by Oid desc;", 8, Convert.ToInt16(onum));
              string[,] rg;
              rg = sc.cx12();
              string footer = "";
              string header = "";
              for (int i = 0; i < Convert.ToInt16(onum); i++)
              {


                  string sid = rg[i, 2];

                  sc = new sql("use Snack select Sname from Snack where Sid='" + rg[i, 2] + "'");
                  string[] rggg;
                  rggg = sc.cx1();
                  string lb1 = rggg[0];
                  if (rg[i, 4] != "")
                  {
                      sc = new sql("use Snack select Taste from Taste where Tid='" + rg[i, 3] + "' and sid='" + sid + "';");
                      rggg = sc.cx1();
                      lb1 += "（" + rggg[0] + "）";
                  }
                  sc = new sql("use Snack select Sprice from Snack where Sid='" + rg[i, 2] + "'");
                  rggg = sc.cx1();
                  double p = 0;
                  p = Convert.ToDouble(rggg[0]) * Convert.ToDouble(rg[i, 5]);
                  sum += p;
                  string str1 = String.Format("{0:F}", p);
                  string lb2 = "  X" + rg[i, 5] + "   价格：" + str1 + "元";

                  if (i > 0)
                  {
                      if (rg[i, 0] == rg[i - 1, 0])
                      {
                          mnum++;
                          sendp += "#" + sid + "@" + lb1 + "@" + lb2;

                      }
                      else
                      {



                          sendp = ";" + header + "@" + footer + sendp;
                          send += sendp;
                          sum = 0;
                          sendp = "#" + sid + "@" + lb1 + "@" + lb2;
                      }
                  }
                  else
                  {
                      sendp += "#" + sid + "@" + lb1 + "@" + lb2;

                  }


                  header = "订单号:" + rg[i, 0];
                  header += "    总价:" + String.Format("{0:F}", sum);
                  header += "    时间:" + rg[i, 7];
                  string aid = rg[i, 4];
                  sc = new sql("use Snack select * from Address where Aid='" + aid + "';", 7, 1);
                  string[,] rgg;
                  rgg = sc.cx12();
                  for (int k = 3; k < 6; k++)
                  {
                      rgg[0, 2] += "" + rgg[0, k];
                  }

                  footer = "地址:" + rgg[0, 2];
                  string ste = "";
                  if (rg[i, 6] == "0")
                  {
                      ste = "配送中";
                  }
                  else if (rg[i, 6] == "1")
                  {
                      ste = "已完成";
                  }
                  else if (rg[i, 6] == "2")
                  {
                      ste = "已取消";
                  }

                  footer += "   状态:" + ste + "@" + rg[i, 6];

                  if (i == Convert.ToInt16(onum) - 1)
                  {

                      sendp = ";" + header + "@" + footer + sendp;
                      send += sendp;
                  }
              }
              send = (Convert.ToInt16(onum) - mnum).ToString() + send;
              send2c[0] = send;
              byte[] s2c = Encoding.UTF8.GetBytes(send);
              ms.Send(s2c);

          }



          Server.th2log out2cip = new th2log(frm.log_cchg);
          frm.BeginInvoke(out2cip,System.DateTime.Now.ToString()+":向客户端"+ms.RemoteEndPoint+"）回复字段 "+send2c[0]);
          wrt2txt(frm.path_log + "___log_send.txt", log_c.Text);
          Server.logcg cglog = new logcg(frm.logmove);
          frm.BeginInvoke(cglog);
        }
        public class sql//数据库操作类
        {
            public int cxxl = 0;
            public int a, b;
            public string sqlstr;
            public bool is_q = false;
            public string qstr = "";
            public sql(string sq, int aa = 1, int bb = 1, bool isq = false, string qs = "确认执行？")
            {
                sqlstr = sq;
                a = aa;
                b = bb;
                is_q = isq;
                qstr = qs;
            }
            public string[] cx1()
            {
                string[] jg = new string[a];
                SqlConnection con = new SqlConnection();//查询语句
                con.ConnectionString = "server=.;database=Snack;uid=sa;pwd=123";
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand(sqlstr, con);
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        Console.Write(dr[0].ToString());
                        for (int i = 0; i < a; i++)
                        {
                            jg[i] = dr[i].ToString();
                        }
                    }
                    else
                    {
                        //MessageBox.Show("有错误！无查询结果" + Environment.NewLine + sqlstr);  //执行语句
                    }
                    dr.Close();
                }
                catch (Exception err1)
                {
                    //MessageBox.Show("有错误!原因如下：" + Environment.NewLine + sqlstr + Environment.NewLine + err1);//执行语句
                }
                con.Close();
                return jg;
            }
            public string[] cx2()
            {
                string[] jg = new string[a];
                SqlConnection con = new SqlConnection();//查询语句
                con.ConnectionString = "server=.;database=Snack;uid=sa;pwd=123";
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand(sqlstr, con);
                    SqlDataReader dr = cmd.ExecuteReader();
                    int i = 0;
                    cxxl = 0;
                    while (dr.Read())
                    {
                        Console.Write(dr[0].ToString());
                        jg[i] = dr[0].ToString();
                        i = i + 1;
                        cxxl = i;
                    }
                    dr.Close();
                    if (cxxl == 0)
                    {
                        //MessageBox.Show("有错误！无查询结果" + Environment.NewLine + sqlstr);  //执行语句
                    }
                }
                catch (Exception err1)
                {
                    //MessageBox.Show("有错误!原因如下：" + Environment.NewLine + sqlstr + Environment.NewLine + err1);//执行语句
                }
                return jg;
            }
            public string[,] cx12()
            {
                cxxl = 0;
                string[,] jg = new string[b, a];
                SqlConnection con = new SqlConnection();//查询语句
                con.ConnectionString = "server=.;database=Snack;uid=sa;pwd=123";
                try
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand(sqlstr, con);
                    SqlDataReader dr = cmd.ExecuteReader();
                    int i = 0;
                    cxxl = 0;
                   
                        while (dr.Read())
                        {
                            for (int k = 0; k < a; k++)
                            {
                            jg[i, k] = dr[k].ToString();
                            }
                            i = i + 1;
                            cxxl = i;
                        }
                    
                    dr.Close();
                }
                catch (Exception err1)
                {
                    //MessageBox.Show("有错误!原因如下：" + Environment.NewLine + sqlstr + Environment.NewLine + err1);//执行语句
                }
                con.Close();
                return jg;
            }
            public void zx(bool is_q = false, string qstr = "")
            {
                SqlConnection con = new SqlConnection();//录入语句
                con.ConnectionString = "server=.;database=Snack;uid=sa;pwd=123";
                try
                {
                    con.Open();
                    if (is_q)
                    {
                        if ((MessageBox.Show(qstr, "confirm message", MessageBoxButtons.OKCancel)) == DialogResult.OK)
                        {
                            {
                                SqlCommand cmd = new SqlCommand(sqlstr, con);
                                SqlDataReader dr = cmd.ExecuteReader();
                                //MessageBox.Show("数据库代码执行成功");
                            }
                        }
                    }
                    else
                    {
                        SqlCommand cmd = new SqlCommand(sqlstr, con);
                        SqlDataReader dr = cmd.ExecuteReader();
                        //MessageBox.Show("数据库代码执行成功");
                    }
                }
                catch (Exception err1)
                {
                    //MessageBox.Show("有错误!原因如下：" + Environment.NewLine + sqlstr + Environment.NewLine + err1);//执行语句
                }
                con.Close();
            }
        }
        private void wrt2txt(string path, string str,bool is_rewrite=false)
        {
            if (!File.Exists(path))
            {
                string createText = "";
                File.WriteAllText(path, createText);
            }
                FileStream stream = File.Open(path, FileMode.OpenOrCreate, FileAccess.Write);
                stream.Seek(0, SeekOrigin.Begin);
                stream.SetLength(0);
                stream.Close();
            string appendText = str;
            File.AppendAllText(path, appendText);
        }

        private void tip_TextChanged(object sender, EventArgs e)
        {

        }

        private void log_c_TextChanged(object sender, EventArgs e)
        {

            log_c.SelectionStart = log_c.Text.Length;
            log_c.ScrollToCaret();
            log_c.Focus();
        }

        private void tlog_TextChanged(object sender, EventArgs e)
        {
            tlog.SelectionStart = tlog.Text.Length;
            tlog.ScrollToCaret();
            tlog.Focus();
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            sql sc = new sql("use Snack update Orders set Ostate='1' where Odate<convert(varchar(10),'"+System.DateTime.Now.AddDays(-1)+"',120) and Ostate='0';");
            sc.zx();
        }
    }
}
