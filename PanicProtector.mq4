//+------------------------------------------------------------------+
//|                                               PanicProtector.mq4 |
//|                                                       Desphilboy |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Desphilboy"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


#include "./desphilboy.mqh"
#include "./panic.mqh"

//--- input parameters
input int      PanicTrailing=50;
input int      PanicStep=50;
input int      PanicRetrace=0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   bool  bResult = EventSetMillisecondTimer( 4000 );
      
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
      
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
  
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
  // Print ( "Exp gapIndex of    (", Symbol(), ", 10) is:", gapIndexExp( Symbol())); 
  // Print ( "Simple gapIndex of (", Symbol(), ", 10) is:", gapIndex( Symbol())); 
  // Print ( "Exp volAv of       (", Symbol(), ", 10) is:", volAvExp( Symbol())); 
  // Print ( "Simple volAv of    (", Symbol(), ", 10) is:", volAv( Symbol())); 
  }
//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
//---
   double ret=0.0;
//---

//---
   return(ret);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   
  }
//+------------------------------------------------------------------+
