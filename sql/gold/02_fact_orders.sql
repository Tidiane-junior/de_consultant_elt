DROP TABLE IF EXISTS gold.fact_orders;

CREATE TABLE gold.fact_orders AS
SELECT
    o.*
FROM silver.orders o;

-- Créer des index sur les colonnes fréquemment utilisées pour améliorer les performances des requêtes
DO $$
BEGIN
    -- Créer un index sur order_id 
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='gold' AND table_name='fact_orders' AND column_name='order_id') 
    THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS idx_gold_fact_orders_order_id ON gold.fact_orders(order_id)';
    END IF;
    -- Créer un index sur customer_id
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='gold' AND table_name='fact_orders' AND column_name='customer_id') 
    THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS idx_gold_fact_orders_customer_id ON gold.fact_orders(customer_id)';
    END IF;
    -- Créer un index sur product_id
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema='gold' AND table_name='fact_orders' AND column_name='product_id') 
    THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS idx_gold_fact_orders_product_id ON gold.fact_orders(product_id)';
    END IF;
END $$;