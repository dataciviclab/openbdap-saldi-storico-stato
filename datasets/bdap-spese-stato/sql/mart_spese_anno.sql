-- mart_spese_anno.sql — Totali spese per anno (panoramica)
-- Una riga per anno con totale spese, variazione % e rapporto CP/CS

WITH totali AS (
    SELECT
        esercizio_finanziario AS anno,
        SUM(previsioni_definitive_cp) AS spese_totali_cp,
        SUM(previsioni_definitive_cs) AS spese_totali_cs
    FROM clean_input
    WHERE esercizio_finanziario BETWEEN 2008 AND 2024
    GROUP BY 1
),
con_lag AS (
    SELECT
        anno,
        spese_totali_cp,
        spese_totali_cs,
        LAG(spese_totali_cp) OVER (ORDER BY anno) AS cp_prev,
        LAG(spese_totali_cs) OVER (ORDER BY anno) AS cs_prev
    FROM totali
)
SELECT
    anno,
    spese_totali_cp,
    spese_totali_cs,
    CASE WHEN cp_prev = 0 OR cp_prev IS NULL THEN NULL
         ELSE ROUND((spese_totali_cp - cp_prev) / cp_prev, 4)
    END AS var_pct_cp,
    CASE WHEN cs_prev = 0 OR cs_prev IS NULL THEN NULL
         ELSE ROUND((spese_totali_cs - cs_prev) / cs_prev, 4)
    END AS var_pct_cs,
    CASE WHEN spese_totali_cs = 0 THEN NULL
         ELSE ROUND(spese_totali_cp / spese_totali_cs, 4)
    END AS rapporto_cp_cs
FROM con_lag
ORDER BY anno
