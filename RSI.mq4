//+------------------------------------------------------------------+
//|                                                          RSI.mq4 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_separate_window


#property indicator_level1 30 
#property indicator_level2 70 
#property indicator_minimum 0
#property indicator_maximum 100


#property indicator_buffers 1
#property indicator_color1 Blue
//+---------------------------Inputs--------------------------------+
input int okres = 55; //Okres 

//+---------------------------Defines--------------------------------+
#define test1



//+----------------------- global variables--------------------------+
double Buf_0[];
datetime lastTimeAlert = 0;

string ind0Name;

double levels[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   
   
   SetIndexBuffer(0,Buf_0);
   SetIndexStyle (0,DRAW_LINE,STYLE_SOLID,2);
   //SetIndexLabel(0,ind0Name);
   
            
   ArrayResize(levels,1);
   
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
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
//---
   Alert(ObjectGetDouble(0,"Fibonacci", OBJPROP_PRICE,0));
   
   
   for(int i = 0; i < Bars - IndicatorCounted() - 1; i++){         
         Buf_0[i]=iRSI(NULL,0,okres,PRICE_CLOSE,i);
      }

   
   if(cross(High[0],70,High[1],70)){
      //Alert("aaa");
   }
   
   
   //--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+







/*
  a1    b2
   .   .
    \ /
     X
   ./ \.a2
   b1
*/
bool cross(double a1,double a2, double b1, double b2){
return (b1 < a1 && b2 > a2) || (a1 < b1 && a2 > b2);
}