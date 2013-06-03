namespace SampleWebAPIWinFormsPascal;

interface

uses
  System.Drawing,
  System.Collections,
  System.Collections.Generic,
  System.Windows.Forms,
  System.ComponentModel,
  System.IO,
  System.Net,
  System.Text,
  System.Web.Script.Serialization;

type
  /// <summary>
  /// Summary description for MainForm.
  /// </summary>
  MainForm = partial class(System.Windows.Forms.Form)
  private
      method webBrowser1_Navigated(sender: System.Object; e: System.Windows.Forms.WebBrowserNavigatedEventArgs);
      method GetDeserializedResponse<T>(request:WebRequest):T;
      method getAccessToken;
      method getdataButton_Click(sender: System.Object; e: System.EventArgs);
      method hideAll;
      method showAll;
      method predButton_Click(sender: System.Object; e: System.EventArgs);
      method reset_barChart_Color;
      method reset_TBox_Label;
      method create_monoQuote;
      method zoomTBar_Scroll(sender: System.Object; e: System.EventArgs);
      method barChart_Click(sender: System.Object; e: System.EventArgs);
      method valTBox_KeyPress(sender: System.Object; e: System.Windows.Forms.KeyPressEventArgs);
      method symTBox_KeyPress(sender: System.Object; e: System.Windows.Forms.KeyPressEventArgs);
      method barNo2TS(barNo:Integer):DateTime;
      method Yscaling(minY,maxY:Decimal);
      
      outrangeColor:System.Drawing.Color := System.Drawing.Color.MediumSpringGreen; // for predicted bar that falls out of range (future bar)
      inrangeColor:System.Drawing.Color := System.Drawing.Color.Gold; // for predicted bar that falls inside the range (existing bar)
      foundColor:System.Drawing.Color := System.Drawing.Color.Red; // for found bar that has the search value
      emptyColor:System.Drawing.Color := System.Drawing.Color.Empty;
      
      Key:String;
      Secret:String;
      Host:String;
      RedirectURI:String;
      interval:Int32; // # of minutes between two bars
      barsperday:Integer; // # of bars per day
      authcode:String := "";
      Token:AccessToken;
      aQuote:array[0..100000] of Quote;
      monoQuote:array[0..100000] of Decimal; // monoQuote saves the range from minBar to maxBar
      nQuote,nmono:Integer;
      minValue,maxValue:Decimal;
      diff:Decimal; // Difference between minValue and maxValue
      minBar,maxBar:Integer;
      
      protected
    method Dispose(disposing: Boolean); override;
  public
    constructor;
  end;

implementation

{$REGION Construction and Disposition}
constructor MainForm;
begin
    //
    // Required for Windows Form Designer support
    //
    InitializeComponent();
  
    //
    // TODO: Add any constructor code after InitializeComponent call
    //

    Key:=Properties.Settings.Default.APIKey;
    Secret:=Properties.Settings.Default.APISecret;
    if Properties.Settings.Default.Environment = "SIM" then Host:="https://sim.api.tradestation.com/v2";
    if Properties.Settings.Default.Environment = "LIVE" then Host:="https://api.tradestation.com/v2";
    RedirectURI:=Properties.Settings.Default.RedirectURI;
    interval:=Properties.Settings.Default.Interval;
    barsperday:= 390 div interval; // # of bars per day
    
    // Hide all components except the web browser
    hideAll;
    webBrowser1.Show;

    var address:String;
    address:=String.Format("{0}/{1}", Host,
                                    String.Format(
                                        "authorize?client_id={0}&response_type=code&redirect_uri={1}",
                                        Key,
                                        RedirectURI));
    webBrowser1.Navigate(new Uri(address));
end;

method MainForm.Dispose(disposing: Boolean);
begin
  if disposing then begin
    if assigned(components) then
      components.Dispose();

    //
    // TODO: Add custom disposition code here
    //
  end;
  inherited Dispose(disposing);
end;
{$ENDREGION}

method MainForm.hideAll;
var i:Integer;
begin
    for i:=0 to self.Controls.Count-1 do
        self.Controls[i].Hide;
end;

method MainForm.showAll;
var i:Integer;
begin
    for i:=0 to self.Controls.Count-1 do
        self.Controls[i].Show;
end;

method MainForm.webBrowser1_Navigated(sender: System.Object; e: System.Windows.Forms.WebBrowserNavigatedEventArgs);
begin
    var newurl:String := webBrowser1.Url.ToString();
    var i:Integer := newurl.IndexOf("code=");
    if i>0 then
    begin
        authcode:=newurl.Substring(i+5);
        getAccessToken;
        webBrowser1.Stop;
        System.Windows.MessageBox.Show("Access Token obtained");
        
        // Show all components except the web browser and give control to the get data button
        showAll;
        webBrowser1.Hide;
        getdataButton.Select;
    end;
end;

method MainForm.GetDeserializedResponse<T>(request:WebRequest):T;
begin
            
    var response := request.GetResponse() as HttpWebResponse;
    var receiveStream := response.GetResponseStream();
    var readStream := new StreamReader(receiveStream, Encoding.UTF8);
    var ser := new JavaScriptSerializer();
    var json := ser.Deserialize<T>(readStream.ReadToEnd());
    response.Close();
    readStream.Close();
    result:=json;
            
end;

method MainForm.getAccessToken;
begin
    // Trading the Auth Code for an Access Token
    var request:=WebRequest.Create(String.Format("{0}/security/authorize", Host)) as HttpWebRequest;
    request.Method:= "POST";
    var postData:=String.Format(
                    "grant_type=authorization_code&code={0}&client_id={1}&redirect_uri={2}&client_secret={3}",
                    authcode,
                    Key,
                    RedirectURI,
                    Secret);
    var byteArray := Encoding.UTF8.GetBytes(postData);
    request.ContentType:="application/x-www-form-urlencoded";
    request.ContentLength:=byteArray.Length;
    var dataStream := request.GetRequestStream();
    dataStream.Write(byteArray, 0, byteArray.Length);
    dataStream.Close();
    
    try
        Token:=GetDeserializedResponse<AccessToken>(request);
    except
        on ex:Exception do
        begin
            System.Windows.MessageBox.Show(ex.Message);
            // Console.ReadLine();
            Environment.Exit(-1);
        end;
    end;
end;

method MainForm.reset_TBox_Label;
begin
    countLabel.BackColor:=emptyColor;
    countTBox.Text:="";
    avgdistLabel.BackColor:=emptyColor;
    avgdistTBox.Text:="";
    
    inLabel.BackColor:=emptyColor;
    indateTBox.Text:="";
    intimeTBox.Text:="";

    outLabel.BackColor:=emptyColor;
    outdateTBox.Text:="";
    outtimeTBox.Text:="";

    valTBox.Text:="";

    zoomTBar.Value:=0;
    zoomTBar_Scroll(self, EventArgs.Empty);
end;

method MainForm.create_monoQuote;
var i:Integer;
begin
    diff:=maxValue-minValue;
    nmono:=-1;
    if minBar <= maxBar then
    begin
        for i:=minBar to maxBar do
        begin
            inc(nmono);
            monoQuote[nmono]:=aQuote[i].Close-minValue;
        end;
    end
    else
    begin
        for i:=minBar downto maxBar do
        begin
            inc(nmono);
            monoQuote[nmono]:=aQuote[i].Close-minValue;
        end;
    end;
    
    // for i:=1 to nmono do System.Diagnostics.Trace.WriteLine(monoQuote[i]);
    System.Diagnostics.Trace.WriteLine(String.Format("{0} ({1}) {2} ({3}) {4} {5}", minBar, minValue, maxBar, maxValue, nmono, diff));
end;

method MainForm.Yscaling(minY: Decimal; maxY: Decimal);
begin
    // Adjust min, max to improve visualization
    barChart.ChartAreas[0].AxisY.Minimum:=Math.Max(Double(Math.Truncate(minY-(maxY-minY)/2)),0);
    barChart.ChartAreas[0].AxisY.Maximum:=Double(Math.Ceiling(maxY));
end;

method MainForm.getdataButton_Click(sender: System.Object; e: System.EventArgs);
begin
    var resourceUri :=
        new Uri(String.Format("{0}/stream/barchart/{1}/{2}/Minute/{3}/{4}?oauth_token={5}", Host, symTBox.Text,
                                interval, startTBox.Text, endTBox.Text, Token.access_token));

    // System.Diagnostics.Debug.WriteLine("Streaming BarChart");

    var request := WebRequest.Create(resourceUri) as HttpWebRequest;
    request.Method := "GET";

    try
    begin
        var response := request.GetResponse() as HttpWebResponse;
        
            var readStream := new StreamReader(response.GetResponseStream(), Encoding.UTF8, false, 4096);
            
                var ser := new JavaScriptSerializer();
                
                // Clear all data points
                nQuote:=0;
                barChart.Series[0].Points.Clear;
                minValue:=1e9;
                maxValue:=0;
                
                while (true) do
                begin
                    var line := readStream.ReadLine();
                    if (line = nil) or (line = "END") then break;
                    inc(nQuote);
                    var quote := ser.Deserialize<Quote>(line);
                    aQuote[nQuote]:=quote;
                    // Console.WriteLine(String.Format("{0}: ASK = {1}; BID = {2}", quote.Symbol, quote.Ask, quote.Bid));
                    // System.Diagnostics.Trace.WriteLine(line);
                    // if quote.TimeStamp.DayOfWeek.Equals(System.DayOfWeek.Sunday) then System.Diagnostics.Trace.Write(String.Format("{0} ", quote.Close));
                    // if quote.TimeStamp.DayOfWeek.Equals(System.DayOfWeek.Saturday) then System.Diagnostics.Trace.WriteLine(String.Format("{0} ", quote.Close));
                    // System.Diagnostics.Trace.WriteLine(String.Format("{0} {1} {2} {3}",quote.Close, quote.TimeStamp, quote.TimeStamp.ToFileTime, quote.TimeStamp.ToFileTimeUtc));
                    // barChart.Series[0].Points.AddXY(nQuote,quote.Close);
                    // System.Diagnostics.Trace.WriteLine(String.Format("{0} {1}",nQuote, aQuote[nQuote].Close));
                    
                    // barChart.Series[0].Points.AddXY(nQuote,quote.Low,quote.High,quote.Open,quote.Close);
                    barChart.Series[0].Points.AddXY(nQuote,quote.Close);
                    
                    if minValue > quote.Close then
                    begin
                        minValue:=quote.Close;
                        minBar:=nQuote;
                    end;
                    if maxValue < quote.Close then
                    begin
                        maxValue:=quote.Close;
                        maxBar:=nQuote;
                    end;
                    // System.Diagnostics.Trace.WriteLine(barChart.Series[0].Points[nQuote-1].Color);
                end;

            readStream.Close;

        // System.Diagnostics.Trace.WriteLine(aQuote[nQuote].TimeStamp.AddDays(1).ToString);
        
        create_monoQuote;

        response.Close;

        barChart.Titles.Clear;
        barChart.Titles.Add(String.Format("Symbol {0} from {1} to {2} ({3} data points)",
                            symTBox.Text, startTBox.Text, endTBox.Text, nQuote));
        
        // Adjust min, max to improve visualization
        Yscaling(minValue,maxValue);
        // barChart.Show;

        reset_TBox_Label;
        
        // Transfer control to zoom Track Bar
        zoomTBar.Select;
    end
    except
        on ex:Exception do
        begin
            System.Windows.MessageBox.Show(ex.Message);
            // Console.ReadLine();
            // Environment.Exit(-1);
        end;
    end;
end;

method MainForm.reset_barChart_Color;
var i:Integer;
begin
    for i:=barChart.Series[0].Points.Count-1 downto nQuote do
        barChart.Series[0].Points.RemoveAt(i);
    {
    if barChart.Series[0].Points.Count>nQuote then
    begin
        System.Diagnostics.Trace.WriteLine(barChart.Series[0].Points.Count-nQuote);
        barChart.Series[0].Points.RemoveAt(nQuote);
    end;
    }
    for i:=0 to nQuote-1 do
        barChart.Series[0].Points[i].Color:=System.Drawing.Color.Empty;

    // reset Yscaling
    Yscaling(minValue,maxValue);

    barChart.Refresh;

    countLabel.BackColor:=foundColor;
    countTBox.ForeColor:=foundColor;
    avgdistLabel.BackColor:=foundColor;
    avgdistTBox.ForeColor:=foundColor;
    
    inLabel.BackColor:=inrangeColor;
    indateTBox.ForeColor:=inrangeColor;
    intimeTBox.ForeColor:=inrangeColor;

    outLabel.BackColor:=outrangeColor;
    outdateTBox.ForeColor:=outrangeColor;
    outtimeTBox.ForeColor:=outrangeColor;
end;

method MainForm.predButton_Click(sender: System.Object; e: System.EventArgs);
var i,j,totaldist,count:Integer;
    avgdist,newocc:Integer;
    inocc,outocc:Integer;
    val:Decimal;
    mirror:Boolean;
    ts:DateTime;
    sign:Integer;
    diff2:Decimal;
    base:Decimal;
    absmin,tempbar:Decimal;
begin
    reset_barChart_Color;
    count:=0;
    val:=Decimal.Parse(valTBox.Text);
    System.Diagnostics.Trace.WriteLine(val);
    j:=0;
    totaldist:=0;
    
    // Count and prepare for prediction
    for i:=1 to nQuote do
        // if Math.Abs(aQuote[i].Close-val)<eps then
        if (aQuote[i].Low <= val) and (val <= aQuote[i].High) then
        begin
            barChart.Series[0].Points[i-1].Color:=foundColor;
            inc(count);
            if j>0 then
            begin
                inc(totaldist,i-j);
                // System.Diagnostics.Trace.WriteLine(i-j);
            end;
            j:=i;
        end;
    countTBox.Text:=count.ToString;
    
    // Prediction
    inocc:=0;
    outocc:=0;
    if count>1 then
    begin
        avgdist:=Integer(Math.Round(Decimal(totaldist)/(count-1)));
        avgdistTBox.Text:=avgdist.ToString;
        newocc:=j+avgdist;
        if newocc <= nQuote then
        begin
            mirror:=true;
            barChart.Series[0].Points[newocc-1].Color:=inrangeColor;
            // barChart.Series[0].Points[newocc-1].Name:="Prediction";
            inocc:=newocc;
        end
        else 
        begin
            mirror:=false;
            barChart.Series[0].Points.AddXY(newocc,val);
            barChart.Series[0].Points[nQuote].Color:=outrangeColor;
            // barChart.Series[0].Points[nQuote].Name:="Better prediction";
            outocc:=newocc;
        end;
    end
    else
    begin
        avgdistTBox.Text:="N/A";
    end;

    if (count=1) or mirror then
    begin
        outocc:=nQuote+nQuote-j;
        barChart.Series[0].Points.AddXY(outocc,val);
        barChart.Series[0].Points[nQuote].Color:=outrangeColor;
        for i:=nQuote-1 downto j+1 do 
        begin
            // barChart.Series[0].Points.AddXY(nQuote+nQuote-i,aQuote[i].Low,aQuote[i].High,aQuote[i].Open,aQuote[i].Close);
            barChart.Series[0].Points.AddXY(nQuote+nQuote-i,aQuote[i].Close);
            barChart.Series[0].Points[nQuote+nQuote-i].Color:=outrangeColor;
        end;
    end;

    if count=0 then
    begin
        // Add or subtract the monoQuote
        if aQuote[nQuote].Close<=val then
        begin
            sign:=1;
            diff2:=val-aQuote[nQuote].Close;
            
            // Readjust min, max to improve visualization
            Yscaling(minValue,val+diff);
        end
        else
        begin
            sign:=-1;
            diff2:=aQuote[nQuote].Close-val;
            
            // Readjust min, max to improve visualization
            Yscaling(val-diff,maxValue);
        end;

        // Adding whole cycles of monoQuote
        outocc:=nQuote;
        for i:=1 to Integer(Math.Truncate(diff2/diff)) do
        begin
            base:=Decimal(barChart.Series[0].Points[outocc-1].YValues[0]);
            for j:=1 to nmono do
            begin
                inc(outocc);
                barChart.Series[0].Points.AddXY(outocc,base+monoQuote[j]*sign);
                barChart.Series[0].Points[outocc-1].Color:=outrangeColor;
            end;
        end;
        
        // System.Diagnostics.Trace.WriteLine(barChart.Series[0].Points[outocc-1].YValues[0]);

        // Find the stop sign in monoQuote
        base:=Decimal(barChart.Series[0].Points[outocc-1].YValues[0]);
        absmin:=Math.Abs(val-base);
        i:=0;
        if absmin>0 then
            for j:=1 to nmono do
            begin
                tempbar:=base+monoQuote[j]*sign;
                if absmin > Math.Abs(val-tempbar) then
                begin
                    absmin:=Math.Abs(val-tempbar);
                    i:=j;
                    if absmin=0 then break;
                end;
            end;
        for j:=1 to i do
        begin
            inc(outocc);
            barChart.Series[0].Points.AddXY(outocc,base+monoQuote[j]*sign);
            barChart.Series[0].Points[outocc-1].Color:=outrangeColor;
        end;

        System.Diagnostics.Trace.WriteLine(barChart.Series[0].Points[outocc-1].YValues[0]);
        barChart.Series[0].Points[outocc-1].YValues[0]:=Double(val);
    end;

    if inocc > 0 then
    begin
        System.Diagnostics.Trace.WriteLine(String.Format("{0} ({1},{2}) {3}",
        inocc, aQuote[inocc].Low, aQuote[inocc].High, aQuote[inocc].TimeStamp.ToString));
        // indateTBox.Text:=aQuote[inocc].TimeStamp.ToShortDateString;
        // intimeTBox.Text:=aQuote[inocc].TimeStamp.TimeOfDay.ToString;
        ts:=barNo2TS(inocc);
        indateTBox.Text:=ts.ToShortDateString;
        intimeTBox.Text:=ts.TimeOfDay.ToString;
    end
    else
    begin
        indateTBox.Text:="N/A";
        intimeTBox.Text:="N/A";
    end;

    if outocc > 0 then
    begin
        // outdateTBox.Text:=outocc.ToString;
        // outtimeTBox.Text:=outocc.ToString;
        System.Diagnostics.Trace.WriteLine(outocc);
        ts:=barNo2TS(outocc);
        outdateTBox.Text:=ts.ToShortDateString;
        outtimeTBox.Text:=ts.TimeOfDay.ToString;
    end
    else
    begin
        outdateTBox.Text:="N/A";
        outtimeTBox.Text:="N/A";
    end;

    barChart.Refresh;
    // Transfer control to zoom Track Bar
    zoomTBar.Select;
end;

method MainForm.zoomTBar_Scroll(sender: System.Object; e: System.EventArgs);
var exp:array[0..30] of Double;
    i:Integer;
begin
    exp[0]:=1;
    for i:=1 to 30 do exp[i]:=exp[i-1]*0.7;
    if zoomTBar.Value = 0 then
    begin
        barChart.ChartAreas[0].AxisX.ScaleView.ZoomReset;
        barChart.ChartAreas[0].AxisY.ScaleView.ZoomReset;
    end
    else
    begin
        barChart.ChartAreas[0].AxisX.ScaleView.Size:=nQuote*exp[zoomTBar.Value];
        // barChart.ChartAreas[0].AxisY.ScaleView.Size:=Double(maxValue)*exp[zoomTBar.Value];
    end;
    barChart.Refresh;
end;

method MainForm.barChart_Click(sender: System.Object; e: System.EventArgs);
begin
    zoomTBar.Select;
end;

method MainForm.valTBox_KeyPress(sender: System.Object; e: System.Windows.Forms.KeyPressEventArgs);
begin
    if e.KeyChar = #13 then
        predButton_Click(sender, e);
end;

method MainForm.symTBox_KeyPress(sender: System.Object; e: System.Windows.Forms.KeyPressEventArgs);
begin
    if e.KeyChar = #13 then
        getdataButton_Click(sender, e);
end;

method MainForm.barNo2TS(barNo: Integer): DateTime;
var ts:DateTime;
    days:Integer;
    weeks:Integer;
    i:Integer;
    lastdaybar:Integer;
    barsperday:Integer; // recompute the bars per day for the last day
begin
    if barNo <= nQuote then
    begin
        result:=aQuote[barNo].TimeStamp;
        exit;
    end;
    lastdaybar:=nQuote-1;
    while aQuote[lastdaybar].TimeStamp.ToShortDateString = aQuote[nQuote].TimeStamp.ToShortDateString do dec(lastdaybar);
    barsperday:=nQuote-lastdaybar;
    
    inc(lastdaybar);
    dec(barNo,lastdaybar);

    days:=barNo div barsperday;
    weeks:=days div 5; // Sat and Sun are excluded
    days:=days mod 5;

    // ts:=ts.AddMinutes((barNo mod barsperday)*interval);
    for i:=1 to barNo mod barsperday do inc(lastdaybar);

    ts:=aQuote[lastdaybar].TimeStamp.AddDays(weeks*7);
    for i:=1 to days do
        begin
            ts:=ts.AddDays(1);
            if ts.DayOfWeek = System.DayOfWeek.Saturday then ts:=ts.AddDays(1);
            if ts.DayOfWeek = System.DayOfWeek.Sunday then ts:=ts.AddDays(1);
        end;
    result:=ts;
end;

end.
