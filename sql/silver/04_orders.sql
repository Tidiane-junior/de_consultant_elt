DROP TABLE IF EXISTS silver.orders;

-- 
DO $$
BEGIN
-- On vérifie d'abord si la colonne order_id existe dans bronze.orders
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema='bronze' AND table_name='orders' AND column_name='order_id'
    ) THEN
    -- Si elle existe, on utilise ROW_NUMBER pour dédupliquer 
        EXECUTE $q$
            CREATE TABLE silver.orders AS
            WITH ranked AS (
                SELECT
                    *,
                    ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY order_id) AS rn
                FROM bronze.orders
                WHERE order_id IS NOT NULL
            )
            -- On ne garde que les lignes où rn = 1, c'est-à-dire la première occurrence de chaque order_id
            SELECT ranked.*
            FROM ranked
            WHERE rn = 1;
        $q$;
        -- On peut aussi supprimer la colonne rn après la création de la table silver.orders
        EXECUTE 'ALTER TABLE silver.orders DROP COLUMN rn;';
    ELSE
        EXECUTE $q$
            CREATE TABLE silver.orders AS
            SELECT DISTINCT *
            FROM bronze.orders;
        $q$;
    END IF;
END $$;

-- Index utile parce que on a order_id
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_schema='silver' AND table_name='orders' AND column_name='order_id'
    ) THEN
        EXECUTE 'CREATE INDEX IF NOT EXISTS idx_silver_orders_order_id ON silver.orders (order_id)';
    END IF;
END $$;