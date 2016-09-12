// Desphilboy position creator
#property copyright "Iman Dezfuly"
#property link      "http://www.Iman.ir"
#define version      "201608291"

#include "./desphilboy.mqh"

extern bool    CreatePositions = false;

extern int     NumberOfBuyStops  = 5;
extern int     NumberOfSellStops  = 5;

extern double  BuyLots = 0.01;
extern double  SellLots = 0.01;

extern int     PIPsFromAskToStartBuyStops = 70;
extern int     PIPsFromBidToStartSellStops = 70;

extern int     DistanceBetweenBuyStops = 70;
extern int     DistanceBetweenSellStops = 70;

extern Groups  BuyStopsGroup = UserGroup;
extern Groups  SellStopsGroup = UserGroup;


extern int StopLossBuys = 0;
extern int TakeProfitBuys = 0;

extern int StopLossSells = 0;
extern int TakeProfitSells = 0;

extern int TradesExpireAfterHours = 0;

extern color ColourBuys = clrNONE;
extern color ColourSells = clrNONE;
extern int Slippage = 15;

static bool once = true;

void init()
{
Print("Desphilboy position creator ",version, " on ", Symbol());

if ( CreatePositions ) { once = true; }

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

int createBuyStop( double price)
{
datetime now = TimeCurrent();
datetime expiry = TradesExpireAfterHours != 0 ? now + TradesExpireAfterHours * 3600 : 0;

double pip = MarketInfo(Symbol(), MODE_POINT);
double stopLoss = price - StopLossBuys * pip;
double takeProfit = price + TakeProfitBuys * pip;

int ticket = OrderSend(
                        Symbol(),                   // symbol
                        OP_BUYSTOP,                 // operation
                        BuyLots,                    // volume   
                        price,                      // price
                        Slippage,                   // slippage
                        stopLoss,                  // stop loss
                        takeProfit,                 // take profit
                        NULL,                      // comment
                        createMagicNumber(DesphilboyPositionCreator_ID, SellStopsGroup),           // magic number
                        expiry,                       // pending order expiration
                        ColourBuys                    // color
   );
   
if( ticket == -1 ) {
   Print( "Order creation failed for BuyStop at:", price);
   }
   else {
            Print("BuyStop created at ", price, " with ticket ", OrderTicket(), " Group ", getGroupName(OrderMagicNumber()));    
        }
   
return ticket;
}

int createSellStop( double price)
{
datetime now = TimeCurrent();
datetime expiry = TradesExpireAfterHours != 0 ? now + TradesExpireAfterHours * 3600 : 0;

double pip = MarketInfo(Symbol(), MODE_POINT);
double stopLoss = StopLossBuys !=0 ? price + StopLossBuys * pip : 0;
double takeProfit = TakeProfitBuys != 0 ? price - TakeProfitBuys * pip : 0;

int ticket = OrderSend(
                        Symbol(),                   // symbol
                        OP_BUYSTOP,                 // operation
                        BuyLots,                    // volume   
                        price,                      // price
                        Slippage,                   // slippage
                        stopLoss,                  // stop loss
                        takeProfit,                 // take profit
                        NULL,                      // comment
                        createMagicNumber(DesphilboyPositionCreator_ID, SellStopsGroup),           // magic number
                        expiry,                       // pending order expiration
                        ColourBuys                    // color
   );
   
if( ticket == -1 ) {
   Print( "Order creation failed for BuyStop at:", price);
   }
   else {
            Print("BuyStop created at ", price, " with ticket ", OrderTicket(), " Group ", getGroupName(OrderMagicNumber()));    
        }
   
return ticket;
}  