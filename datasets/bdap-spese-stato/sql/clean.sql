-- clean.sql — bdap_spese_stato
-- Spese dello Stato per Missione/Programma/Macroaggregato
-- CSV con header italiano, encoding cp1252

SELECT
    cast_int("Esercizio Finanziario")   AS esercizio_finanziario,
    normalize_string("Codice Missione") AS codice_missione,
    normalize_string("Missione")        AS missione,
    normalize_string("Codice Programma") AS codice_programma,
    normalize_string("Programma")       AS programma,
    normalize_string("Codice Macroaggregato") AS codice_macroaggregato,
    normalize_string("Macroaggregato")  AS macroaggregato,
    cast_double("Previsioni Definitive CP") AS previsioni_definitive_cp,
    cast_double("Previsioni Definitive CS") AS previsioni_definitive_cs
FROM raw_input
WHERE cast_int("Esercizio Finanziario") IS NOT NULL
