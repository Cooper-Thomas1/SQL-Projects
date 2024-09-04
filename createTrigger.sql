CREATE TRIGGER RentalCostCalculationTrigger AFTER UPDATE
ON rentalContract
WHEN OLD.dateBack IS NULL
BEGIN
  UPDATE rentalContract
  SET rentalCost = ROUND((
	SELECT baseCost + (dailyCost * (julianday(NEW.dateBack) - julianday(NEW.dateOut) + 1))
    FROM rentalContract 
	JOIN Phone USING (IMEI)
	JOIN PhoneModel USING (modelNumber) 
    WHERE IMEI = NEW.IMEI
	),2)
  WHERE IMEI = NEW.IMEI 
  AND customerId = NEW.customerId
  AND dateOut = NEW.dateOut;
END;