-- clean.sql — bdap_lb_spese_missione
-- Legge di Bilancio Pubblicata — Spese per Missione DPCM Art.3
-- CSV con header cp1252, 26 colonne, ~6700 righe per missione/anno

SELECT
    cast_int("column00")          AS esercizio_finanziario,
    normalize_string("column01")  AS stato_previsione,
    normalize_string("column02")  AS amministrazione,
    LPAD(normalize_string("column03"), 4, '0') AS codice_cr,
    normalize_string("column04")  AS descrizione_cr,
    LPAD(normalize_string("column05"), 4, '0') AS codice_azione,
    normalize_string("column06")  AS descrizione_azione,
    LPAD(normalize_string("column07"), 4, '0') AS capitolo,
    normalize_string("column08")  AS denominazione_capitolo,
    LPAD(normalize_string("column09"), 3, '0') AS codice_missione,
    normalize_string("column10")  AS missione,
    LPAD(normalize_string("column11"), 3, '0') AS codice_programma,
    normalize_string("column12")  AS programma,
    normalize_string("column13")  AS codice_titolo,
    normalize_string("column14")  AS titolo,
    normalize_string("column15")  AS codice_categoria,
    normalize_string("column16")  AS categoria,
    normalize_string("column17")  AS codice_cofog1,
    normalize_string("column18")  AS descrizione_cofog1,
    normalize_string("column23")  AS percentuale_cofog,
    cast_double("column24")       AS previsioni_iniziali_cp,
    cast_double("column25")       AS previsioni_iniziali_cs
FROM raw_input
WHERE cast_int("column00") IS NOT NULL