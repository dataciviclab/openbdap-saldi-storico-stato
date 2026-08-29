-- mart_pagamenti_anno.sql — Trend pagamenti dello Stato per anno
-- 1 riga = 1 anno: totale pagato, erario, tesoreria, esterno
-- Variazione % anno-over-anno e quota erario sul totale

WITH per_anno AS (
    SELECT
        esercizio_finanziario AS anno,
        SUM(totale_pagato) AS pagato_totale,
        SUM(op_erario) AS erario_totale,
        SUM(op_tesoreria) AS tesoreria_totale,
        SUM(op_esterno) AS esterno_totale
    FROM clean_input
    WHERE missione IS NOT NULL
    GROUP BY 1
)
SELECT
    anno,
    ROUND(pagato_totale, 0) AS pagato_totale,
    ROUND(erario_totale, 0) AS erario_totale,
    ROUND(tesoreria_totale, 0) AS tesoreria_totale,
    ROUND(esterno_totale, 0) AS esterno_totale,
    -- quota erario sul totale
    ROUND(100.0 * erario_totale / NULLIF(pagato_totale, 0), 1) AS quota_erario_pct,
    -- variazione % anno precedente
    ROUND(100.0 * (pagato_totale - LAG(pagato_totale) OVER (ORDER BY anno))
          / NULLIF(LAG(pagato_totale) OVER (ORDER BY anno), 0), 2) AS var_pct_pagato
FROM per_anno
ORDER BY anno
