-- mart_entrate_titolo_natura.sql — Entrate per Titolo x Natura x Anno
-- Visione aggregata: quanto pesa ogni titolo (I, II, III, IV, V) e natura (tributaria, ecc.)

WITH base AS (
    SELECT
        esercizio_finanziario AS anno,
        codice_titolo,
        titolo,
        codice_natura,
        natura,
        SUM(previsioni_definitive_cp) AS totale_cp,
        SUM(previsioni_definitive_cs) AS totale_cs
    FROM clean_input
    WHERE esercizio_finanziario BETWEEN 2008 AND 2024
      AND codice_titolo IS NOT NULL
      AND codice_natura IS NOT NULL
      AND codice_tipologia IS NOT NULL
    GROUP BY 1, 2, 3, 4, 5
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
    b.codice_titolo,
    b.titolo,
    REGEXP_REPLACE(b.titolo, '^TITOLO [IVXLC]+ - ', '') AS titolo_breve,
    b.codice_natura,
    b.natura,
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
ORDER BY anno, TRY_CAST(b.codice_titolo AS INTEGER), TRY_CAST(b.codice_natura AS INTEGER)
