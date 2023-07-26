#include "ArrowLabel.mqh"

#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color1 Red
//+---------------------------Defines--------------------------------+
#define test2



//+----------------------- global variables--------------------------+
double Buf_0[],Buf_1[];
datetime lastTimeAlert = 0;


//--------------------------------------------------------------------
int init()
  {
  //Alert("---------------------------------------");
//--------------------------------------------------------------------
   SetIndexBuffer(0,Buf_0);
   SetIndexStyle (0,DRAW_LINE,STYLE_SOLID,2);
   
   SetIndexBuffer(1,Buf_1);
   SetIndexStyle (1,DRAW_LINE,STYLE_DOT,2);
   

   #ifdef test
   
   TimedNotfication(Time[0],High[0],true,10);
   
   #endif
  



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
   
   for(int i = 0; i < Bars - IndicatorCounted() - 1; i++){
      Buf_0[i]=iMA(NULL, 0, 55, 0, MODE_SMA, PRICE_CLOSE, i);
      Buf_1[i]=iMA(NULL, 0, 13, 0, MODE_SMA, PRICE_CLOSE, i);
   }
   
   
   for(int i=0; i< Bars-i;i++){
      if(Time[i] == lastTimeAlert){
         break;
      }
      double y0b0 = Buf_0[i+1];
      double y1b0 = Buf_0[i];
      double y0b1 = Buf_1[i+1];
      double y1b1 = Buf_1[i];
      if(y0b0 < y0b1 && y1b0 > y1b1){
         //Alert(y0b0," ", y0b1, " ",y1b0," ", y1b1, " x");
         TimedNotfication(Time[i],y0b0,true,5);
         lastTimeAlert = Time[i];
         break;
      }      
      if(y0b0 > y0b1 && y1b0 < y1b1){
         //Alert(y0b0," ", y0b1," ", y1b0," ", y1b1, " y");
         TimedNotfication(Time[i],y0b0,true,5);
         lastTimeAlert = Time[i];
         break;
      }
   }      
   
  return(rates_total); 
  }
  

string notifName="";
 void TimedNotfication(datetime   time=0,    
                         double     price=0,
                         bool isUp = true,
                         int secondsAlive = 5){
      notifName = CreateNotfication(time,price,isUp);
      EventSetTimer(secondsAlive);                          
}


//there can be only one timer handler
void OnTimer(){
   DeleteNotificationLabel(notifName);
   EventKillTimer();
}


void OnDeinit(const int  reason ){
   ClearAllNotifications();
}