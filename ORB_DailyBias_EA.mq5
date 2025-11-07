
//--- Include necessary libraries
#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\SymbolInfo.mqh>
#include <Trade\AccountInfo.mqh>

//--- Global objects
CTrade         m_trade;
CPositionInfo  m_position;
CSymbolInfo    m_symbol;
CAccountInfo   m_account;

//--- Input parameters
input group "--- Strategy Settings ---"
input string InpSymbol      = "";            // Symbol to trade (Leave empty to use chart symbol)
input int    InpORBStartHour = 10;          // ORB Start Hour (Server Time) - Default 10:00 AM for Tadawul
input int    InpORBStartMinute = 0;         // ORB Start Minute (Server Time)
input int    InpORBDurationMinutes = 30;    // ORB Duration in Minutes
input ENUM_TIMEFRAMES InpBiasTimeframe = PERIOD_D1; // Timeframe for Daily Bias (e.g., D1)
input int    InpBiasMA_Period = 20;         // Moving Average Period for Bias

input group "--- Trading Parameters ---"
input double InpLots        = 0.01;        // Fixed Lot Size
input double InpRiskPercent = 1.0;         // Risk per trade as a percentage of balance (0.0 = fixed lots)
input int    InpTakeProfitPips = 1000;      // Take Profit in Points
input int    InpStopLossPips   = 500;       // Stop Loss in Points
input int    InpMaxSpreadPips  = 10;        // Maximum allowed spread in points
input int    InpMagicNumber = 12345;       // Magic Number for the EA

//--- Global variables
double g_ORB_High = 0.0;
double g_ORB_Low  = 0.0;
datetime g_ORB_Date = 0;
bool g_ORB_Calculated = false;
int g_Bias = 0; // 1=Bullish, -1=Bearish, 0=Neutral

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   //--- Set up trade object
   m_trade.SetExpertMagic(InpMagicNumber);
   m_trade.SetMarginMode();
   
   string symbol_name = InpSymbol;
   if (StringLen(symbol_name) == 0)
   {
      symbol_name = Symbol();
   }
   
   //--- Check symbol
   if (!m_symbol.Name(symbol_name))
   {
      Print("Failed to select symbol ", symbol_name);
      return(INIT_FAILED);
   }
   
   //--- Set up symbol properties
   m_symbol.RefreshRates();
   
   //--- Set up account info
   m_account.Refresh();
   
   Print("ORB_DailyBias_EA Initialized successfully for symbol: ", symbol_name);
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   Print("ORB_DailyBias_EA Deinitialized. Reason: ", reason);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   //--- Check if a new day has started
   if (TimeDay(TimeCurrent()) != TimeDay(g_ORB_Date))
   {
      g_ORB_Calculated = false;
      g_ORB_Date = TimeCurrent();
      g_Bias = 0;
      Print("New day started. Resetting ORB and Bias.");
   }
   
   //--- Calculate ORB and Bias if not done for the day
   if (!g_ORB_Calculated)
   {
      CalculateDailyBias();
      CalculateOpeningRange();
   }
   
   //--- Check for trading signal only if ORB is calculated and no position is open
   if (g_ORB_Calculated && !m_position.SelectBySymbol(m_symbol.Name()))
   {
      CheckForBreakout();
   }
}

//+------------------------------------------------------------------+
//| Calculate the Daily Bias using a Moving Average on a higher TF   |
//+------------------------------------------------------------------+
void CalculateDailyBias()
{
   //--- Check if the bias has already been calculated for the day
   if (g_Bias != 0) return;
   
   //--- Get the handle for the Moving Average indicator
   int ma_handle = iMA(m_symbol.Name(), InpBiasTimeframe, InpBiasMA_Period, 0, MODE_SMA, PRICE_CLOSE);
   if (ma_handle == INVALID_HANDLE)
   {
      Print("Error creating MA handle: ", GetLastError());
      return;
   }
   
   //--- Array to store MA values
   double ma_values[2];
   
   //--- Copy MA values (current and previous)
   if (CopyBuffer(ma_handle, 0, 0, 2, ma_values) != 2)
   {
      Print("Error copying MA buffer: ", GetLastError());
      return;
   }
   
   //--- Get current price on the bias timeframe
   MqlRates rates[1];
   if (CopyRates(m_symbol.Name(), InpBiasTimeframe, 0, 1, rates) != 1)
   {
      Print("Error copying rates for bias: ", GetLastError());
      return;
   }
   
   double current_close = rates[0].close;
   double ma_current = ma_values[0];
   
   //--- Determine bias
   if (current_close > ma_current)
   {
      g_Bias = 1; // Bullish
      Print("Daily Bias: BULLISH (Close > MA)");
   }
   else if (current_close < ma_current)
   {
      g_Bias = -1; // Bearish
      Print("Daily Bias: BEARISH (Close < MA)");
   }
   else
   {
      g_Bias = 0; // Neutral (should be rare)
      Print("Daily Bias: NEUTRAL");
   }
   
   //--- Free the indicator handle
   IndicatorRelease(ma_handle);
}

//+------------------------------------------------------------------+
//| Calculate the Opening Range High and Low                         |
//+------------------------------------------------------------------+
void CalculateOpeningRange()
{
   //--- Check if ORB has already been calculated
   if (g_ORB_Calculated) return;
   
   //--- Get current time
   MqlDateTime current_time;
   TimeToStruct(TimeCurrent(), current_time);
   
   //--- Check if we are past the ORB calculation time
   int current_minutes_of_day = current_time.hour * 60 + current_time.min;
   int start_minutes_of_day = InpORBStartHour * 60 + InpORBStartMinute;
   int end_minutes_of_day = start_minutes_of_day + InpORBDurationMinutes;
   
   // We only calculate the ORB after the end time has passed
   if (current_minutes_of_day < end_minutes_of_day)
   {
      return;
   }
   
   //--- Calculate the start time of the ORB period
   // We need to find the bar that corresponds to the InpORBStartHour:InpORBStartMinute
   datetime start_time = TimeCurrent();
   
   // Find the first bar of the day
   MqlRates rates_d1[1];
   if (CopyRates(m_symbol.Name(), PERIOD_D1, 0, 1, rates_d1) != 1)
   {
      Print("Error copying D1 rates for start time calculation: ", GetLastError());
      return;
   }
   datetime day_start = rates_d1[0].time;
   
   // Calculate the exact ORB start time on the current day
   start_time = day_start + start_minutes_of_day * 60;
   
   //--- Calculate the number of bars to look back on the M1 chart
   int bars_to_look = InpORBDurationMinutes;
   
   //--- Get the rates for the M1 timeframe
   MqlRates rates[];
   // Copy rates from the start_time for the duration
   if (CopyRates(m_symbol.Name(), PERIOD_M1, start_time, bars_to_look, rates) != bars_to_look)
   {
      PrintFormat("Error copying rates for ORB calculation. Start Time: %s, Bars: %d, Error: %d", 
                  TimeToString(start_time, TIME_DATE|TIME_MINUTES), bars_to_look, GetLastError());
      return;
   }
   
   //--- Find the High and Low of the range
   double high = 0.0;
   double low  = 999999.9; // A very high number
   
   for (int i = 0; i < bars_to_look; i++)
   {
      if (rates[i].high > high) high = rates[i].high;
      if (rates[i].low < low) low = rates[i].low;
   }
   
   //--- Store the results
   g_ORB_High = high;
   g_ORB_Low  = low;
   g_ORB_Calculated = true;
   
   PrintFormat("ORB Calculated. High: %f, Low: %f, Range: %f points", 
               g_ORB_High, g_ORB_Low, (g_ORB_High - g_ORB_Low) / m_symbol.Point());
}

//+------------------------------------------------------------------+
//| Check for a breakout signal                                      |
//+------------------------------------------------------------------+
void CheckForBreakout()
{
   //--- Get current price
   double current_bid = m_symbol.Bid();
   double current_ask = m_symbol.Ask();
   double spread_points = (current_ask - current_bid) / m_symbol.Point();
   
   //--- Check spread
   if (spread_points > InpMaxSpreadPips)
   {
      PrintFormat("Spread is too high (%d points). Waiting for better conditions.", (int)spread_points);
      return;
   }
   
   //--- Calculate trade parameters
   double lot_size = CalculateLotSize();
   if (lot_size <= 0.0)
   {
      Print("Calculated lot size is zero or negative. Check risk settings.");
      return;
   }
   
   double sl_points = InpStopLossPips;
   double tp_points = InpTakeProfitPips;
   
   //--- BUY Breakout Check (Price breaks above ORB High)
   if (current_bid > g_ORB_High)
   {
      if (g_Bias == 1) // Only take BUY if bias is BULLISH
      {
         double entry_price = current_ask;
         double sl_price = NormalizePrice(entry_price - sl_points * m_symbol.Point());
         double tp_price = NormalizePrice(entry_price + tp_points * m_symbol.Point());
         
         PrintFormat("BUY Signal (Bullish Bias). Entry: %f, SL: %f, TP: %f, Lots: %f", 
                     entry_price, sl_price, tp_price, lot_size);
                     
         if (m_trade.Buy(lot_size, m_symbol.Name(), entry_price, sl_price, tp_price, "ORB Buy"))
         {
            Print("BUY order successfully placed.");
         }
         else
         {
            Print("BUY order failed. Error: ", m_trade.ResultRetcode(), " - ", m_trade.ResultRetcodeDescription());
         }
      }
      else
      {
         Print("Breakout above ORB High, but Daily Bias is not Bullish (Bias: ", g_Bias, "). Skipping trade.");
      }
      
      //--- Prevent re-entry on the same breakout
      g_ORB_Calculated = false; 
      return;
   }
   
   //--- SELL Breakout Check (Price breaks below ORB Low)
   if (current_ask < g_ORB_Low)
   {
      if (g_Bias == -1) // Only take SELL if bias is BEARISH
      {
         double entry_price = current_bid;
         double sl_price = NormalizePrice(entry_price + sl_points * m_symbol.Point());
         double tp_price = NormalizePrice(entry_price - tp_points * m_symbol.Point());
         
         PrintFormat("SELL Signal (Bearish Bias). Entry: %f, SL: %f, TP: %f, Lots: %f", 
                     entry_price, sl_price, tp_price, lot_size);
                     
         if (m_trade.Sell(lot_size, m_symbol.Name(), entry_price, sl_price, tp_price, "ORB Sell"))
         {
            Print("SELL order successfully placed.");
         }
         else
         {
            Print("SELL order failed. Error: ", m_trade.ResultRetcode(), " - ", m_trade.ResultRetcodeDescription());
         }
      }
      else
      {
         Print("Breakout below ORB Low, but Daily Bias is not Bearish (Bias: ", g_Bias, "). Skipping trade.");
      }
      
      //--- Prevent re-entry on the same breakout
      g_ORB_Calculated = false; 
      return;
   }
}

//+------------------------------------------------------------------+
//| Calculates the lot size based on fixed lots or risk percentage   |
//+------------------------------------------------------------------+
double CalculateLotSize()
{
   if (InpRiskPercent <= 0.0)
   {
      //--- Fixed lot size
      return InpLots;
   }
   
   //--- Risk percentage calculation
   if (!m_account.Refresh() || !m_symbol.RefreshRates()) return 0.0;
   
   double account_balance = m_account.Balance();
   double risk_amount = account_balance * (InpRiskPercent / 100.0);
   
   //--- Stop Loss in currency (e.g., USD)
   double sl_points = InpStopLossPips;
   double point_value = m_symbol.TradeContractSize() * m_symbol.Point(); // Contract size * point value
   
   //--- Lot size calculation: Lot = Risk Amount / (SL in points * Point Value)
   double lot_size = risk_amount / (sl_points * point_value);
   
   //--- Normalize lot size to symbol's min/max/step
   lot_size = m_symbol.NormalizeLot(lot_size);
   
   PrintFormat("Risk Amount: %f, Calculated Lot Size: %f", risk_amount, lot_size);
   
   return lot_size;
}

//+------------------------------------------------------------------+
//| Helper function to normalize price to symbol's digits            |
//+------------------------------------------------------------------+
double NormalizePrice(double price)
{
   return NormalizeDouble(price, m_symbol.Digits());
}
//+------------------------------------------------------------------+
