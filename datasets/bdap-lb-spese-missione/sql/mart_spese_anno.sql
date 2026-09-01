-- mart_spese_anno.sql — Totali LB per anno con variazione
-- Trend delle previsioni iniziali della Legge di Bilancio

WITH per_anno AS (
    SELECT
        esercizio_finanziario AS anno,
        SUM(previsioni_iniziali_cp) AS lb_totale_cp,
        SUM(previsioni_iniziali_cs) AS lb_totale_cs
    FROM clean_input
    GROUP BY 1
)
SELECT
    anno,
    ROUND(lb_totale_cp / 1e9, 0) AS lb_totale_cp_mld,
    ROUND(lb_totale_cs / 1e9, 0) AS lb_totale_cs_mld,
    ROUND(100.0 * (lb_totale_cp - LAG(lb_totale_cp) OVER (ORDER BY anno))
          / NULLIF(LAG(lb_totale_cp) OVER (ORDER BY anno), 0), 2) AS var_pct_cp
FROM per_anno
ORDER BY anno
