#include "Arrow.mqh"
#include "Label.mqh"

#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color1 Red
//+------------------------------------------------------------------+

string notificationName="";
const string ArrowAlias = "Arrow";
const string LabelAlias = "Label";
double Buf_0[],Buf_1[];
//--------------------------------------------------------------------
int init()
  {
  Alert("---------------------------------------");
//--------------------------------------------------------------------
   SetIndexBuffer(0,Buf_0);
   SetIndexStyle (0,DRAW_LINE,STYLE_SOLID,2);
   
   SetIndexBuffer(1,Buf_1);
   SetIndexStyle (1,DRAW_LINE,STYLE_DOT,2);


   return (INIT_SUCCEEDED);
  }
//--------------------------------------------------------------------

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {

//--------------------------------------------------------------------
   int start_i = Bars - IndicatorCounted() - 1;
   for(int i = start_i; i >= 0; i--){
      Buf_0[i]=iMA(NULL, 0, 55, 0, MODE_SMA, PRICE_CLOSE, i);
      Buf_1[i]=iMA(NULL, 0, 13, 0, MODE_SMA, PRICE_CLOSE, i);
      if(i != start_i){
         double y0b0 = Buf_0[i+1];
         double y1b0 = Buf_0[i];
         double y0b1 = Buf_1[i+1];
         double y1b1 = Buf_1[i];
         if(y0b0 < y0b1 && y1b0 > y1b1){
            //Alert(y0b0," ", y0b1, " ",y1b0," ", y1b1, " x");
            CreateNotfication(Time[i],y0b0);
         }
         
         if(y0b0 > y0b1 && y1b0 < y1b1){
            //Alert(y0b0," ", y0b1," ", y1b0," ", y1b1, " y");
            CreateNotfication(Time[i],y0b0);
         }
      }
      
   }

  return(rates_total);
  
  }
  
  
    
  //returns the object name
  string CreateNotfication(datetime   time=0,            // anchor point time
                         double     price=0) {          // anchor point price){
   static int counter =0;
   string objectName = "Notification_" + (string)counter+"_";
   string arrowName = objectName+"Arrow";
   string labelName = objectName+"Label";
   
   counter++;
      
   ArrowBuyCreate(0,arrowName,0,time,price);
   
   //calc offset
   double max,min;
   ChartGetDouble(0,CHART_PRICE_MAX,0,max);
   ChartGetDouble(0,CHART_PRICE_MIN,0,min);   
   double labelOffset = (max  - min)*0.05;
   
   LabelCreate(labelName,0,time,price+labelOffset,"KUPUJ");            
   ChartRedraw();   
   
   
   return objectName;
  }
  
  
  void DeleteNotification(string name){
   ArrowBuyDelete(name+ArrowAlias);
   LabelDelete(name + LabelAlias);
}