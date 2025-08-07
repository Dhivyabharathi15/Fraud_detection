TrackSure: Fraud Detection & Dispute Automation

Project Overview
This project addresses the growing issue of chargeback fraud in e-commerce transactions. By leveraging SQL in MySQL Workbench, we analyze buyer and seller transaction patterns to detect fraud, automate discrepancy tracking, and support faster dispute resolution. The insights generated from this project are designed to reduce manual effort, assist seller support teams, and improve transparency in seller performance.

Table of Contents

Introduction

Techniques and Tools Used

Key Insights

Data Sources

Introduction
Dispute handling due to chargebacks poses a significant challenge for e-commerce platforms. Buyers may claim unauthorized transactions, leading to revenue loss and delays in seller approvals. This project — TrackSure — aims to identify risky transactions early using SQL-based data analysis, enabling faster and smarter decision-making for dispute management.

Techniques and Tools Used

SQL (MySQL Workbench): Core data analysis, discrepancy detection, and automation

Views and Joins: Used for real-time seller and buyer profiling

Data Filtering and Aggregation: Applied to detect suspicious behavior

Derived Columns and Risk Score Calculations

Key Insights

Risk Identification: Orders with AVS mismatch, missing delivery proof, and address mismatches are high-risk.

Top 5 Risky Sellers: Identified sellers with the highest chargeback rates.

Buyer Behavior: Buyers with high previous chargebacks are more likely to dispute again.

Country-wise Risk Map: Some countries show higher dispute ratios, useful for fraud monitoring.

Dispute Resolution Metrics: Showed the ratio of resolved vs unresolved disputes.
Data Sources
The dataset used for this project includes the following columns:

OrderID, BuyerID, TransactionDate, Amount, Currency, PaymentMethod, ChargebackFiled, PreviousChargebacks, AVSMatch, BillingAddressMatch, ShippingProof, DeliveryProof, BankAddressMatch, BuyerCountry, OrderPlatform, SellerID, DiscrepancyReported, InsightGenerated, DisputeResolved

Conclusion
TrackSure effectively demonstrates how SQL queries can be used in real-world fraud detection. By identifying suspicious transaction patterns, profiling sellers and buyers, and automating reporting, the project shows how data analysis can reduce dispute resolution time and help protect business revenue.

