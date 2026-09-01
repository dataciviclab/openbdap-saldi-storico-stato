-- mart_costo_debito_bilancio.sql — Trend costo del debito a bilancio vs stime OCPI
-- Missione 034 = DEBITO PUBBLICO nel consuntivo pagamenti = interessi effettivamente pagati
-- Confronto con le stime OCPI (usato da debito-pubblico-intelligence)
-- 1 riga = 1 anno: costo debito bilancio, note imputazione, variazione %

WITH per_anno AS (
    SELECT
        esercizio_finanziario AS anno,
        SUM(totale_pagato) AS costo_debito_bilancio,
        SUM(note_imputazione) AS note_imputazione
    FROM clean_input
    WHERE codice_missione = '034'
    GROUP BY 1
)
SELECT
    anno,
    ROUND(costo_debito_bilancio, 0) AS costo_debito_bilancio,
    ROUND(note_imputazione, 0) AS note_imputazione,
    ROUND(100.0 * (costo_debito_bilancio - LAG(costo_debito_bilancio) OVER (ORDER BY anno))
          / NULLIF(LAG(costo_debito_bilancio) OVER (ORDER BY anno), 0), 2) AS var_pct
FROM per_anno
ORDER BY anno
