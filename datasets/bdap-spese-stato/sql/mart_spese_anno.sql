-- mart_spese_anno.sql — Totali spese per anno (panoramica)
-- Una riga per anno con totale spese, variazione % e rapporto CP/CS

WITH totali AS (
    SELECT
        esercizio_finanziario AS anno,
        SUM(previsioni_definitive_cp) AS spese_totali_cp,
        SUM(previsioni_definitive_cs) AS spese_totali_cs
    FROM clean_input
    WHERE esercizio_finanziario BETWEEN 2008 AND 2025
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
    ROUND(100.0 * (spese_totali_cp - LAG(spese_totali_cp) OVER (ORDER BY anno))
          / NULLIF(LAG(spese_totali_cp) OVER (ORDER BY anno), 0), 2) AS var_pct_cp,
    ROUND(100.0 * (spese_totali_cs - LAG(spese_totali_cs) OVER (ORDER BY anno))
          / NULLIF(LAG(spese_totali_cs) OVER (ORDER BY anno), 0), 2) AS var_pct_cs,
    CASE WHEN spese_totali_cs = 0 THEN NULL
         ELSE ROUND(spese_totali_cp / spese_totali_cs, 4)
    END AS rapporto_cp_cs
FROM con_lag
ORDER BY anno
