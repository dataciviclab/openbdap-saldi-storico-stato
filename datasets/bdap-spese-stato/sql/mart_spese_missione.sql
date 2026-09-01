-- mart_spese_missione.sql — Spese per Missione x Anno
-- Visione aggregata: quanto spende lo Stato per ciascuna missione (Difesa, Giustizia, Salute, ecc.)

WITH base AS (
    SELECT
        esercizio_finanziario AS anno,
        missione,
        SUM(previsioni_definitive_cp) AS totale_cp,
        SUM(previsioni_definitive_cs) AS totale_cs
    FROM clean_input
    WHERE esercizio_finanziario BETWEEN 2008 AND 2025
      AND missione IS NOT NULL
    GROUP BY 1, 2
),
totali_anno AS (
    SELECT
        anno,
        SUM(totale_cp) AS anno_totale_cp,
        SUM(totale_cs) AS anno_totale_cs
    FROM base
    GROUP BY 1
)
SELECT
    b.anno,
    b.missione,
    b.totale_cp,
    b.totale_cs,
    CASE WHEN t.anno_totale_cp = 0 THEN NULL
         ELSE ROUND(b.totale_cp / t.anno_totale_cp, 4)
    END AS quota_cp,
    CASE WHEN t.anno_totale_cs = 0 THEN NULL
         ELSE ROUND(b.totale_cs / t.anno_totale_cs, 4)
    END AS quota_cs
FROM base b
JOIN totali_anno t USING (anno)
ORDER BY anno, b.missione
