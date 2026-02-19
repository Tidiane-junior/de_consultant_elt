DROP TABLE IF EXISTS gold.kpi_top_products;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema='silver' AND table_name='orders' 
        AND column_name='product_id'
    ) THEN
        IF EXISTS (SELECT 1 FROM information_schema.columns 
                    WHERE table_schema='silver' AND table_name='orders' 
                    AND column_name='unit_price'
        ) THEN
            EXECUTE $q$
                CREATE TABLE gold.kpi_top_products AS
                SELECT
                    product_id,
                    COUNT(*) AS nb_orders,
                    SUM(unit_price::numeric) AS revenue
                FROM silver.orders
                WHERE product_id IS NOT NULL
                GROUP BY product_id
                ORDER BY revenue DESC
                LIMIT 20;
            $q$;
        END IF;
    END IF;
END $$;