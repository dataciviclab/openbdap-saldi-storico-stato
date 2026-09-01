-- clean.sql — bdap_saldi_stato
-- Saldi aggregati del Bilancio dello Stato (2003-2024)
-- CSV con header, delimitatore punto e virgola

SELECT
    cast_int("ANNO")                         AS esercizio_finanziario,
    cast_double("RISPARMIO_PUBBLICO")        AS risparmio_pubblico,
    cast_double("SALDO_NETTO")               AS saldo_netto_da_finanziare,
    cast_double("INDEBITAMENTO_NETTO")       AS indebitamento_netto,
    cast_double("RICORSO_MERCATO")           AS ricorso_al_mercato,
    cast_double("AVANZO_PRIMARIO")           AS avanzo_primario,
    cast_double("SPESE_CORRENTI")            AS spese_correnti,
    cast_double("SPESE_INTERESSI")           AS spese_per_interessi,
    cast_double("SPESE_CONTO_CAPITALE")      AS spese_in_conto_capitale,
    cast_double("SPESE_ACQ_ATT_FINE")        AS spese_acquisizione_attivita_finanziarie,
    cast_double("SPESE_RIMBORSO_PRESTITI")   AS spese_per_rimborso_prestiti,
    cast_double("SPESE_COMPLESSIVE")         AS spese_complessive,
    cast_double("SPESE_FINALI")              AS spese_finali,
    cast_double("SPESE_FIN_NETTO_ATT_FIN")   AS spese_finali_netto_attivita_finanziarie,
    cast_double("ENTRATE_TRIBUTARIE")        AS entrate_tributarie,
    cast_double("ENTRATE_EXTRA_TRIBUTARIE")  AS entrate_extra_tributarie,
    cast_double("ENTR_ALIEN_PATR_RISCOS")    AS entrate_alienazioni_patrimoniali_e_riscossioni,
    cast_double("RISCOSSIONE_CREDITI")       AS riscossione_crediti,
    cast_double("ENTR_ACCENSIONE_PRESTITI")  AS entrate_accensione_prestiti,
    cast_double("ENTRATE_FINALI")            AS entrate_finali,
    cast_double("ENTR_FIN_NETTO_RISCO_CRED") AS entrate_finali_netto_riscossione_crediti,
    cast_double("ENTRATE_CORRENTI")          AS entrate_correnti
FROM raw_input
WHERE cast_int("ANNO") IS NOT NULL
