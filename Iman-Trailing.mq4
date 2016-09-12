#property copyright "Iman Dezfuly"
#property link      "http://www.Iman.ir"
#define version      "201609122"

extern bool   AllPositions  =True;         // if true will effect all pairs, false only current chart
extern int    TrailingStop  =200;            // distance of trailing stop from price
extern int    TrailingStep  =50;             // will not change stoploss if distance less than a step
enum FiboRetrace {NoRetrace=0, MinRetrace, LowRetrace, HalfRetrace, MaxRetrace};
extern FiboRetrace  RetraceFactor=MaxRetrace; //  (1-RetraceFactor) * distace will be the base instead of distance itself.  

double Fibo[]={0.000, 0.236, 0.382, 0.500, 0.618};
float RetraceValue=Fibo[MaxRetrace];

  int init()
  {
  Print("Iman trailing stop version ",version);
  RetraceValue=Fibo[RetraceFactor];
  Print("Retrace Value set to:", RetraceValue);
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
            TrailingPositions();
           }
        }
     }
  }
  
   
//+------------------------------------------------------------------+
//|This function trails the position which is selected.                        |
//+------------------------------------------------------------------+
  void TrailingPositions() 
  {
   double pBid, pAsk, pp, pDiff, pRef, pStep, pRetraceTrail, pDirectTrail;
//----
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
            Print("diff:",pDiff," ref:", pRef," directTrail:", pDirectTrail," RetraceTrail:",pRetraceTrail);
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
            Print("diff:",pDiff," ref:", pRef," directTrail:", pDirectTrail," RetraceTrail:",pRetraceTrail);
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
   Print("Order ", OrderTicket(), " modified to Stoploss=",ldStopLoss);
   } else{
   Print("could not modify order:",OrderTicket());
   }
  }
//+------------------------------------------------------------------+