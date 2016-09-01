#property copyright "Iman Dezfuly"
#property link      "http://www.Iman.ir"
#define version      "201608291"

#include "./desphilboy.mqh"

extern int     NumberOfBuyStops  = 5;
extern int     DistanceBetweenBuyStops = 70;
extern int     PIPsFromAskToStartBuyStops = 70;
extern Groups  BuyStopsGroup = UserGroup;
extern double  BuyLots = 0.01;

extern int     NumberOfSellStops  = 5;
extern int     DistanceBetweenSellStops = 70;
extern int     PIPsFromBidToStartSellStops = 70;
extern Groups  SellStopsGroup = UserGroup;
extern double  SellLots = 0.01;

extern int Slippage = 15;

static bool once = true;

int init()
{
Print("Desphilboy position creator ",version, " on ", Symbol());
return 0;
}

int doPositions()
{
   
   double pip = MarketInfo(Symbol(), MODE_POINT);
     
   for(int i=0; i< NumberOfBuyStops; ++i){
   int result = OrderSend(
   Symbol(),              // symbol
   OP_BUYSTOP,                 // operation
   BuyLots,              // volume
   Ask + ( DistanceBetweenBuyStops * i + PIPsFromAskToStartBuyStops) * pip,               // price
   Slippage,            // slippage
   0,            // stop loss
   0,          // take profit
   NULL,        // comment
   createMagicNumber(DesphilboyPositionCreator_ID, BuyStopsGroup),           // magic number
   0,        // pending order expiration
   clrNONE  // color
   );
   if(result == -1) { Print( "failed to open order number:", i);}
      else{ Print( OrderType(), " Order ", OrderTicket(), " opened at", OrderOpenPrice());}
   }

   for(int j=0; j< NumberOfSellStops; ++j){
   int result = OrderSend(
   Symbol(),              // symbol
   OP_SELLSTOP,                 // operation
   SellLots,              // volume
   Bid - ( DistanceBetweenBuyStops * j + PIPsFromAskToStartBuyStops) * pip,               // price
   Slippage,            // slippage
   0,            // stop loss
   0,          // take profit
   NULL,        // comment
   createMagicNumber(DesphilboyPositionCreator_ID, SellStopsGroup),           // magic number
   0,        // pending order expiration
   clrNONE  // color
   );
   if(result == -1) { Print( "failed to open order number:", j);}
      else{ Print( OrderType(), " Order ", OrderTicket(), " opened at", OrderOpenPrice());}
   }

   return(0); 
}



//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
  void start() 
  {
  if(once) 
   {
      doPositions();
      once = false;
      if(!once) {
         ExpertRemove();
      }
   }
     return;
  }
  
