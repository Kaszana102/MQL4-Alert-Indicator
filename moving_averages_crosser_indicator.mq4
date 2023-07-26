#include "ArrowLabel.mqh"
#include "IndicatorEnum.mqh"

#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property description "Opis"
#property version   "1.00"
//#property show_inputs
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red


//#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red
#property indicator_minimum 0
#property indicator_maximum 100
//--- display three horizontal levels in a separate indicator window
#property description "aaa"
#property indicator_level1 30
#property indicator_level2 50

//#property indicator_separate_window

//+---------------------------Inputs--------------------------------+

input IndicatorEnum Wskaźnik=0;

//średnie
input AverageEnum średnia1=SMA;
input int okres1 = 55;
input bool pogrubiony1 = false;

input AverageEnum średnia2=0;
input int okres2 = 55;
input bool pogrubiony2 = true;


//opcje alertów
input AlertsEnum warunekAlertu = Przecięcie;
input AlertsCountEnum częstotliwośćkAlertu = Za_każdym_razem;
input int długośćSygnału = 15;

//+---------------------------Defines--------------------------------+
#define test2



//+----------------------- global variables--------------------------+
double Buf_0[],Buf_1[];
datetime lastTimeAlert = 0;
bool fistAverageHasLongerPeriod = false;

//--------------------------------------------------------------------
int init()
  {
  //Alert("---------------------------------------");
//--------------------------------------------------------------------
   SetIndexBuffer(0,Buf_0);
   SetIndexStyle (0,DRAW_LINE,STYLE_SOLID,2);
   
   SetIndexBuffer(1,Buf_1);
   SetIndexStyle (1,DRAW_LINE,STYLE_DOT,2);
   

   IndicatorSetString(INDICATOR_LEVELTEXT,0,"First Level (index 0)");
   IndicatorSetString(INDICATOR_LEVELTEXT,1,"Second Level (index 1)");


   #ifdef test
   
   TimedNotfication(Time[0],High[0],true,10);
   
   #endif
  

   //fistAverageHasLongerPeriod = true;

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
   BufforAverages();
   
   
   
   for(int i=0; i< Bars-i;i++){
      if(Time[i] == lastTimeAlert){
         break;
      }
      double y0b0 = Buf_0[i+1];
      double y1b0 = Buf_0[i];
      double y0b1 = Buf_1[i+1];
      double y1b1 = Buf_1[i];
      if(y0b0 < y0b1 && y1b0 > y1b1){ //if przecięcie
         if(fistAverageHasLongerPeriod){
            Alert("Przecięcie średnich ",średnia1==EMA? "EMA":"SMA","i ", średnia2==EMA? "EMA":"SMA", " strategia: Kup");
            TimedNotfication(Time[i],y0b0,true,5);
         }
         else{
            Alert("Przecięcie średnich ",średnia1==EMA? "EMA":"SMA","i ", średnia2==EMA? "EMA":"SMA", " strategia: Sprzedaj");
            TimedNotfication(Time[i],y0b0,false,5);
         }
         
         
         lastTimeAlert = Time[i];
         break;
      }      
      if(y0b0 > y0b1 && y1b0 < y1b1){ //if przecięcie
         if(fistAverageHasLongerPeriod){
            Alert("Przecięcie średnich ",średnia1==EMA? "EMA":"SMA","i ", średnia2==EMA? "EMA":"SMA", " strategia: Sprzedaj");
            TimedNotfication(Time[i],y0b0,false,5);
         }
         else{
            Alert("Przecięcie średnich ",średnia1==EMA? "EMA":"SMA","i ", średnia2==EMA? "EMA":"SMA", " strategia: Kup");
            TimedNotfication(Time[i],y0b0,true,5);
         }
         
         lastTimeAlert = Time[i];
         break;
      }
   }      
   
  return(rates_total); 
  }
  



void BufforAverages(){
   switch(średnia1){
      case(SMA): 
         for(int i = 0; i < Bars - IndicatorCounted() - 1; i++){
            Buf_0[i]=iMA(NULL, 0, 55, 0, MODE_SMA, PRICE_CLOSE, i);            
         }
         break;
      case(EMA): 
         for(int i = 0; i < Bars - IndicatorCounted() - 1; i++){
            Buf_0[i]=iMA(NULL, 0, 55, 0, MODE_EMA, PRICE_CLOSE, i);            
         }
         break;      
      default:
         for(int i = 0; i < Bars - IndicatorCounted() - 1; i++){
            Buf_0[i]=iMA(NULL, 0, 55, 0, MODE_SMA, PRICE_CLOSE, i);            
         }
   }
   
   switch(średnia2){
      case(SMA): 
         for(int i = 0; i < Bars - IndicatorCounted() - 1; i++){
            Buf_1[i]=iMA(NULL, 0, 13, 0, MODE_SMA, PRICE_CLOSE, i);
         }
         break;
      case(EMA): 
         for(int i = 0; i < Bars - IndicatorCounted() - 1; i++){            
            Buf_1[i]=iMA(NULL, 0, 13, 0, MODE_EMA, PRICE_CLOSE, i);
         }
         break;      
      default:
         for(int i = 0; i < Bars - IndicatorCounted() - 1; i++){            
            Buf_1[i]=iMA(NULL, 0, 13, 0, MODE_SMA, PRICE_CLOSE, i);
         }
   }

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