-- mart_composizione_spesa.sql — Composizione spesa: corrente vs investimenti vs interessi
-- Domanda civica: la spesa corrente comprime strutturalmente gli investimenti?
-- Risponde alla Discussion #10 del vecchio repo

SELECT
    esercizio_finanziario AS anno,
    spese_correnti,
    spese_in_conto_capitale,
    spese_per_interessi,
    spese_complessive,
    -- Quote sul totale
    CASE WHEN spese_complessive = 0 THEN NULL
         ELSE ROUND(spese_correnti / spese_complessive, 4)
    END AS quota_corrente,
    CASE WHEN spese_complessive = 0 THEN NULL
         ELSE ROUND(spese_in_conto_capitale / spese_complessive, 4)
    END AS quota_investimento,
    CASE WHEN spese_complessive = 0 THEN NULL
         ELSE ROUND(spese_per_interessi / spese_complessive, 4)
    END AS quota_interessi,
    -- Rapporto corrente/investimento (>1 = la macchina assorbe più degli investimenti)
    CASE WHEN spese_in_conto_capitale = 0 OR spese_in_conto_capitale IS NULL THEN NULL
         ELSE ROUND(spese_correnti / spese_in_conto_capitale, 2)
    END AS rapporto_corrente_investimento
FROM clean_input
ORDER BY esercizio_finanziario
