DROP TABLE IF EXISTS gold.kpi_revenue_daily;

DO $$
BEGIN
    -- On verifie les colonnes order_date et unit_price dans la table silver.orders avant de créer la table gold.kpi_revenue_daily
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema='silver' AND table_name='orders' 
        AND column_name='order_date'
    ) 
    THEN
        IF EXISTS (SELECT 1 FROM information_schema.columns 
                    WHERE table_schema='silver' 
                    AND table_name='orders' AND column_name='unit_price') 
        THEN
            EXECUTE $q$
                CREATE TABLE gold.kpi_revenue_daily AS
                SELECT
                    order_date::date AS day,
                    SUM(unit_price::numeric) AS revenue,
                    COUNT(*) AS nb_orders
                FROM silver.orders
                GROUP BY order_date::date
                ORDER BY day;
            $q$;
        END IF;    
    END IF;
END $$;