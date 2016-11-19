#property copyright "Iman Dezfuly"
#property link      "http://www.Iman.ir"
#define version      "201609131"

#include "./desphilboy.mqh"

extern int OrderNumber = 0;
extern color LongColour = clrAliceBlue;
extern color MedColour = clrLightPink;
extern color ShortColour = clrKhaki;
extern color UserColour = clrOrange;


void init()
{
   Print("Desphilboy position marker ",version, " on ", Symbol());
   markPositions();
   //ExpertRemove();
   
}

int markPositions()
{
   
  for(int i=0; i<OrdersTotal(); i++) 
     {
      
        if ( OrderSymbol() == Symbol() && OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) 
        {
            OrderPrint(); 
            Print( "Order ", OrderTicket(), " has group ", getGroupName(OrderMagicNumber()));
            paintPosition();
           
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
 
 
void paintPosition()
{
       string name = "gmobj"; // + IntegerToString(OrderTicket());
        Print ("Chart id", name);
       /* bool bCreateResult = ObjectCreate(ChartID(), name, OBJ_ARROW_BUY,0, ChartTimeOnDropped(), OrderOpenPrice());
        if(bCreateResult){
            ObjectSetInteger(ChartID(),name,OBJPROP_COLOR,clrBeige);
        } else {
            Print("object creation unsuccessful");
        } */
}