-- mart_entrate_anno.sql — Trend entrate dello Stato per anno
-- 1 riga = 1 anno: totale entrate CP/CS, variazione % anno precedente

WITH per_anno AS (
    SELECT
        esercizio_finanziario AS anno,
        SUM(previsioni_definitive_cp) AS entrate_totali_cp,
        SUM(previsioni_definitive_cs) AS entrate_totali_cs
    FROM clean_input
    WHERE esercizio_finanziario BETWEEN 2008 AND 2025
    GROUP BY 1
)
SELECT
    anno,
    ROUND(entrate_totali_cp, 0) AS entrate_totali_cp,
    ROUND(entrate_totali_cs, 0) AS entrate_totali_cs,
    ROUND(100.0 * (entrate_totali_cp - LAG(entrate_totali_cp) OVER (ORDER BY anno))
          / NULLIF(LAG(entrate_totali_cp) OVER (ORDER BY anno), 0), 2) AS var_pct_cp,
    ROUND(100.0 * (entrate_totali_cs - LAG(entrate_totali_cs) OVER (ORDER BY anno))
          / NULLIF(LAG(entrate_totali_cs) OVER (ORDER BY anno), 0), 2) AS var_pct_cs
FROM per_anno
ORDER BY anno
