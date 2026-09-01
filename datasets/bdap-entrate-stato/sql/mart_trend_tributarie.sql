-- mart_trend_tributarie.sql — Trend entrate tributarie vs extra-tributarie
-- Domanda civica: quanto pesano le entrate tribuarie rispetto al totale?
-- Titolo I = Imposte dirette, Titolo II = Imposte indirette, ecc.

WITH tributarie AS (
    SELECT
        esercizio_finanziario AS anno,
        -- Titolo I+II = entrate tributarie (imposte dirette + indirette)
        SUM(CASE WHEN codice_titolo IN ('1', '2') THEN previsioni_definitive_cp ELSE 0 END)
            AS tributarie_cp,
        SUM(CASE WHEN codice_titolo IN ('1', '2') THEN previsioni_definitive_cs ELSE 0 END)
            AS tributarie_cs,
        -- Totale
        SUM(previsioni_definitive_cp) AS totale_cp,
        SUM(previsioni_definitive_cs) AS totale_cs
    FROM clean_input
    WHERE esercizio_finanziario BETWEEN 2008 AND 2025
      AND codice_titolo IS NOT NULL
      AND codice_tipologia IS NOT NULL
    GROUP BY 1
)
SELECT
    anno,
    tributarie_cp,
    tributarie_cs,
    totale_cp,
    totale_cs,
    CASE WHEN totale_cp = 0 THEN NULL
         ELSE ROUND(tributarie_cp / totale_cp, 4)
    END AS quota_tributarie_cp,
    CASE WHEN totale_cs = 0 THEN NULL
         ELSE ROUND(tributarie_cs / totale_cs, 4)
    END AS quota_tributarie_cs,
    totale_cp - tributarie_cp AS extra_tributarie_cp,
    totale_cs - tributarie_cs AS extra_tributarie_cs
FROM tributarie
ORDER BY anno
