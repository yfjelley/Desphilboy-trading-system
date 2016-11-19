//+------------------------------------------------------------------+
//|                                                        Panic.mqh |
//|                                                       Desphilboy |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Desphilboy"
#property link      "https://www.mql5.com"
#property strict

#include "./desphilboy.mqh"



/*
* the following functions calculate a discontinuity index of price or gapIndex 
* Params: 
* string pairName, is the symbol you want to calculate ga[p index for it.
* int depth, number of time frames to go back 
* expFactor, less than 1 and greater than zero is the amount of emphasis you put on previouse avg in calculation expFactor = 0 means less emphasis 
*/
double gapIndexExp(string pairName, ENUM_TIMEFRAMES timeFrame = PERIOD_M1 , int depth = 10, double expFactor = 0.667){
MqlRates priceData[];
   
   ArraySetAsSeries(priceData, true);

   if(expFactor > 1 || expFactor < 0) expFactor = 0.667;
   
   int numPrices = CopyRates(
                           pairName,      // symbol name
                           timeFrame,        // period
                           0,        // start position
                           depth,            // data count to copy
                           priceData    // target array for tick volumes
                           );
   
   if(numPrices < 1) { 
                     Print( "Error getting ", depth, " price informations for gap index calculation."); 
                     return -1;
   }     
              
   double result = 0;
   for( int i= numPrices - 1; i >= 0; --i){
      result = result * expFactor + (priceData[i].open - priceData[i + 1].close) * ( 1- expFactor);
   } 
   
   return result;
}

