-- clean.sql — bdap_entrate_stato
-- Entrate dello Stato per Titolo/Natura/Tipologia/Provento
-- CSV SENZA header: prima riga = dati, colonne via index (column00..column10)

SELECT
    cast_int("column00")          AS esercizio_finanziario,
    normalize_string("column01")  AS codice_titolo,
    normalize_string("column02")  AS titolo,
    normalize_string("column03")  AS codice_natura,
    normalize_string("column04")  AS natura,
    normalize_string("column05")  AS codice_tipologia,
    normalize_string("column06")  AS tipologia,
    normalize_string("column07")  AS codice_provento,
    normalize_string("column08")  AS provento,
    cast_double("column09")       AS previsioni_definitive_cp,
    cast_double("column10")       AS previsioni_definitive_cs
FROM raw_input
WHERE cast_int("column00") IS NOT NULL
