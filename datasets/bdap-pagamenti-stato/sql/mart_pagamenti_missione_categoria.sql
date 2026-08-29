-- mart.sql — bdap_pagamenti_stato
-- Consuntivo dei pagamenti dello Stato, con focus sulla missione Debito pubblico.

-- Mart: pagamenti per amministrazione x missione x categoria x anno
select
    esercizio_finanziario,
    amministrazione,
    missione,
    categoria,
    round(sum(totale_pagato), 2) as totale_pagato,
    round(sum(note_imputazione), 2) as note_imputazione,
    count(*) as n_righe
from clean_input
where missione is not null and categoria is not null
group by 1, 2, 3, 4
