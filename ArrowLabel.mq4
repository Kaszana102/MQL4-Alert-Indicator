#include "Arrow.mqh"
#include "Label.mqh"

//+------------------------------------------------------------------+
//|                                                   ArrowLabel.mq4 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//#property strict
#property indicator_chart_window
   
 
string notificationName="";
const string ArrowAlias = "Arrow";
  const string LabelAlias = "Label";


//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
      notificationName="";
      
      return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+

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
      //check if notification already exist
      if(notificationName!=""){
         //delete it
         DeleteNotification(notificationName);
      }
      
      //create new notifiation at start
      notificationName = CreateNotfication(Time[0],High[0]);
   
//--- return value of prev_calculated for next call
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