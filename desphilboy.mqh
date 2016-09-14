// heaer file for desphilboy
//+------------------------------------------------------------------+
//|                                                   desphilboy.mqh |
//|                                                       Desphilboy |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Desphilboy"
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// desphilboy system unique Identifier is Mahmaraza Rahvareh My best friend who died in Motorcycle accident
#define     MAHMARAZA_RAHVARA_ID 1921              // He loved this number, was his magic number

// 3 default groups IDs long term, medium term and short term positions plus one custom group for user
#define     LONGTERMGROUP     10000
#define     MEDTERMGROUP      20000
#define     SHORTTERMGROUP    30000
#define     USERGROUP         40000

enum Groups { NoGroup=0, LongTerm=LONGTERMGROUP, MediumTerm=MEDTERMGROUP, ShortTerm=SHORTTERMGROUP, UserGroup=USERGROUP };
enum BuyTypes { Buy, BuyLimit, BuyStop};
enum SellTypes { Sell, SellLimit, SellStop}; 
 

// EA signature on the position
#define     ImanTrailing_ID               100000
#define     GroupedImanTrailing_ID        200000
#define     DesphilboyPositionCreator_ID  300000
#define     DAPositionCreator_ID          400000

// fibonacci
enum FiboRetrace {NoRetrace=0, MinRetrace, LowRetrace, HalfRetrace, MaxRetrace};
double Fibo[]={0.000, 0.236, 0.382, 0.500, 0.618};

// common functions to work with Magic Numbers
int createMagicNumber( int eaId, int groupId)
{
   return eaId + groupId + MAHMARAZA_RAHVARA_ID;
}

bool isDesphilboy( int magicNumber)
{
   return (magicNumber % 10000) == MAHMARAZA_RAHVARA_ID;
}

bool isLongTerm( int magicNumber)
{
   if(isDesphilboy(magicNumber)){
      return ((magicNumber % 100000) - MAHMARAZA_RAHVARA_ID) == LONGTERMGROUP;
   }
   return false;
}

bool isShortTerm( int magicNumber)
{
   if(isDesphilboy(magicNumber)){
      return ((magicNumber % 100000) - MAHMARAZA_RAHVARA_ID) == SHORTTERMGROUP;
   }
   return false;
}


bool isMediumTerm( int magicNumber)
{
   if(isDesphilboy(magicNumber)){
      return ((magicNumber % 100000)- MAHMARAZA_RAHVARA_ID) == MEDTERMGROUP;
   }
   return false;
}


bool isUserGroup( int magicNumber)
{
   if(isDesphilboy(magicNumber)){
      return ((magicNumber % 100000)- MAHMARAZA_RAHVARA_ID) == USERGROUP;
   }
   return false;
}

bool isManual(int magicNumber)
{
return magicNumber == 0;
}


string getGroupName( int magicNumber)
{
   if(isLongTerm(magicNumber)) { return "LongTerm"; }
      else if(isMediumTerm(magicNumber)){return "MediumTerm";}
               else if(isShortTerm(magicNumber)){return "ShortTerm";}
                        else if(isUserGroup(magicNumber)){return "UserGroup";}
                                 else if(isManual(magicNumber)){ return "Manual";}
                                          else return "Unknown";

}


Groups getGroup( int magicNumber )
{
if(isLongTerm(magicNumber)) { return LongTerm; }
      else if(isMediumTerm(magicNumber)){return MediumTerm;}
               else if(isShortTerm(magicNumber)){return ShortTerm;}
                        else if(isUserGroup(magicNumber)){return UserGroup;}
return NoGroup;
}