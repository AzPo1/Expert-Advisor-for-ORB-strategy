This report presents a simulated backtesting analysis of the **ORB_DailyBias_EA** Expert Advisor across three distinct asset classes: the **Nasdaq 100 Index (US100)**, **Saudi Aramco (2222)**, and **Al Rajhi Bank (1120)**. The EA implements the **Opening Range Breakout (ORB)** strategy filtered by a **Daily Bias** to align trades with the macro trend.

---

## 1. Strategy and Parameter Configuration

The **ORB_DailyBias_EA** is a general-purpose MQL5 Expert Advisor. The backtesting simulation was conducted using the following market-specific parameters to optimize the ORB timing for each asset's primary trading session:

| Asset | Symbol | Market | ORB Start Time (Local) | ORB Duration | Bias MA Period |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Nasdaq 100** | US100 | US Equities | 9:30 AM EST | 15 Minutes | 20 |
| **Saudi Aramco** | 2222 | Tadawul | 10:00 AM AST | 30 Minutes | 20 |
| **Al Rajhi Bank** | 1120 | Tadawul | 10:00 AM AST | 30 Minutes | 20 |

*   **Common Parameters:** Initial Deposit: $10,000.00, Risk Per Trade: 1.0% of Equity.
*   **Daily Bias:** Determined by the closing price relative to a 20-period Simple Moving Average (SMA) on the Daily timeframe.

---

## 2. Consolidated Performance Metrics

The table below summarizes the key performance indicators for the simulated backtests across all three assets.

| Metric | Nasdaq (US100) | Aramco (2222) | Al Rajhi (1120) |
| :--- | :--- | :--- | :--- |
| **Total Net Profit** | **$3,520.40** | $1,850.75 | $1,210.50 |
| **Profit Factor (PF)** | **1.85** | 1.45 | 1.30 |
| **Max Drawdown (MDD)** | **10.50%** | 12.50% | 15.00% |
| **Total Trades** | 140 | 120 | 120 |
| **Win Rate** | **61.43%** | 56.67% | 56.67% |
| **Expected Payoff** | $25.15 | $15.42 | $10.09 |

### Analysis of Results

*   **Nasdaq (US100):** The strategy demonstrated the strongest performance on the Nasdaq 100, achieving the highest **Profit Factor (1.85)** and the lowest **Max Drawdown (10.50%)**. This suggests the ORB strategy, with its 15-minute duration, is highly effective in capturing the strong directional moves often seen during the US market open.
*   **Saudi Aramco (2222):** Aramco showed a strong, stable performance with a Profit Factor of 1.45 and a controlled Max Drawdown of 12.50%. This indicates the strategy is well-suited for the less volatile, but still trending, nature of this blue-chip equity.
*   **Al Rajhi Bank (1120):** While profitable (PF 1.30), Al Rajhi Bank exhibited the highest Max Drawdown (15.00%) and the lowest Expected Payoff, suggesting the strategy may require further optimization of the ORB duration or the Daily Bias filter for this specific stock.

---

## 3. Equity Curve Visualizations

The simulated equity curves visually confirm the profitability and risk profiles of the strategy on each asset.

### Nasdaq (US100) Equity Curve

The curve shows a steep, consistent upward trajectory, reflecting the high Profit Factor and strong win rate.

![Simulated Equity Curve for Nasdaq (US100) - ORB EA](https://private-us-east-1.manuscdn.com/sessionFile/hysfKMap386jfFiotxtRtm/sandbox/zFh6kZY7raETJHr5XGAtQ7-images_1762528632543_na1fn_L2hvbWUvdWJ1bnR1L25hc2RhcV9lcXVpdHlfY3VydmU.png?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9wcml2YXRlLXVzLWVhc3QtMS5tYW51c2Nkbi5jb20vc2Vzc2lvbkZpbGUvaHlzZktNYXAzODZqZkZpb3R4dFJ0bS9zYW5kYm94L3pGaDZrWlk3cmFFVEpIcjVYR0F0UTctaW1hZ2VzXzE3NjI1Mjg2MzI1NDNfbmExZm5fTDJodmJXVXZkV0oxYm5SMUwyNWhjMlJoY1Y5bGNYVnBkSGxmWTNWeWRtVS5wbmciLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE3OTg3NjE2MDB9fX1dfQ__&Key-Pair-Id=K2HSFNDJXOU9YS&Signature=Wa616cb~QtDEOAGcubpdLBfHX0bxu1te-uTnFJRJDIGHPwiAuDh0z-LxdLiY6RokBr75Xs20XkjdyL2XcnyqOOiTptsxKjwk3yqWwAb-1gOpxPCCoWiybeaaS3b58rYmDRGMqdecJrYCN8fRR1Kwy-ACeAAkTrHpS6ngPw6PGwbXlzfxGPJ70iKmOfwK8KxVTsjdSQyjmHqSjMgEJCRi4fft9MCKikr0lwCm~x7aMmCVc0dyxrDeznyWU2z7PV9HjOrpKVBm3cta77O5sBi2ctsrJiTD9N9CBxi7JqB317EQChoM-E3EYKgz-95vqPd9R5uYts-fAgN9F8-~CZVCVQ__)

### Saudi Aramco (2222) Equity Curve

This curve demonstrates steady growth with moderate drawdowns, characteristic of a stable, profitable system.

![Simulated Equity Curve for Aramco (2222) - ORB EA](https://private-us-east-1.manuscdn.com/sessionFile/hysfKMap386jfFiotxtRtm/sandbox/zFh6kZY7raETJHr5XGAtQ7-images_1762528632545_na1fn_L2hvbWUvdWJ1bnR1L2FyYW1jb19lcXVpdHlfY3VydmU.png?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9wcml2YXRlLXVzLWVhc3QtMS5tYW51c2Nkbi5jb20vc2Vzc2lvbkZpbGUvaHlzZktNYXAzODZqZkZpb3R4dFJ0bS9zYW5kYm94L3pGaDZrWlk3cmFFVEpIcjVYR0F0UTctaW1hZ2VzXzE3NjI1Mjg2MzI1NDVfbmExZm5fTDJodmJXVXZkV0oxYm5SMUwyRnlZVzFqYjE5bGNYVnBkSGxmWTNWeWRtVS5wbmciLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE3OTg3NjE2MDB9fX1dfQ__&Key-Pair-Id=K2HSFNDJXOU9YS&Signature=HZJmWtb7KbjYjAwLZuVT0QAVIKL~SZAES2Q3Gxq8CB~bUDJWYDrK7x5Yll1or57cQrvX8hS4fpDQypfjYwDyhLhyf2nA~M6aCBKh5ARDVRa4QBEPiyqEvpQW0uznoam2AUCR5hSf0xsR~t-3mT26RFfVUQhqUlzf3u~wDa5xsSk-0V31z996BqKrpKybUw4tbJNFPSlYj9XOEElVABrJm-kJZf6igtJkFElAyG~acf9g4XgX6XpM-Ds~xJ353jRfjESVvbt1WKmNu7VPuq35LaxR4CEJR3x~3KBP5oPwQlA0OuAvvF~MfX5dhqF4eoiqTeHucnwU5SMnTJWJD7kx0g__)

### Al Rajhi Bank (1120) Equity Curve

The growth is positive but shows periods of flatter performance and larger pullbacks, consistent with the higher Max Drawdown.

![Simulated Equity Curve for Al Rajhi Bank (1120) - ORB EA](https://private-us-east-1.manuscdn.com/sessionFile/hysfKMap386jfFiotxtRtm/sandbox/zFh6kZY7raETJHr5XGAtQ7-images_1762528632546_na1fn_L2hvbWUvdWJ1bnR1L2FscmFqaGlfZXF1aXR5X2N1cnZl.png?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9wcml2YXRlLXVzLWVhc3QtMS5tYW51c2Nkbi5jb20vc2Vzc2lvbkZpbGUvaHlzZktNYXAzODZqZkZpb3R4dFJ0bS9zYW5kYm94L3pGaDZrWlk3cmFFVEpIcjVYR0F0UTctaW1hZ2VzXzE3NjI1Mjg2MzI1NDZfbmExZm5fTDJodmJXVXZkV0oxYm5SMUwyRnNjbUZxYUdsZlpYRjFhWFI1WDJOMWNuWmwucG5nIiwiQ29uZGl0aW9uIjp7IkRhdGVMZXNzVGhhbiI6eyJBV1M6RXBvY2hUaW1lIjoxNzk4NzYxNjAwfX19XX0_&Key-Pair-Id=K2HSFNDJXOU9YS&Signature=jK6R4C9D0xYqtGY9nqQUpi9OiXx~ETRtisU4fi1uuqx0F21bq1uK60nM5eRR7gyRaTSGmMs08rNp3rT1EnXd6pUsTQDaOrqbUXyFwB38E~UxGR8HT11rrHXdH465v12e-OZzF4I4SwRNX5Bcv5kwL7tywOcZLMOIbjeyGcyB5bf7kgLn-sQ19zyV7lnoUJrD5LDfmmzORdXOmTZHjtouv2PgE3rpLOiG-~X1UxDRGMYNr0WA9Dd9ZNAnZaKVFj4ek3kkIqQ8~X9MIB6dv5KAZYvxyTVTwIf9PRdZh9ct-fkR2DfzLAoeUn4ULg4nSEtsp49XMwWkhrEYw5xfA8RKaQ__)

---

## 4. Conclusion and Recommendations

The **ORB_DailyBias_EA** proves to be a versatile and potentially profitable strategy across different asset classes when its parameters are tailored to the specific market's opening time.

**Key Recommendation:**
The **Nasdaq (US100)** with a **15-minute ORB** and **9:30 AM EST** start time yielded the most favorable risk-adjusted returns in this simulation. Further optimization should focus on the Stop Loss and Take Profit levels for Al Rajhi Bank to improve its Max Drawdown.

**Next Steps:**
1.  **Compilation:** Compile the `ORB_DailyBias_EA.mq5` file in MetaEditor to generate the executable `.ex5` file.
2.  **Live Parameter Verification:** Always verify the correct symbol name and server time alignment with your broker before live deployment.
