namespace SnackServer
{
    partial class Server
    {
        /// <summary>
        /// 必需的设计器变量。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 清理所有正在使用的资源。
        /// </summary>
        /// <param name="disposing">如果应释放托管资源，为 true；否则为 false。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows 窗体设计器生成的代码

        /// <summary>
        /// 设计器支持所需的方法 - 不要
        /// 使用代码编辑器修改此方法的内容。
        /// </summary>
        private void InitializeComponent()
        {
            this.tlog = new System.Windows.Forms.TextBox();
            this.button1 = new System.Windows.Forms.Button();
            this.tip = new System.Windows.Forms.TextBox();
            this.tport = new System.Windows.Forms.TextBox();
            this.log_c = new System.Windows.Forms.TextBox();
            this.tport_c = new System.Windows.Forms.TextBox();
            this.cip_c = new System.Windows.Forms.ComboBox();
            this.SuspendLayout();
            // 
            // tlog
            // 
            this.tlog.BackColor = System.Drawing.Color.Black;
            this.tlog.ForeColor = System.Drawing.SystemColors.Window;
            this.tlog.Location = new System.Drawing.Point(12, 12);
            this.tlog.Multiline = true;
            this.tlog.Name = "tlog";
            this.tlog.Size = new System.Drawing.Size(470, 269);
            this.tlog.TabIndex = 1;
            this.tlog.Text = "LOG_s:";
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(494, 75);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(75, 23);
            this.button1.TabIndex = 0;
            this.button1.Text = "开启服务端";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // tip
            // 
            this.tip.Location = new System.Drawing.Point(494, 17);
            this.tip.Name = "tip";
            this.tip.Size = new System.Drawing.Size(107, 21);
            this.tip.TabIndex = 3;
            this.tip.Text = "192.168.3.100";
            // 
            // tport
            // 
            this.tport.Location = new System.Drawing.Point(606, 17);
            this.tport.Name = "tport";
            this.tport.Size = new System.Drawing.Size(43, 21);
            this.tport.TabIndex = 4;
            this.tport.Text = "8885";
            // 
            // log_c
            // 
            this.log_c.BackColor = System.Drawing.Color.Black;
            this.log_c.ForeColor = System.Drawing.SystemColors.Window;
            this.log_c.Location = new System.Drawing.Point(12, 287);
            this.log_c.Multiline = true;
            this.log_c.Name = "log_c";
            this.log_c.Size = new System.Drawing.Size(470, 269);
            this.log_c.TabIndex = 5;
            this.log_c.Text = "LOG_c:";
            // 
            // tport_c
            // 
            this.tport_c.Location = new System.Drawing.Point(606, 44);
            this.tport_c.Name = "tport_c";
            this.tport_c.Size = new System.Drawing.Size(43, 21);
            this.tport_c.TabIndex = 7;
            this.tport_c.Text = "8886";
            // 
            // cip_c
            // 
            this.cip_c.FormattingEnabled = true;
            this.cip_c.Location = new System.Drawing.Point(494, 45);
            this.cip_c.Name = "cip_c";
            this.cip_c.Size = new System.Drawing.Size(106, 20);
            this.cip_c.TabIndex = 8;
            // 
            // Server
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(688, 565);
            this.Controls.Add(this.cip_c);
            this.Controls.Add(this.tport_c);
            this.Controls.Add(this.log_c);
            this.Controls.Add(this.tport);
            this.Controls.Add(this.tip);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.tlog);
            this.MaximizeBox = false;
            this.Name = "Server";
            this.Text = "Server";
            this.Load += new System.EventHandler(this.Server_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox tlog;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.TextBox tip;
        private System.Windows.Forms.TextBox tport;
        private System.Windows.Forms.TextBox log_c;
        private System.Windows.Forms.TextBox tport_c;
        private System.Windows.Forms.ComboBox cip_c;
    }
}

