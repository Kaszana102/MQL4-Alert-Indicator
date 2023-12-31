//+------------------------------------------------------------------+
//|                                                     Increase.mqh |
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


//returns the average of the increase of n last crossess
//on buffors

double GetIncrease( double& buf1[], double& buf2[],const double& prices[], int n=5){   
   int rangeStart = -1;
   int rangeEnd = -1;
   int bufSize = ArraySize(buf1);
   int crossIndex = 1;
   
   double increasesArray[];
   int elementsNumber = 0;
   
   ArrayResize(increasesArray,n);
   
   //dla każdego przedziału
   for(int i=0;i<n;i++){
      bool found = false;
      
      //find first cross
      while(!found && crossIndex < bufSize-1){
         if(cross(buf1[crossIndex],buf1[crossIndex-1], buf2[crossIndex],buf2[crossIndex-1])){
            found = true;
            rangeEnd=crossIndex;
         }
         crossIndex++;
      }
      
      found = false;
      //find second cross
      while(!found && crossIndex < bufSize){
         if(cross(buf1[crossIndex],buf1[crossIndex-1], buf2[crossIndex],buf2[crossIndex-1])){
            found = true;
            rangeStart=crossIndex;
         }
         crossIndex++;
      }
      
      if(found){
         increasesArray[i] = GetRelativeDif(prices,rangeStart,rangeEnd);
         elementsNumber++;
      }
   }
   
   double average = 0;
   for(int i=0;i<elementsNumber;i++){
      average+=increasesArray[i];
   }
   if(elementsNumber>0){
      average/=elementsNumber;
   }   
   
   return average;
}




//start index is on the left on the graph
double GetRelativeDif(const double & buf[], int startIndex, int endIndex){

   double max= FLT_MIN;
   double min= FLT_MAX ;

   for(int i=startIndex-1; i>=endIndex; i--){
      if(buf[i]>max){
         max = buf[i];
      }
      
      if(buf[i]<min){
         min = buf[i];
      }
   }
   
   //punkt przeciecia
   double pp = buf[startIndex];
   
   if(max- pp> pp - min){
      //wzrost
      return (max -pp)/pp;
   }
   else{
      //spadek
      return (min -pp)/pp;
   }      
}



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


double crossValue(double a1,double a2, double b1, double b2){
   return 1.5;
}
