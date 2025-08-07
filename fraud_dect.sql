create schema tracksure;
use tracksure;
show tables;
select * from chargeback_dispute_dataset limit 50;
rename table chargeback_dispute_dataset to fraud_dect;
select * from fraud_dect;

-- Flag Suspicious Transactions
SELECT *
FROM fraud_dect
WHERE ChargebackFiled = 1;

-- Add Chargeback Rate 
select buyerID,
count(orderID) as totaltransactions,
sum(chargebackfiled) as totalchargebacks,
round(sum(chargebackfiled) / count(orderid), 2) as chargebackrate
from fraud_dect group by buyerid;

-- Discrepancy Logic: Billing ≠ Bank address + No Delivery Proof
SELECT *
FROM fraud_dect
WHERE BillingAddressMatch = 'N'
  AND BankAddressMatch = 'N'
  AND (DeliveryProof IS NULL OR DeliveryProof = '');

-- Seller Performance Summary
SELECT
    SellerID,
    COUNT(OrderID) AS TotalOrders,
    SUM(ChargebackFiled) AS Chargebacks,
    ROUND(SUM(ChargebackFiled)/COUNT(OrderID), 2) AS ChargebackRate,
    SUM(DisputeResolved) AS ResolvedDisputes
FROM fraud_dect
GROUP BY SellerID
ORDER BY ChargebackRate DESC;

-- Weekly Flagged Transaction Count
SELECT
    WEEK(TransactionDate) AS WeekNo,
    COUNT(*) AS FlaggedTransactions
FROM fraud_dect
WHERE ChargebackFiled = 1
GROUP BY WEEK(TransactionDate);

-- Dispute Resolution Summary
SELECT
    DisputeResolved,
    COUNT(*) AS Count
FROM fraud_dect
GROUP BY DisputeResolved;

-- Create a Risk Score Formula
SELECT 
    OrderID,
    BuyerID,
    SellerID,
    ( 
      (CASE WHEN AVSMatch = 'N' THEN 1 ELSE 0 END) +
      (CASE WHEN BillingAddressMatch = 'N' THEN 1 ELSE 0 END) +
      (CASE WHEN BankAddressMatch = 'N' THEN 1 ELSE 0 END) +
      (CASE WHEN DeliveryProof IS NULL OR DeliveryProof = '' THEN 1 ELSE 0 END) +
      (CASE WHEN ShippingProof IS NULL OR ShippingProof = '' THEN 1 ELSE 0 END)
    ) AS risk_score
FROM fraud_dect;

-- Insight Generation Table
CREATE TABLE insights (
    InsightID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    InsightText TEXT,
    GeneratedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- List All Chargebacks with Missing Delivery Proof
SELECT OrderID, BuyerID, SellerID, Amount, PaymentMethod, DeliveryProof
FROM fraud_dect
WHERE ChargebackFiled = 1
  AND (DeliveryProof IS  NULL OR DeliveryProof = '');

-- Orders with Address Mismatches & No Shipping Proof
SELECT OrderID, BuyerID, SellerID, AVSMatch, BillingAddressMatch, BankAddressMatch, ShippingProof
FROM fraud_dect
WHERE AVSMatch = 'N'
  AND BillingAddressMatch = 'N'
  AND BankAddressMatch = 'N'
  AND (ShippingProof IS NULL OR ShippingProof = '');

-- Disputes Not Yet Resolved
SELECT OrderID, BuyerID, SellerID, ChargebackFiled, DisputeResolved
FROM fraud_dect
WHERE ChargebackFiled = 1 AND DisputeResolved = 0;

-- Buyer History: Chargeback Rate by Buyer
SELECT BuyerID,
       COUNT(OrderID) AS TotalOrders,
       SUM(ChargebackFiled) AS Chargebacks,
       ROUND(SUM(ChargebackFiled) / COUNT(OrderID), 2) AS ChargebackRate
FROM fraud_dect
GROUP BY BuyerID
ORDER BY ChargebackRate DESC;

-- Monthly Chargeback Trend
SELECT DATE_FORMAT(TransactionDate, '%Y-%m') AS Month,
       COUNT(*) AS TotalOrders,
       SUM(ChargebackFiled) AS Chargebacks
FROM fraud_dect
GROUP BY Month
ORDER BY Month;

-- Country-wise Dispute Heatmap
SELECT BuyerCountry,
       COUNT(*) AS TotalOrders,
       SUM(ChargebackFiled) AS Chargebacks,
       ROUND(SUM(ChargebackFiled) / COUNT(*), 2) AS ChargebackRate
FROM fraud_dect
GROUP BY BuyerCountry
ORDER BY ChargebackRate DESC;

-- Flagged Orders for Manual Review (Custom Risk Logic)
SELECT OrderID, BuyerID, SellerID,
       (CASE WHEN AVSMatch = 'N' THEN 1 ELSE 0 END +
        CASE WHEN BillingAddressMatch = 'N' THEN 1 ELSE 0 END +
        CASE WHEN BankAddressMatch = 'N' THEN 1 ELSE 0 END +
        CASE WHEN DeliveryProof IS NULL OR DeliveryProof = '' THEN 1 ELSE 0 END) AS RiskScore
FROM fraud_dect
HAVING RiskScore >= 3;

-- Orders Missing Key Documentation
SELECT OrderID, BuyerID, SellerID
FROM fraud_dect
WHERE (DeliveryProof IS NULL OR DeliveryProof = '')
   OR (ShippingProof IS NULL OR ShippingProof = '');
