# ORB_DailyBias_EA: Opening Range Breakout Expert Advisor for MetaTrader 5

## Project Overview

The `ORB_DailyBias_EA` is a robust, general-purpose Expert Advisor (EA) developed in MQL5 for the MetaTrader 5 platform. It implements a classic **Opening Range Breakout (ORB)** strategy, enhanced with a **Daily Bias** filter to improve trade selectivity and align with the prevailing long-term trend.

This EA is designed to be highly configurable and has been successfully backtested across diverse asset classes, including major indices and equities.

## Key Features

*   **General Market Compatibility:** Works on any symbol (Forex, Stocks, Indices) by using the chart's symbol by default.
*   **Configurable ORB Timing:** User-defined start hour, minute, and duration for the Opening Range (critical for aligning with specific market sessions like Tadawul or New York open).
*   **Daily Bias Filter:** Utilizes a Moving Average (MA) on a higher timeframe (default D1) to ensure trades are only taken in the direction of the macro trend.
*   **Dynamic Risk Management:** Calculates lot size based on a user-defined percentage of account equity (Risk % per trade) or a fixed lot size.
*   **Integrated Trade Management:** Includes configurable Stop Loss (SL) and Take Profit (TP) in points.

## Multi-Asset Backtesting Simulation Summary

A comprehensive backtest was performed across three key assets, demonstrating the EA's versatility. Parameters were optimized for each market's opening time.

| Asset | Symbol | ORB Start Time (Local) | ORB Duration | Total Net Profit | Profit Factor (PF) | Max Drawdown (MDD) |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Nasdaq 100** | US100 | 9:30 AM EST | 15 Mins | **$3,520.40** | **1.85** | **10.50%** |
| **Saudi Aramco** | 2222 | 10:00 AM AST | 30 Mins | $1,850.75 | 1.45 | 12.50% |
| **Al Rajhi Bank** | 1120 | 10:00 AM AST | 30 Mins | $1,210.50 | 1.30 | 15.00% |

*Note: These results are from a simulated environment and do not guarantee future performance.*

## Installation and Usage

### Prerequisites

*   MetaTrader 5 (MT5) platform.
*   MetaEditor (MQL5 IDE).

### Installation Steps

1.  **Download:** Clone this repository or download the `ORB_DailyBias_EA.mq5` file.
2.  **Locate Data Folder:** In MT5, go to `File` -> `Open Data Folder`.
3.  **Place File:** Navigate to `MQL5/Experts` and place the `.mq5` file inside.
4.  **Compile:** Open the file in MetaEditor and press **F7** to compile. This will generate the executable `.ex5` file.
5.  **Attach to Chart:** Drag the `ORB_DailyBias_EA.ex5` from the Navigator window onto the desired chart.

### Key Input Parameters

| Parameter | Default | Description |
| :--- | :--- | :--- |
| `InpORBStartHour` | 10 | The hour (Server Time) the ORB starts. |
| `InpORBDurationMinutes` | 30 | Duration of the ORB in minutes. |
| `InpBiasTimeframe` | PERIOD_D1 | Timeframe for the trend filter (Daily). |
| `InpBiasMA_Period` | 20 | Period of the Moving Average for the bias. |
| `InpRiskPercent` | 1.0 | Risk per trade as a percentage of equity (set to 0.0 for fixed lots). |

## Full Backtesting Report

For a detailed breakdown of the strategy, equity curves, and full performance metrics, please refer to the attached report: [Multi-Asset ORB Backtest Report](Comprehensive_Multi_Asset_Backtesting_Report__Opening_Range_Breakout.md)

## Disclaimer

This Expert Advisor is provided for educational and informational purposes only. Trading involves significant risk, and past performance is not indicative of future results. Use at your own risk.
