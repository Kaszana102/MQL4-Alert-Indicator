#include "Arrow.mqh"
#include "Label.mqh"
#include "Text.mqh"

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
const string LabelBigAlias = "LabelBig";
int counter =0;
    
  //returns the object name
 string CreateNotfication(datetime   time=0,            // anchor point time
                         double     price=0,
                         bool isUp = true,
                         string bigLabelText = "empty",
                         datetime bigLabelTime = 0) {          // anchor point price){
   
   string objectName = "Notification_" + (string)counter+"_";   
   string labelName = objectName+LabelAlias;
   string labelBigName = objectName+LabelBigAlias;
   
   counter++;
   
   
   //calc label offset
   double max,min;
   ChartGetDouble(0,CHART_PRICE_MAX,0,max);
   ChartGetDouble(0,CHART_PRICE_MIN,0,min);   
   double labelOffset = (max  - min)*0.05;
      
   if(isUp){      
      LabelCreate(labelName,0,time,price-3*labelOffset,"KUPUJ ");            
   }
   else{      
      labelOffset*=2;
      LabelCreate(labelName,0,time,price+labelOffset,"Sprzedaj ");            
   }
   
   //calc big label offset   double max,min;
  
   double labelBigOffset = (max  - min)*0.25;
   //LabelCreate(labelBigName,0,bigLabelTime,price+labelBigOffset,bigLabelText,"Arial", 20);
   TextCreate(0,labelBigName,0,bigLabelTime,price+labelBigOffset,bigLabelText,"Arial", 20);
   
   
   
   ChartRedraw();   
   
   
   return objectName;
  }
  
  
  
  
 void CreateArrow(datetime   time=0,            // anchor point time
                         double     price=0,
                         bool isUp = true){
                         
   string arrowName = ArrowAlias + (string)counter++;   
                                                  
                         
   if(isUp){
      ArrowBuyCreate(0,arrowName,0,time,price,isUp,C'0,255,0',STYLE_SOLID,3);      
   }
   else{
      ArrowBuyCreate(0,arrowName,0,time,price,isUp,C'255,0,0',STYLE_SOLID,3);      
   }
}

void DeleteArrow(string name){
   ArrowBuyDelete(name);
}


void DeleteAllArrows(){
   for(int i=0;i<counter;i++){
      DeleteArrow(ArrowAlias + (string)i);
   }
}
  
 void DeleteNotification(string name){   
   LabelDelete(name + LabelAlias);
}


void DeleteNotificationLabel(string name){
   LabelDelete(name + LabelAlias);
   LabelDelete(name + LabelBigAlias);
}

void ClearAllNotifications(){
   for(int i=0;i<counter;i++){
      DeleteNotification("Notification_" + (string)i+"_");
   }
}