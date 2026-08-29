-- mart_avanzo_primario.sql — Avanzo primario e interessi sul debito
-- Domande civiche: Discussion #14 "Avanzo primario: mito o realtà?" + #17 "Interessi sul debito"

WITH base AS (
    SELECT
        esercizio_finanziario AS anno,
        avanzo_primario,
        spese_per_interessi,
        entrate_finali,
        spese_finali,
        saldo_netto_da_finanziare,
        LAG(avanzo_primario) OVER (ORDER BY esercizio_finanziario) AS avanzo_prev,
        LAG(spese_per_interessi) OVER (ORDER BY esercizio_finanziario) AS interessi_prev
    FROM clean_input
)
SELECT
    anno,
    avanzo_primario,
    spese_per_interessi,
    entrate_finali,
    spese_finali,
    saldo_netto_da_finanziare,
    -- L'avanzo primario copre gli interessi?
    CASE WHEN spese_per_interessi = 0 OR spese_per_interessi IS NULL THEN NULL
         ELSE ROUND(avanzo_primario / spese_per_interessi, 2)
    END AS copertura_interessi,
    -- Variazione avanzo primario
    CASE WHEN avanzo_prev = 0 OR avanzo_prev IS NULL THEN NULL
         ELSE ROUND((avanzo_primario - avanzo_prev) / ABS(avanzo_prev), 4)
    END AS var_pct_avanzo,
    -- Variazione interessi
    CASE WHEN interessi_prev = 0 OR interessi_prev IS NULL THEN NULL
         ELSE ROUND((spese_per_interessi - interessi_prev) / interessi_prev, 4)
    END AS var_pct_interessi,
    -- Quota interessi sul totale spese
    CASE WHEN spese_finali = 0 THEN NULL
         ELSE ROUND(spese_per_interessi / spese_finali, 4)
    END AS quota_interessi_su_spese
FROM base
ORDER BY anno
