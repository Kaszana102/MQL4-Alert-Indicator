#include "Arrow.mqh"
#include "Label.mqh"

//+------------------------------------------------------------------+
//|                                                   ArrowLabel.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+


string notificationName="";
const string ArrowAlias = "Arrow";
const string LabelAlias = "Label";
int counter =0;
    
  //returns the object name
 string CreateNotfication(datetime   time=0,            // anchor point time
                         double     price=0,
                         bool isUp = true) {          // anchor point price){
   
   string objectName = "Notification_" + (string)counter+"_";
   string arrowName = objectName+"Arrow";
   string labelName = objectName+"Label";
   
   counter++;
   
   
   //calc label offset
   double max,min;
   ChartGetDouble(0,CHART_PRICE_MAX,0,max);
   ChartGetDouble(0,CHART_PRICE_MIN,0,min);   
   double labelOffset = (max  - min)*0.05;
      
   if(isUp){
      ArrowBuyCreate(0,arrowName,0,time,price,isUp,C'0,255,0',STYLE_SOLID,3);
      LabelCreate(labelName,0,time,price+labelOffset,"KUPUJ");            
   }
   else{
      ArrowBuyCreate(0,arrowName,0,time,price,isUp,C'255,0,0',STYLE_SOLID,3);
      labelOffset*=2;
      LabelCreate(labelName,0,time,price+labelOffset,"Sprzedaj");            
   }
   
   
   
   
   ChartRedraw();   
   
   
   return objectName;
  }
  
  
 void DeleteNotification(string name){
   ArrowBuyDelete(name+ArrowAlias);
   LabelDelete(name + LabelAlias);
}


void DeleteNotificationLabel(string name){
   LabelDelete(name + LabelAlias);
}

void ClearAllNotifications(){
   for(int i=0;i<counter;i++){
      DeleteNotification("Notification_" + (string)i+"_");
   }
}