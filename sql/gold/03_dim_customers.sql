DROP TABLE IF EXISTS gold.dim_customers;

DO $$
BEGIN
    -- On vérifie la colonne unit_price dans la table silver.orders avant de créer la table gold.dim_customers
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema='silver' AND table_name='orders' AND column_name='unit_price'
    ) 
    THEN
        EXECUTE $q$
            CREATE TABLE gold.dim_customers AS
            SELECT
                customer_id,
                COUNT(*) AS total_orders,
                SUM(unit_price::numeric) AS total_spent
            FROM silver.orders
            WHERE customer_id IS NOT NULL
            GROUP BY customer_id;
    END IF;
END $$;

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='gold' AND table_name='dim_customers' AND column_name='customer_id') THEN
        EXECUTE 'CREATE UNIQUE INDEX IF NOT EXISTS ux_gold_dim_customers_customer_id ON gold.dim_customers(customer_id)';
    END IF;
END $$;