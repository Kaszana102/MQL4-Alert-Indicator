#include "ArrowLabel.mqh"
#include "IndicatorEnum.mqh"

#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property description "Opis"
#property version   "1.00"
//#property show_inputs
#property indicator_chart_window




//#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 Blue
#property indicator_color2 Red
#property indicator_color3 Green
#property indicator_minimum 0
#property indicator_maximum 100
//--- display three horizontal levels in a separate indicator window
//#property indicator_level1 0.87
//#property indicator_level2 50

//#property indicator_label1 "Srednia1"
//#property indicator_label2 "Srednia2"

//#property indicator_separate_window

//+---------------------------Inputs--------------------------------+

//input IndicatorEnum Wskaźnik=0;

//średnie
input AverageEnum średnia1=SMA; //Wybór pierwszej średniej
input int okres1 = 55; //Okres pierwszej średniej

input AverageEnum średnia2=SMA; //Wybór drugiej średniej
input int okres2 = 25; //Okres drugiej średniej


//opcje alertów
input AlertsEnum warunekAlertu = Przecięcie; //Warunek Alertu
input AlertsCountEnum częstotliwośćkAlertu = Za_każdym_razem; //Częstotlitwość Alertu
input int długośćSygnału = 15;  //Długość sygnału [s]

//+---------------------------Defines--------------------------------+
#define test1



//+----------------------- global variables--------------------------+
double Buf_0[],Buf_1[];
datetime lastTimeAlert = 0;
bool fistAverageHasLongerPeriod = false;

string ind0Name,ind1Name;

bool onceDone = false;
//--------------------------------------------------------------------
int init()
  {
  //Alert("---------------------------------------");
//--------------------------------------------------------------------
   ind0Name= (średnia1==EMA? "EMA":"SMA")+"(" + okres1+")";
   ind1Name= (średnia2==EMA? "EMA":"SMA")+"(" + okres2+")";
   
   SetIndexBuffer(0,Buf_0);
   SetIndexStyle (0,DRAW_LINE,STYLE_SOLID,2);
   SetIndexLabel(0,ind0Name);
   
   SetIndexBuffer(1,Buf_1);
   SetIndexStyle (1,DRAW_LINE,STYLE_SOLID,2);
   SetIndexLabel(1,ind1Name);
      

   
   //IndicatorSetString(INDICATOR_SHORTNAME,0,ind0Name);   
   //IndicatorSetString(INDICATOR_SHORTNAME,1,ind1Name);  
   

   //fistAverageHasLongerPeriod = true;
   
   onceDone = false;
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
   
   
   if(onceDone==false){
      for(int i=Bars-2; i>=0;i--){
         
         CheckCross(i,false);
         
      }      
      onceDone = true;
   }
   else{   
      CheckCross(0);
   }
   
   
  return(rates_total); 
  }
  

//return true if crossection
bool CheckCross(int index = 0, bool alert = true){
   if(lastTimeAlert != Time[index]){
         double y0b0 = Buf_0[index+1];
         double y1b0 = Buf_0[index];
         double y0b1 = Buf_1[index+1];
         double y1b1 = Buf_1[index];
         if(y0b0 < y0b1 && y1b0 > y1b1){ //if przecięcie
            if(fistAverageHasLongerPeriod){
               if(alert)Alert("Przecięcie średnich ",ind0Name,"i ", ind1Name, " strategia: Kup");
               TimedNotfication(Time[index],y0b0,true,długośćSygnału,alert);
            }
            else{
               if(alert)Alert("Przecięcie średnich ",ind0Name,"i ", ind1Name, " strategia: Sprzedaj");
               TimedNotfication(Time[index],y0b0,false,długośćSygnału,alert);
            }
            lastTimeAlert = Time[index];
            return true;
                                       
         }      
         if(y0b0 > y0b1 && y1b0 < y1b1){ //if przecięcie
            if(fistAverageHasLongerPeriod){
               if(alert)Alert("Przecięcie średnich ",ind0Name,"i ",ind1Name, " strategia: Sprzedaj");
               TimedNotfication(Time[index],y0b0,false,długośćSygnału,alert);
            }
            else{
               if(alert)Alert("Przecięcie średnich ",ind0Name,"i ", ind1Name, " strategia: Kup");
               TimedNotfication(Time[index],y0b0,true,długośćSygnału,alert);
            }                           
            lastTimeAlert = Time[index];
            return true;
         }
      }
      return false;
}


void BufforAverages(){
   switch(średnia1){
      case(SMA): 
         for(int i = 0; i < Bars - IndicatorCounted() - 1; i++){
            Buf_0[i]=iMA(NULL, 0, okres1, 0, MODE_SMA, PRICE_CLOSE, i);                                    
         }
         break;
      case(EMA): 
         for(int i = 0; i < Bars - IndicatorCounted() - 1; i++){
            Buf_0[i]=iMA(NULL, 0, okres1, 0, MODE_EMA, PRICE_CLOSE, i);            
         }
         break;      
      default:
         for(int i = 0; i < Bars - IndicatorCounted() - 1; i++){
            Buf_0[i]=iMA(NULL, 0, okres1, 0, MODE_SMA, PRICE_CLOSE, i);            
         }
   }
   
   switch(średnia2){
      case(SMA): 
         for(int i = 0; i < Bars - IndicatorCounted() - 1; i++){
            Buf_1[i]=iMA(NULL, 0, okres2, 0, MODE_SMA, PRICE_CLOSE, i);
         }
         break;
      case(EMA): 
         for(int i = 0; i < Bars - IndicatorCounted() - 1; i++){            
            Buf_1[i]=iMA(NULL, 0, okres2, 0, MODE_EMA, PRICE_CLOSE, i);
         }
         break;      
      default:
         for(int i = 0; i < Bars - IndicatorCounted() - 1; i++){            
            Buf_1[i]=iMA(NULL, 0, okres2, 0, MODE_SMA, PRICE_CLOSE, i);
         }
   }
   
   

}

 string notifName="";
 void TimedNotfication(datetime   time=0,    
                         double     price=0,
                         bool isUp = true,
                         int secondsAlive = 5,
                         bool withLabel =  true){
      notifName = CreateNotfication(time,price,isUp);
      if(!withLabel){
      DeleteNotificationLabel(notifName);
      }
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

