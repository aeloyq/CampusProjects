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
        public string path_log = "./log/" + System.DateTime.Now.Date.ToString().Substring(0, 10) + "--" + System.DateTime.Now.TimeOfDay.Hours.ToString() + "-" + System.DateTime.Now.TimeOfDay.Minutes.ToString() +"-"+ System.DateTime.Now.TimeOfDay.Seconds.ToString();
        private void Server_Load(object sender, EventArgs e)
        {

        }
        public void tlogchg(string str)
        {
        tlog.Text+=System.Environment.NewLine+ str;
        }
        public void log_cchg(string str)
        {
            log_c.Text += System.Environment.NewLine + str;
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
            public static byte[] result = new byte[1024];
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
                while (true)
                {
                    try
                    {
                        //通过clientSocket接收数据  
                        int receiveNumber = myClientSocket.Receive(result);
                        string vrv = Encoding.UTF8.GetString(result, 0, receiveNumber);
                        if 
                            vstr =System.DateTime.Now.ToString()+":接收客户端" + myClientSocket.RemoteEndPoint.ToString() + "消息" + vrv;
                            Server.th2log out2log = new th2log(frm.tlogchg);
                            frm.BeginInvoke(out2log, vstr);
                            frm.recv_s[frm.index] = vrv;
                            frm.index++;
                            string[] vcip = new string[2];
                            vcip = myClientSocket.RemoteEndPoint.ToString().Split(':');
                            Server.th2log out2cip = new th2log(frm.cipchg);
                            frm.BeginInvoke(out2cip, vcip[0]);
                            frm.wrt2txt(frm.path_log+"___log_recv.txt", frm.tlog.Text);
                            frm.echo(myClientSocket,vrv, IPAddress.Parse(vcip[0]),Convert.ToInt32( vcip[1]),frm);
                    }
                    catch (Exception ex)
                    {
                    }
                        myClientSocket.Shutdown(SocketShutdown.Both);
                        myClientSocket.Close();
                        break;
                        Thread.CurrentThread.Abort();
                }
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
        public void echo(Socket ms, string str,IPAddress ip,int port,Server frm)
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
              for (int i = 3; i < 6; i++)
              {
                  rg[0, 2] +=" "+rg[0, i];
              }
              send2c[1] += ";" + rg[0, 2] + "#" + rg[0, 1] + ";" + num.ToString();
              sc = new sql("use Snack select * from Address where Cid='" + cid + "'",7,num);
              rg = sc.cx12();
              for (int i = 0; i < num; i++)
              {
                  for (int k = 3; k < 6; k++)
                  {
                      rg[i, 2] +=" "+rg[i, k];
                  }
                  send2c[1] += ";" + rg[i, 2] + "#" + rg[i, 1];
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
              for (int i = 3; i < 6; i++)
              {
                  rg[0, 2] +=" "+rg[0, i];
              }
              send2c[1] += ";" + rg[0, 2] + "#" + rg[0, 1] + ";" + num.ToString();
              sc = new sql("use Snack select * from Address where Cid='" + cid + "'",7,num);
              rg = sc.cx12();
              for (int i = 0; i < num; i++)
              {
                  for (int k = 3; k < 6; k++)
                  {
                      rg[i, 2] +=" "+rg[i, k];
                  }
                  send2c[1] += ";" + rg[i, 2] + "#" + rg[i, 1];
              }
              byte[] s2c = Encoding.UTF8.GetBytes(send2c[1]);
              //ms.Send(s2c);
              send2c[0] = send2c[1];
              Image image = Image.FromFile(send2c[4]);
              MemoryStream mss = new MemoryStream();
              image.Save(mss, System.Drawing.Imaging.ImageFormat.Jpeg);
              byte[] buffer = new byte[mss.Length];
              mss.Seek(0, SeekOrigin.Begin);
              mss.Read(buffer, 0, buffer.Length);
              ms.Send(buffer);
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
    }
}
