// simple trailing stop
#property copyright "Iman Dezfuly"
#property link      "http://www.Iman.ir"

#define version      "201609121"

#include "./desphilboy.mqh"

extern bool   AllPositions  =True;         
extern int    TrailingStopL = 450, TrailingStopM = 270, TrailingStopS = 150, TrailingStopU = 100;            
extern int    TrailingStepL  =70, TrailingStepM = 60, TrailingStepS = 50, TrailingStepU = 40;             
extern FiboRetrace  RetraceFactorL=MaxRetrace, RetraceFactorM = HalfRetrace, RetraceFactorS = LowRetrace, RetraceFactorU = MinRetrace;


int init()
{
  Print("Grouped trailing stop version ",version);
  Print("stops(L,M,S,U):", TrailingStopL, ",", TrailingStopM, ",", TrailingStopS, ",", TrailingStopU); 
  Print("steps(L,M,S,U):", TrailingStepL, ",", TrailingStepM, ",", TrailingStepS, ",", TrailingStepU);
  Print("Retraces(L,M,S,U):", RetraceFactorL, ",", RetraceFactorM, ",", RetraceFactorS, ",", RetraceFactorU);
  return(0); 
}

//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
  void start() 
  {
     for(int i=0; i<OrdersTotal(); i++) 
     {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) 
        {
           if (AllPositions || OrderSymbol()==Symbol()) 
           {
               if(isLongTerm(OrderMagicNumber())) {TrailingPositions(TrailingStopL, TrailingStepL, RetraceFactorL);}
                  else if(isMediumTerm(OrderMagicNumber())){TrailingPositions(TrailingStopM, TrailingStepM, RetraceFactorM);}
                     else if(isShortTerm(OrderMagicNumber())){TrailingPositions(TrailingStopS, TrailingStepS, RetraceFactorS);}
                        else if(isUserGroup(OrderMagicNumber())){TrailingPositions(TrailingStopU, TrailingStepU, RetraceFactorU);}
           }
        }
     }
  }
  
   
//+------------------------------------------------------------------+
//|This function trails the position which is selected.                        |
//+------------------------------------------------------------------+
  void TrailingPositions(int TrailingStop, int TrailingStep,FiboRetrace RetraceFactor) 
  {
   double pBid, pAsk, pp, pDiff, pRef, pStep, pRetraceTrail, pDirectTrail;
//----

   double RetraceValue=Fibo[RetraceFactor];
   pp=MarketInfo(OrderSymbol(), MODE_POINT);
   pDirectTrail = TrailingStop * pp;
   pStep = TrailingStep * pp;
   
     if (OrderType()==OP_BUY) 
     {
      pBid = MarketInfo(OrderSymbol(), MODE_BID);
      pDiff = pBid - OrderOpenPrice();
      pRetraceTrail = pDiff > pDirectTrail ? (pDiff - pDirectTrail) * RetraceValue : 0;
      pRef = pBid - pDirectTrail - pRetraceTrail; 
      
        if (pRef - OrderOpenPrice() > 0 ) 
        {// order is in profit.
           if ((OrderStopLoss() != 0.0 && pRef - OrderStopLoss() > pStep) || (OrderStopLoss() == 0.0 && pRef - OrderOpenPrice() > pStep)) 
           {
            ModifyStopLoss(pRef);
            return;
           }
        }
     }
     
     if (OrderType()==OP_SELL) 
     {
      pAsk = MarketInfo(OrderSymbol(), MODE_ASK);
      pDiff = OrderOpenPrice() - pAsk;
      pRetraceTrail = pDiff > pDirectTrail ? (pDiff - pDirectTrail) * RetraceValue : 0;
      pRef = pAsk + pDirectTrail + pRetraceTrail; 
      
        if (OrderOpenPrice()- pRef > 0) 
        {// order is in profit.
           if ((OrderStopLoss() != 0.0 && OrderStopLoss() - pRef > pStep) || (OrderStopLoss() == 0.0 && OrderOpenPrice() - pRef > pStep))
           {
            ModifyStopLoss(pRef);
            return;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|   this modifies a selected order and chages its stoploss                                      |
//|                                           
//|   Params: ldStopLoss  , double is the new value for stoploss                          
//+------------------------------------------------------------------+
  void ModifyStopLoss(double ldStopLoss) 
  {
   bool fm;
   fm=OrderModify(OrderTicket(),OrderOpenPrice(),ldStopLoss,OrderTakeProfit(),0,CLR_NONE);
   
   if (fm){
   Print("Order ", OrderTicket(), " modified to Stoploss=",ldStopLoss," group:", getGroupName(OrderMagicNumber()));
   } else{
   Print("could not modify order:",OrderTicket(), " group:", getGroupName(OrderMagicNumber()));
   }
  }
//+------------------------------------------------------------------+