CREATE VIEW CustomerSummary AS
SELECT
  customerId,
  modelName,
  SUM(julianday(dateBack) - julianday(dateOut) + 1) AS daysRented,
  (CASE
    WHEN CAST(SUBSTRING(dateBack,6,2) AS INTEGER) < 7
	THEN (SUBSTRING(dateBack,1,4) - 1) || '/' || (SUBSTRING(dateBack,3,2))
    ELSE (SUBSTRING(dateBack,1,4)) || '/' || (SUBSTRING(dateBack,3,2) + 1)
  END) AS taxYear,
  SUM(rentalCost)
FROM rentalContract
LEFT OUTER JOIN Phone USING (IMEI)
WHERE dateBack IS NOT NULL
GROUP BY customerId, taxYear, modelName;