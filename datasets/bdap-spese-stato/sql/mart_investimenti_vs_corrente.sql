-- mart_investimenti_vs_corrente.sql — Composizione spesa dello Stato per macroaggregato
-- Classificazione BDAP corretta (codici macro):
--   1 = FUNZIONAMENTO (stipendi, gestione)        → "funzionamento"
--   2 = INTERVENTI (trasferimenti a regioni/enti/famiglie) → "trasferimenti"
--   3 = INVESTIMENTI (fissi reali)                 → "investimenti"
--   4 = ALTRE SPESE IN C/CAPITALE                 → "altre_capitale"
--   5 = ONERI COMUNI DI PARTE CORRENTE            → "oneri_corrente"
--   7 = ONERI DEL DEBITO PUBBLICO (interessi)     → "onere_debito"
--   9 = RIMBORSO DEL DEBITO PUBBLICO              → "rimborso_debito"
--  10 = ONERI COMUNI DI CONTO CAPITALE            → "oneri_capitale"
-- Domanda civica: quanto va a investimenti reali vs trasferimenti vs debito?

WITH base AS (
    SELECT
        esercizio_finanziario AS anno,
        CASE
            WHEN codice_macroaggregato = '1' THEN 'funzionamento'
            WHEN codice_macroaggregato = '2' THEN 'trasferimenti'
            WHEN codice_macroaggregato = '3' THEN 'investimenti'
            WHEN codice_macroaggregato = '4' THEN 'altre_capitale'
            WHEN codice_macroaggregato = '5' THEN 'oneri_corrente'
            WHEN codice_macroaggregato = '7' THEN 'onere_debito'
            WHEN codice_macroaggregato = '9' THEN 'rimborso_debito'
            WHEN codice_macroaggregato = '10' THEN 'oneri_capitale'
            ELSE 'altro'
        END AS voce_spesa,
        SUM(previsioni_definitive_cp) AS totale_cp,
        SUM(previsioni_definitive_cs) AS totale_cs
    FROM clean_input
    WHERE esercizio_finanziario BETWEEN 2008 AND 2024
      AND codice_macroaggregato IS NOT NULL
    GROUP BY 1, 2
),
spese_per_macro AS (
    SELECT
        anno,
        SUM(CASE WHEN voce_spesa = 'funzionamento' THEN totale_cp ELSE 0 END) AS funzionamento_cp,
        SUM(CASE WHEN voce_spesa = 'trasferimenti' THEN totale_cp ELSE 0 END) AS trasferimenti_cp,
        SUM(CASE WHEN voce_spesa = 'investimenti' THEN totale_cp ELSE 0 END) AS investimenti_cp,
        SUM(CASE WHEN voce_spesa = 'onere_debito' THEN totale_cp ELSE 0 END) AS onere_debito_cp,
        SUM(CASE WHEN voce_spesa = 'rimborso_debito' THEN totale_cp ELSE 0 END) AS rimborso_debito_cp,
        SUM(CASE WHEN voce_spesa IN ('oneri_corrente', 'altre_capitale', 'oneri_capitale') THEN totale_cp ELSE 0 END) AS altri_cp,
        SUM(totale_cp) AS totale_cp
    FROM base
    GROUP BY 1
)
SELECT
    anno,
    ROUND(funzionamento_cp / 1e9, 1) AS funzionamento_mld,
    ROUND(trasferimenti_cp / 1e9, 1) AS trasferimenti_mld,
    ROUND(investimenti_cp / 1e9, 1) AS investimenti_mld,
    ROUND(onere_debito_cp / 1e9, 1) AS onere_debito_mld,
    ROUND(rimborso_debito_cp / 1e9, 1) AS rimborso_debito_mld,
    ROUND(altri_cp / 1e9, 1) AS altri_mld,
    ROUND(totale_cp / 1e9, 1) AS totale_mld,
    -- Quote sul totale
    ROUND(100.0 * funzionamento_cp / NULLIF(totale_cp, 0), 1) AS pct_funzionamento,
    ROUND(100.0 * trasferimenti_cp / NULLIF(totale_cp, 0), 1) AS pct_trasferimenti,
    ROUND(100.0 * investimenti_cp / NULLIF(totale_cp, 0), 1) AS pct_investimenti,
    ROUND(100.0 * onere_debito_cp / NULLIF(totale_cp, 0), 1) AS pct_onere_debito,
    ROUND(100.0 * rimborso_debito_cp / NULLIF(totale_cp, 0), 1) AS pct_rimborso_debito,
    -- Rapporto investimenti / totale (la vera domanda civica)
    ROUND(100.0 * investimenti_cp / NULLIF(totale_cp, 0), 1) AS quota_investimenti_reali_pct,
    -- Debito totale (interessi + rimborso) / totale
    ROUND(100.0 * (onere_debito_cp + rimborso_debito_cp) / NULLIF(totale_cp, 0), 1) AS quota_debito_totale_pct
FROM spese_per_macro
ORDER BY anno
