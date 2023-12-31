#include "Arrow.mqh"
#include "Label.mqh"
#include "Text.mqh"
#include "Rectangle.mqh"
#include "Trend.mqh"

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
const string RectangleFrameAlias = "Frame";
const string RectangleBackgroundAlias= "Background";
const string TrendAlias= "Trend";
int counter =0;
    
  //returns the object name
 string CreateNotfication(datetime   time=0,            // anchor point time
                         double     price=0,
                         bool isUp = true,
                         string bigLabelText1 = "empty",
                         string bigLabelText2 = "text",
                         datetime bigLabelTime = 0) {          // anchor point price){
   
   string objectName = "Notification_" + (string)counter+"_";   
   string labelName = objectName+LabelAlias;
   string labelBig1Name = objectName+LabelBigAlias+"_1";
   string labelBig2Name = objectName+LabelBigAlias+"_2";
   
   string rectangleFrame = objectName+RectangleFrameAlias;   
   string trendName = objectName+TrendAlias;   
   
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
  
   double labelBigOffset = (max  - min)*0.35;
      
   
   
   int x,y;
   ChartTimePriceToXY(0,0,bigLabelTime,price+labelBigOffset,x,y);      
   
   datetime left,right;
   double top,bottom;   
   int window;
   
   if(ChartXYToTimePrice(0,x+200,y-25,window,right,top)){      
      ChartXYToTimePrice(0,x-200,y+55,window,left,bottom);
      TrendCreate(0,trendName,0,right,bottom,time,price,C'255,0,0',0,1,false,false);
   }
   else{
      labelBigOffset*=-1;   
      ChartTimePriceToXY(0,0,bigLabelTime,price+labelBigOffset,x,y);      
      ChartXYToTimePrice(0,x+200,y-25,window,right,top);             
      ChartXYToTimePrice(0,x-200,y+55,window,left,bottom);                  
      
      
      TrendCreate(0,trendName,0,right,top,time,price,C'255,0,0',0,1,false,false);
   }
   RectangleCreate(0,rectangleFrame,0,left,top,right,bottom,C'255,0,0',0,1,false,false,false);
   TextCreate(0,labelBig1Name,0,bigLabelTime,price+labelBigOffset,bigLabelText1,"Arial", 15);
   TextCreate(0,labelBig2Name,0,bigLabelTime,price+labelBigOffset-labelOffset/2,bigLabelText2,"Arial", 15);
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
   LabelDelete(name + LabelBigAlias+"_1");
   LabelDelete(name + LabelBigAlias+"_2");
   
   RectangleDelete(name+ RectangleFrameAlias);   
   TrendDelete(name + TrendAlias);
}   

void ClearAllNotifications(){
   for(int i=0;i<counter;i++){
      DeleteNotification("Notification_" + (string)i+"_");
   }
}