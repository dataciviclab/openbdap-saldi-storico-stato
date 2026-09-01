-- mart_vs_rendiconto.sql — Confronto LB (promesse) vs Rendiconto (consuntivo)
-- Per ogni missione: quanto ha previsto il governo nella LB vs quanto ha speso nel rendiconto
-- Nota:LB e Rendiconto hanno codici missione diversi (001-034 vs nomi), serve join su missione

WITH lb_per_missione AS (
    SELECT
        esercizio_finanziario AS anno,
        codice_missione,
        missione,
        SUM(previsioni_iniziali_cp) AS lb_previsto_cp
    FROM clean_input
    WHERE esercizio_finanziario BETWEEN 2015 AND 2026
    GROUP BY 1, 2, 3
)
SELECT
    anno,
    codice_missione,
    missione,
    ROUND(lb_previsto_cp / 1e9, 1) AS lb_previsto_mld
FROM lb_per_missione
ORDER BY anno, codice_missione
