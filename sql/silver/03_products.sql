DROP TABLE IF EXISTS silver.products;

CREATE TABLE silver.products AS
SELECT DISTINCT *
FROM bronze.products;

-- Index utile parce que on a product_id
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema='silver' AND table_name='products' AND column_name='product_id'
    ) THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS idx_silver_products_product_id ON silver.products (product_id)';
    END IF;
END $$;