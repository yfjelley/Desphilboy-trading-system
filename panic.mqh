//+------------------------------------------------------------------+
//|                                                        Panic.mqh |
//|                                                       Desphilboy |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Desphilboy"
#property link      "https://www.mql5.com"
#property strict

#include "./desphilboy.mqh"

static double tickValue
static double exTickIncrement[7];
static double AvgTickIncrement[7];
static double dpOdt[7];
static double 



/*
* the following functions calculate a discontinuity index of price or gapIndex  exponential
* Params: 
* string pairName, is the symbol you want to calculate ga[p index for it.
* int depth, number of time frames to go back 
* expFactor, less than 1 and greater than zero is the amount of emphasis you put on previouse avg in calculation expFactor = 0 means less emphasis 
*/
double gapIndexExp(string pairName, ENUM_TIMEFRAMES timeFrame = PERIOD_M1 , int depth = 10, double expFactor = 0.5){
MqlRates priceData[100];
   ArraySetAsSeries(priceData, false);
   
   if(expFactor > 1 || expFactor < 0) expFactor = 0.5;
   double vpoint  = MarketInfo(pairName, MODE_POINT);
   
   int numPrices = CopyRates(
                           pairName,      // symbol name
                           timeFrame,        // period
                           0,        // start position
                           depth,            // data count to copy
                           priceData    // target array for tick volumes
                           );
   
   if(numPrices < 2) { 
                     Print( "Error getting ", depth, " price informations for gap index calculation."); 
                     return -1;
   }     
              
   double result = 0;
   for( int i= 1; i < numPrices; ++i){
         result = result * expFactor + MathAbs(priceData[i].open - priceData[i - 1].close)/vpoint * ( 1- expFactor);
   } 
   
   return result;
}

/*
* the following functions calculate a discontinuity index of price or gapIndex  simple
* Params: 
* string pairName, is the symbol you want to calculate ga[p index for it.
* int depth, number of time frames to go back 
*/
double gapIndex(string pairName, ENUM_TIMEFRAMES timeFrame = PERIOD_M1 , int depth = 10){
MqlRates priceData[100];
   ArraySetAsSeries(priceData, false);
   
   double vpoint  = MarketInfo(pairName, MODE_POINT);
   
   int numPrices = CopyRates(
                           pairName,      // symbol name
                           timeFrame,        // period
                           0,        // start position
                           depth,            // data count to copy
                           priceData    // target array for tick volumes
                           );
   
   if(numPrices < 2) { 
                     Print( "Error getting ", depth, " price informations for gap index calculation."); 
                     return -1;
   }     
              
   double sum = 0;
   for( int i= 1; i < numPrices; ++i){
         sum = sum  + MathAbs(priceData[i].open - priceData[i - 1].close)/vpoint;
   } 
   return sum/(numPrices -1);
}



/*
* the following functions calculate a discontinuity index of price or gapIndex  exponential
* Params: 
* string pairName, is the symbol you want to calculate ga[p index for it.
* int depth, number of time frames to go back 
* expFactor, less than 1 and greater than zero is the amount of emphasis you put on previouse avg in calculation expFactor = 0 means less emphasis 
*/
double volAvExp(string pairName, ENUM_TIMEFRAMES timeFrame = PERIOD_M1 , int depth = 10, double expFactor = 0.5){
long volData[100];
   ArraySetAsSeries(volData, false);
   
   if(expFactor > 1 || expFactor < 0) expFactor = 0.5;
   
   int numPrices = CopyTickVolume(
                           pairName,      // symbol name
                           timeFrame,        // period
                           0,        // start position
                           depth,            // data count to copy
                           volData    // target array for tick volumes
                           );
   
   if(numPrices < 2) { 
                     Print( "Error getting ", depth, " volume informations for vol index calculation."); 
                     return -1;
   }     
              
   double result = 0;
   for( int i= 0; i < numPrices; ++i){
         result = result * expFactor + volData[i] * ( 1- expFactor);
   } 
   
   return result;
}

/*
* the following functions calculate a discontinuity index of price or gapIndex  simple
* Params: 
* string pairName, is the symbol you want to calculate ga[p index for it.
* int depth, number of time frames to go back 
*/
double volAv(string pairName, ENUM_TIMEFRAMES timeFrame = PERIOD_M1 , int depth = 10){
long volData[100];
   ArraySetAsSeries(volData, false);
   
   double vpoint  = MarketInfo(pairName, MODE_POINT);
   
   int numPrices = CopyTickVolume(
                           pairName,      // symbol name
                           timeFrame,        // period
                           0,        // start position
                           depth,            // data count to copy
                           volData    // target array for tick volumes
                           );
   
   if(numPrices < 2) { 
                     Print( "Error getting ", depth, " price informations for gap index calculation."); 
                     return -1;
   }     
              
   double sum = 0;
   for( int i= 0; i < numPrices; ++i){
         sum = sum  + volData[i];
   } 
   return sum/(numPrices);
}