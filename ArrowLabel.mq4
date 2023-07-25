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
#property strict


  
  const string ArrowAlias = "Arrow";
  const string LabelAlias = "Label";
  
  
  //returns the object name
  string CreateNotfication(datetime   time=0,            // anchor point time
                         double     price=0) {          // anchor point price){
   static int counter =0;
   string objectName = "Notification_" + (string)counter+"_";
   string arrowName = objectName+"Arrow";
   string labelName = objectName+"Label";
   
   counter++;
   
   ArrowBuyCreate(0,arrowName,0,time,price);
   LabelCreate(labelName,0,time,price+0.003,"aaaaa");            
   ChartRedraw();   
   
   
   return objectName;
  }
  
  
  void DeleteNotification(string name){
   ArrowBuyDelete(name+ArrowAlias);
   LabelDelete(name + LabelAlias);
  }
 



//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
      string name;
      for(int i=0;i<ArraySize(Time);i+=1){
         name = CreateNotfication(Time[i],High[i]);         
         Sleep(10);
         DeleteNotification(name);
      }
  }
//+------------------------------------------------------------------+
