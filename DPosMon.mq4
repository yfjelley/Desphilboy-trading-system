#property copyright "Iman Dezfuly"
#property link      "http://www.Iman.ir"
#define version      "20161131"

#include "./desphilboy.mqh"

extern int OrderNumber = 0;

void init()
{
   Print("Desphilboy position marker ",version, " on ", Symbol());
   markPositions();
   ExpertRemove();
}

int markPositions()
{
   
  for(int i=0; i<OrdersTotal(); i++) {
      
      if ( OrderSymbol() == Symbol() && OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            OrderPrint(); 
            Print( "Order ", OrderTicket(), " has group ", getGroupName(OrderMagicNumber()));
      }
   }
      
   if( OrderNumber !=0 ){
         if(OrderSelect(OrderNumber, SELECT_BY_TICKET, MODE_TRADES)){
            OrderPrint(); 
            Print( "Order ", OrderTicket(), " has group ", getGroupName(OrderMagicNumber()));
         }
   }
   return(0); 
}


 