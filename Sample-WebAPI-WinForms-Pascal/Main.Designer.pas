namespace SampleWebAPIWinFormsPascal;

interface

{$HIDE H7}

uses
  System.Windows.Forms,
  System.Drawing;

type
  MainForm = partial class
  {$REGION Windows Form Designer generated fields}
  private
    components: System.ComponentModel.Container := nil;
      webBrowser1: System.Windows.Forms.WebBrowser;
      symTBox: System.Windows.Forms.TextBox;
      startTBox: System.Windows.Forms.TextBox;
      symLabel: System.Windows.Forms.Label;
      startLabel: System.Windows.Forms.Label;
      endLabel: System.Windows.Forms.Label;
      endTBox: System.Windows.Forms.TextBox;
      getdataButton: System.Windows.Forms.Button;
      barChart: System.Windows.Forms.DataVisualization.Charting.Chart;
      valLabel: System.Windows.Forms.Label;
      valTBox: System.Windows.Forms.TextBox;
      predButton: System.Windows.Forms.Button;
      countLabel: System.Windows.Forms.Label;
      countTBox: System.Windows.Forms.TextBox;
      zoomTBar: System.Windows.Forms.TrackBar;
      avgdistTBox: System.Windows.Forms.TextBox;
      avgdistLabel: System.Windows.Forms.Label;
      indateTBox: System.Windows.Forms.TextBox;
      intimeTBox: System.Windows.Forms.TextBox;
      outtimeTBox: System.Windows.Forms.TextBox;
      outdateTBox: System.Windows.Forms.TextBox;
      inLabel: System.Windows.Forms.Label;
      outLabel: System.Windows.Forms.Label;
      method InitializeComponent;
  {$ENDREGION}
  end;

implementation

{$REGION Windows Form Designer generated code}
method MainForm.InitializeComponent;
begin
  var chartArea1: System.Windows.Forms.DataVisualization.Charting.ChartArea := new System.Windows.Forms.DataVisualization.Charting.ChartArea();
  var series1: System.Windows.Forms.DataVisualization.Charting.Series := new System.Windows.Forms.DataVisualization.Charting.Series();
  var resources: System.ComponentModel.ComponentResourceManager := new System.ComponentModel.ComponentResourceManager(typeOf(MainForm));
  self.webBrowser1 := new System.Windows.Forms.WebBrowser();
  self.symTBox := new System.Windows.Forms.TextBox();
  self.startTBox := new System.Windows.Forms.TextBox();
  self.symLabel := new System.Windows.Forms.Label();
  self.startLabel := new System.Windows.Forms.Label();
  self.endLabel := new System.Windows.Forms.Label();
  self.endTBox := new System.Windows.Forms.TextBox();
  self.getdataButton := new System.Windows.Forms.Button();
  self.barChart := new System.Windows.Forms.DataVisualization.Charting.Chart();
  self.valLabel := new System.Windows.Forms.Label();
  self.valTBox := new System.Windows.Forms.TextBox();
  self.predButton := new System.Windows.Forms.Button();
  self.countLabel := new System.Windows.Forms.Label();
  self.countTBox := new System.Windows.Forms.TextBox();
  self.avgdistTBox := new System.Windows.Forms.TextBox();
  self.zoomTBar := new System.Windows.Forms.TrackBar();
  self.inLabel := new System.Windows.Forms.Label();
  self.outLabel := new System.Windows.Forms.Label();
  self.avgdistLabel := new System.Windows.Forms.Label();
  self.indateTBox := new System.Windows.Forms.TextBox();
  self.intimeTBox := new System.Windows.Forms.TextBox();
  self.outtimeTBox := new System.Windows.Forms.TextBox();
  self.outdateTBox := new System.Windows.Forms.TextBox();
  (self.barChart as System.ComponentModel.ISupportInitialize).BeginInit();
  (self.zoomTBar as System.ComponentModel.ISupportInitialize).BeginInit();
  self.SuspendLayout();
  // 
  // webBrowser1
  // 
  self.webBrowser1.Location := new System.Drawing.Point(0, 0);
  self.webBrowser1.MinimumSize := new System.Drawing.Size(20, 20);
  self.webBrowser1.Name := 'webBrowser1';
  self.webBrowser1.Size := new System.Drawing.Size(800, 650);
  self.webBrowser1.TabIndex := 0;
  self.webBrowser1.Navigated += new System.Windows.Forms.WebBrowserNavigatedEventHandler(@self.webBrowser1_Navigated);
  // 
  // symTBox
  // 
  self.symTBox.Location := new System.Drawing.Point(100, 27);
  self.symTBox.Name := 'symTBox';
  self.symTBox.Size := new System.Drawing.Size(50, 20);
  self.symTBox.TabIndex := 1;
  self.symTBox.Text := 'MSFT';
  self.symTBox.KeyPress += new System.Windows.Forms.KeyPressEventHandler(@self.symTBox_KeyPress);
  // 
  // startTBox
  // 
  self.startTBox.Location := new System.Drawing.Point(260, 27);
  self.startTBox.Name := 'startTBox';
  self.startTBox.Size := new System.Drawing.Size(100, 20);
  self.startTBox.TabIndex := 2;
  self.startTBox.Text := '5-1-2013';
  self.startTBox.KeyPress += new System.Windows.Forms.KeyPressEventHandler(@self.symTBox_KeyPress);
  // 
  // symLabel
  // 
  self.symLabel.Location := new System.Drawing.Point(50, 30);
  self.symLabel.Name := 'symLabel';
  self.symLabel.Size := new System.Drawing.Size(46, 13);
  self.symLabel.TabIndex := 3;
  self.symLabel.Text := 'Symbol';
  // 
  // startLabel
  // 
  self.startLabel.Location := new System.Drawing.Point(200, 30);
  self.startLabel.Name := 'startLabel';
  self.startLabel.Size := new System.Drawing.Size(55, 13);
  self.startLabel.TabIndex := 4;
  self.startLabel.Text := 'Start Date';
  // 
  // endLabel
  // 
  self.endLabel.Location := new System.Drawing.Point(390, 30);
  self.endLabel.Name := 'endLabel';
  self.endLabel.Size := new System.Drawing.Size(52, 13);
  self.endLabel.TabIndex := 6;
  self.endLabel.Text := 'End Date';
  // 
  // endTBox
  // 
  self.endTBox.Location := new System.Drawing.Point(450, 27);
  self.endTBox.Name := 'endTBox';
  self.endTBox.Size := new System.Drawing.Size(100, 20);
  self.endTBox.TabIndex := 5;
  self.endTBox.Text := '5-20-2013';
  self.endTBox.KeyPress += new System.Windows.Forms.KeyPressEventHandler(@self.symTBox_KeyPress);
  // 
  // getdataButton
  // 
  self.getdataButton.Location := new System.Drawing.Point(600, 25);
  self.getdataButton.Name := 'getdataButton';
  self.getdataButton.Size := new System.Drawing.Size(75, 23);
  self.getdataButton.TabIndex := 7;
  self.getdataButton.Text := 'Get Data';
  self.getdataButton.Click += new System.EventHandler(@self.getdataButton_Click);
  // 
  // barChart
  // 
  chartArea1.Name := 'ChartArea1';
  self.barChart.ChartAreas.Add(chartArea1);
  self.barChart.Location := new System.Drawing.Point(50, 100);
  self.barChart.Name := 'barChart';
  series1.ChartArea := 'ChartArea1';
  series1.Legend := 'Legend1';
  series1.Name := 'Series1';
  series1.YValuesPerPoint := 4;
  self.barChart.Series.Add(series1);
  self.barChart.Size := new System.Drawing.Size(900, 600);
  self.barChart.TabIndex := 8;
  self.barChart.Click += new System.EventHandler(@self.barChart_Click);
  // 
  // valLabel
  // 
  self.valLabel.Location := new System.Drawing.Point(50, 70);
  self.valLabel.Name := 'valLabel';
  self.valLabel.Size := new System.Drawing.Size(141, 13);
  self.valLabel.TabIndex := 9;
  self.valLabel.Text := 'Value to analyze and predict';
  // 
  // valTBox
  // 
  self.valTBox.Location := new System.Drawing.Point(200, 67);
  self.valTBox.Name := 'valTBox';
  self.valTBox.Size := new System.Drawing.Size(60, 20);
  self.valTBox.TabIndex := 10;
  self.valTBox.KeyPress += new System.Windows.Forms.KeyPressEventHandler(@self.valTBox_KeyPress);
  // 
  // predButton
  // 
  self.predButton.Location := new System.Drawing.Point(285, 65);
  self.predButton.Name := 'predButton';
  self.predButton.Size := new System.Drawing.Size(75, 23);
  self.predButton.TabIndex := 11;
  self.predButton.Text := 'Predict';
  self.predButton.Click += new System.EventHandler(@self.predButton_Click);
  // 
  // countLabel
  // 
  self.countLabel.Location := new System.Drawing.Point(390, 70);
  self.countLabel.Name := 'countLabel';
  self.countLabel.Size := new System.Drawing.Size(35, 13);
  self.countLabel.TabIndex := 12;
  self.countLabel.Text := 'Count';
  // 
  // countTBox
  // 
  self.countTBox.Location := new System.Drawing.Point(430, 67);
  self.countTBox.Name := 'countTBox';
  self.countTBox.Size := new System.Drawing.Size(40, 20);
  self.countTBox.TabIndex := 13;
  // 
  // avgdistTBox
  // 
  self.avgdistTBox.Location := new System.Drawing.Point(510, 67);
  self.avgdistTBox.Name := 'avgdistTBox';
  self.avgdistTBox.Size := new System.Drawing.Size(40, 20);
  self.avgdistTBox.TabIndex := 14;
  // 
  // zoomTBar
  // 
  self.zoomTBar.Location := new System.Drawing.Point(580, 55);
  self.zoomTBar.Maximum := 18;
  self.zoomTBar.Name := 'zoomTBar';
  self.zoomTBar.Size := new System.Drawing.Size(110, 45);
  self.zoomTBar.TabIndex := 1;
  self.zoomTBar.Scroll += new System.EventHandler(@self.zoomTBar_Scroll);
  // 
  // inLabel
  // 
  self.inLabel.Location := new System.Drawing.Point(720, 30);
  self.inLabel.Name := 'inLabel';
  self.inLabel.Size := new System.Drawing.Size(46, 13);
  self.inLabel.TabIndex := 16;
  self.inLabel.Text := 'In-range';
  // 
  // outLabel
  // 
  self.outLabel.Location := new System.Drawing.Point(720, 70);
  self.outLabel.Name := 'outLabel';
  self.outLabel.Size := new System.Drawing.Size(54, 13);
  self.outLabel.TabIndex := 17;
  self.outLabel.Text := 'Out-range';
  // 
  // avgdistLabel
  // 
  self.avgdistLabel.Location := new System.Drawing.Point(480, 70);
  self.avgdistLabel.Name := 'avgdistLabel';
  self.avgdistLabel.Size := new System.Drawing.Size(25, 13);
  self.avgdistLabel.TabIndex := 18;
  self.avgdistLabel.Text := 'Dist';
  // 
  // indateTBox
  // 
  self.indateTBox.Location := new System.Drawing.Point(780, 27);
  self.indateTBox.Name := 'indateTBox';
  self.indateTBox.Size := new System.Drawing.Size(80, 20);
  self.indateTBox.TabIndex := 19;
  // 
  // intimeTBox
  // 
  self.intimeTBox.Location := new System.Drawing.Point(870, 27);
  self.intimeTBox.Name := 'intimeTBox';
  self.intimeTBox.Size := new System.Drawing.Size(80, 20);
  self.intimeTBox.TabIndex := 20;
  // 
  // outtimeTBox
  // 
  self.outtimeTBox.Location := new System.Drawing.Point(870, 67);
  self.outtimeTBox.Name := 'outtimeTBox';
  self.outtimeTBox.Size := new System.Drawing.Size(80, 20);
  self.outtimeTBox.TabIndex := 22;
  // 
  // outdateTBox
  // 
  self.outdateTBox.Location := new System.Drawing.Point(780, 67);
  self.outdateTBox.Name := 'outdateTBox';
  self.outdateTBox.Size := new System.Drawing.Size(80, 20);
  self.outdateTBox.TabIndex := 21;
  // 
  // MainForm
  // 
  self.ClientSize := new System.Drawing.Size(1008, 730);
  self.Controls.Add(self.outtimeTBox);
  self.Controls.Add(self.outdateTBox);
  self.Controls.Add(self.intimeTBox);
  self.Controls.Add(self.indateTBox);
  self.Controls.Add(self.avgdistLabel);
  self.Controls.Add(self.outLabel);
  self.Controls.Add(self.inLabel);
  self.Controls.Add(self.zoomTBar);
  self.Controls.Add(self.avgdistTBox);
  self.Controls.Add(self.countTBox);
  self.Controls.Add(self.countLabel);
  self.Controls.Add(self.predButton);
  self.Controls.Add(self.valTBox);
  self.Controls.Add(self.valLabel);
  self.Controls.Add(self.barChart);
  self.Controls.Add(self.getdataButton);
  self.Controls.Add(self.endLabel);
  self.Controls.Add(self.endTBox);
  self.Controls.Add(self.startLabel);
  self.Controls.Add(self.symLabel);
  self.Controls.Add(self.startTBox);
  self.Controls.Add(self.symTBox);
  self.Controls.Add(self.webBrowser1);
  self.Icon := (resources.GetObject('$this.Icon') as System.Drawing.Icon);
  self.Name := 'MainForm';
  self.StartPosition := System.Windows.Forms.FormStartPosition.CenterScreen;
  self.Text := 'MainForm';
  (self.barChart as System.ComponentModel.ISupportInitialize).EndInit();
  (self.zoomTBar as System.ComponentModel.ISupportInitialize).EndInit();
  self.ResumeLayout(false);
  self.PerformLayout();
end;
{$ENDREGION}

end.
