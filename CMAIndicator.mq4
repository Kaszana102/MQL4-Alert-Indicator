#include "ArrowLabel.mqh"
#include "IndicatorEnum.mqh"

#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property description "Opis"
#property version   "1.00"
//#property show_inputs
#property indicator_chart_window




//#property indicator_separate_window 
#property indicator_buffers 6
#property indicator_color1 Blue
#property indicator_color2 Red
#property indicator_color3 Gray
#property indicator_color4 Gray
#property indicator_color5 Magenta
#property indicator_color6 Magenta
#property indicator_minimum 0
#property indicator_maximum 100
//--- display three horizontal levels in a separate indicator window
//#property indicator_level1 0.87
//#property indicator_level2 50

//#property indicator_label1 "Srednia1"
//#property indicator_label2 "Srednia2"

//#property indicator_separate_window

//+---------------------------Inputs--------------------------------+

input IndicatorEnum Wskaźnik=0;

//średnie
input AverageEnum średnia1=SMA; //Wybór pierwszej średniej
input int okres1 = 55; //Okres pierwszej średniej
input double poziom1_1 = .0025;// Poziom 1
input double poziom1_2 = -.0025;// Poziom 2

input AverageEnum średnia2=SMA; //Wybór drugiej średniej
input int okres2 = 25; //Okres drugiej średniej
input double poziom2_1 = .0025;// Poziom 1
input double poziom2_2 = -.0025;// Poziom 2

//opcje alertów
input AlertsEnum warunekAlertu = Przecięcie; //Warunek Alertu
input AlertsCountEnum częstotliwośćkAlertu = Za_każdym_razem; //Częstotlitwość Alertu
input int długośćSygnału = 15;  //Długość sygnału [s]

//+---------------------------Defines--------------------------------+
#define test1



//+----------------------- global variables--------------------------+
double Buf_0[],Buf_1[];
double Deviant1_1[],Deviant1_2[],Deviant2_1[],Deviant2_2[];
datetime lastTimeAlert = 0;
bool fistAverageHasLongerPeriod = false;

string ind0Name,ind1Name;

bool onceDone = false;
//--------------------------------------------------------------------
int init()
  {
  //Alert("---------------------------------------");
//--------------------------------------------------------------------
   ind0Name= (średnia1==EMA? "EMA":"SMA")+"(" + IntegerToString(okres1)+")";
   ind1Name= (średnia2==EMA? "EMA":"SMA")+"(" + IntegerToString(okres2)+")";
   
   SetIndexBuffer(0,Buf_0);
   SetIndexStyle (0,DRAW_LINE,STYLE_SOLID,2);
   SetIndexLabel(0,ind0Name);
   
   SetIndexBuffer(1,Buf_1);
   SetIndexStyle (1,DRAW_LINE,STYLE_SOLID,2);
   SetIndexLabel(1,ind1Name);
      
   SetIndexBuffer(2,Deviant1_1);
   SetIndexStyle (2,DRAW_LINE,STYLE_DOT,1);
   SetIndexLabel(2,ind0Name + " Level 1");
   
   SetIndexBuffer(3,Deviant1_2);
   SetIndexStyle (3,DRAW_LINE,STYLE_DOT,1);
   SetIndexLabel(3,ind0Name + " Level 2");
   
   SetIndexBuffer(4,Deviant2_1);
   SetIndexStyle (4,DRAW_LINE,STYLE_DOT,1);
   SetIndexLabel(4,ind1Name + " Level 1");
   
   SetIndexBuffer(5,Deviant2_2);
   SetIndexStyle (5,DRAW_LINE,STYLE_DOT,1); 
   SetIndexLabel(5,ind1Name + " Level 2");

   
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
            Deviant1_1[i]=Buf_0[i]+poziom1_1;
            Deviant1_2[i]=Buf_0[i]+poziom1_2;
         }
         break;
      case(EMA): 
         for(int i = 0; i < Bars - IndicatorCounted() - 1; i++){
            Buf_0[i]=iMA(NULL, 0, okres1, 0, MODE_EMA, PRICE_CLOSE, i);            
            Deviant1_1[i]=Buf_0[i]+poziom1_1;
            Deviant1_2[i]=Buf_0[i]+poziom1_2;
         }
         break;      
      default:
         for(int i = 0; i < Bars - IndicatorCounted() - 1; i++){
            Buf_0[i]=iMA(NULL, 0, okres1, 0, MODE_SMA, PRICE_CLOSE, i);            
            Deviant1_1[i]=Buf_0[i]+poziom1_1;
            Deviant1_2[i]=Buf_0[i]+poziom1_2;
         }
   }
   
   switch(średnia2){
      case(SMA): 
         for(int i = 0; i < Bars - IndicatorCounted() - 1; i++){
            Buf_1[i]=iMA(NULL, 0, okres2, 0, MODE_SMA, PRICE_CLOSE, i);
            Deviant2_1[i]=Buf_1[i]+poziom2_1;
            Deviant2_2[i]=Buf_1[i]+poziom2_2;
         }
         break;
      case(EMA): 
         for(int i = 0; i < Bars - IndicatorCounted() - 1; i++){            
            Buf_1[i]=iMA(NULL, 0, okres2, 0, MODE_EMA, PRICE_CLOSE, i);
            Deviant2_1[i]=Buf_1[i]+poziom2_1;
            Deviant2_2[i]=Buf_1[i]+poziom2_2;
         }
         break;      
      default:
         for(int i = 0; i < Bars - IndicatorCounted() - 1; i++){            
            Buf_1[i]=iMA(NULL, 0, okres2, 0, MODE_SMA, PRICE_CLOSE, i);
            Deviant2_1[i]=Buf_1[i]+poziom2_1;
            Deviant2_2[i]=Buf_1[i]+poziom2_2;
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

