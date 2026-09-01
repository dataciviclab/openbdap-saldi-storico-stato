-- mart_saldi.sql — Panoramica saldi dello Stato
-- Una riga per anno: tutti i saldi aggregati

SELECT
    esercizio_finanziario AS anno,
    spese_complessive,
    entrate_finali,
    saldo_netto_da_finanziare,
    indebitamento_netto,
    avanzo_primario,
    ricorso_al_mercato,
    risparmio_pubblico,
    CASE WHEN spese_complessive = 0 THEN NULL
         ELSE ROUND(avanzo_primario / spese_complessive, 4)
    END AS quota_avanzo_su_spese,
    CASE WHEN entrate_finali = 0 THEN NULL
         ELSE ROUND((entrate_finali - spese_complessive) / entrate_finali, 4)
    END AS saldo_su_entrate
FROM clean_input
ORDER BY esercizio_finanziario
