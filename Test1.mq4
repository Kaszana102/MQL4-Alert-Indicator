#include "Increase.mqh"
//+------------------------------------------------------------------+
//|                                                         Test.mq4 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   double line[], saw[], prices[];
   int size = 17;
   double val = 1.5;
   double price = 10;
   
   ArrayResize(line,size);
   ArrayResize(saw,size);
   ArrayResize(prices,size);         
   for(int i=0;i<size;i++){
      line[i] = val;
      saw[i] =  i%8;
      prices[i]= i;
   }

   /*     
   ReverseArray(line);
   ReverseArray(saw);
   ReverseArray(prices);
  */ 
   Alert(GetIncrease(line,saw, prices));
//---
   return(INIT_SUCCEEDED);
  }
  
  
  
  
  void ReverseArray(double& array[]){
     const int size = ArraySize(array);
     
     for(int i=0;i<size/2;i++){
         int temp = array[i];
         array[i]=array[size-1-i];
         array[size-1-i] = temp;
     } 
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
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
