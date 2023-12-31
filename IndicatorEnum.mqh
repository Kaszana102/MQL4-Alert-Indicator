//+------------------------------------------------------------------+
//|                                                IndicatorEnum.mqh |
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


enum IndicatorEnum{
   Moving_Average, //Moving Average   
   WSKAZNIK_2 //Wskaźnik 2
};

enum AverageEnum{
   SMA,
   EMA   
};

enum AlertsEnum{
   Brak,
   Przecięcie,
   Poziom
};

enum AlertsCountEnum{
   Za_każdym_razem, //Za każdym razem
   raz //Raz
};


enum LeverEnum{
   _10, //1:10
   _30, //1:30
   _100,//1:100
   _500 //1:500
};

int LeverToInt(LeverEnum lever){
   switch(lever){
      case(_10): return 10;
      case(_30): return 30;
      case(_100): return 100;
      case(_500): return 500;
      default: return -1;
   }
}