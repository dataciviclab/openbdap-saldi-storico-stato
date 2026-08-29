-- clean.sql — bdap_pagamenti_stato
-- Consuntivo pagamenti Bilancio dello Stato per Amministrazione x Missione x Categoria Economica
-- Numeri in formato standard (punto decimale), colonne stringa normalizzate.

SELECT
    cast_int("esercizio_finanziario") AS esercizio_finanziario,
    LPAD(normalize_string("codice_stp"), 2, '0') AS codice_stp,
    normalize_string("amministrazione") AS amministrazione,
    LPAD(normalize_string("codice_missione"), 3, '0') AS codice_missione,
    normalize_string("missione") AS missione,
    LPAD(normalize_string("codice_categoria"), 2, '0') AS codice_categoria,
    normalize_string("categoria") AS categoria,
    cast_double("op_erario") AS op_erario,
    cast_double("op_tesoreria") AS op_tesoreria,
    cast_double("op_esterno") AS op_esterno,
    cast_double("oa_tesoreria") AS oa_tesoreria,
    cast_double("oa_spesa_funz_deleg") AS oa_spesa_funz_deleg,
    cast_double("rsf_stipendi") AS rsf_stipendi,
    cast_double("rsf_altro") AS rsf_altro,
    cast_double("note_imputazione") AS note_imputazione,
    cast_double("totale_pagato") AS totale_pagato
FROM raw_input
