DROP TABLE IF EXISTS silver.customers;

-- Silver = nettoyé + dédupliqué, mais pas encore "métier"
CREATE TABLE silver.customers AS
SELECT DISTINCT *
FROM bronze.customers;

-- Index utile parce que on a customer_id
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema='silver' AND table_name='customers' AND column_name='customer_id'
    ) THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS idx_silver_customers_customer_id ON silver.customers (customer_id)';
    END IF;
END $$;