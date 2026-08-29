# Bilancio Pubblico Intelligence

**Quanto spende lo Stato italiano, come lo finanzia, e cosa resta per gli investimenti?**

Sistema di intelligence sul bilancio dello Stato italiano: raccoglie i dati ufficiali BDAP (RGS/MEF),
li trasforma in mart analitici e li rende interrogabili via dashboard Streamlit.

- **Fonte**: [OpenBDAP - RGS/MEF](https://bdap-opendata.rgs.mef.gov.it/)
- **Copertura**: 2003-2025 (a seconda del dataset)
- **Livello**: Nazionale - Stato centrale
- **Output pubblico**: Dashboard Streamlit + Discussion

## Cosa risponde

1. Lo Stato e strutturalmente in deficit? -> saldi storici 2003-2024
2. La spesa corrente comprime gli investimenti? -> composizione spesa per macroaggregato
3. Quanto pesano le entrate tributarie? -> trend entrate per titolo/natura
4. Quanto costa il debito a bilancio? -> consuntivo pagamenti missione 034
5. Come varia la spesa per missione? -> spese per DPCM Art.3

## Dataset

| Dataset | Anni | Mart | Descrizione |
|---|---|---|---|
| bdap_saldi_stato | 2003-2024 | 3 | Saldi aggregati: deficit, avanzo primario, ricorso mercato |
| bdap_entrate_stato | 2008-2024 | 3 | Entrate per Titolo/Natura/Tipologia/Provento |
| bdap_spese_stato | 2008-2024 | 3 | Spese per Missione/Programma/Macroaggregato |
| bdap_pagamenti_stato | 2014-2025 | 3x12 | Consuntivo pagamenti per Amministrazione/Missione/Categoria |

### Mart analitici

**Saldi**: mart_saldi_anno, mart_composizione_spesa, mart_avanzo_primario

**Entrate**: mart_entrate_titolo_natura_anno, mart_entrate_anno, mart_trend_tributarie

**Spese**: mart_spese_missione_anno, mart_spese_anno, mart_investimenti_vs_corrente

**Pagamenti**: mart_pagamenti_missione_categoria, mart_pagamenti_anno, mart_costo_debito_bilancio

## Come si usa

```bash
# Setup
pip install -r requirements.txt

# Validare config
make check

# Eseguire tutte le pipeline
make run

# Dashboard
cd dashboard && streamlit run app.py
```

## Struttura

datasets/                    # Pipeline toolkit
  bdap-saldi-stato/          #   dataset.yml + sql/
  bdap-entrate-stato/
  bdap-spese-stato/
  bdap-pagamenti-stato/
dashboard/                   # Streamlit app
  app.py
  sources.py
  pages/
notebooks/                   # Analisi legacy (Discussion)
docs/                        # Documentazione

## Domande civiche (Discussions)

Il repo eredita 6 Discussion dal progetto originale:

- [#9](https://github.com/dataciviclab/openbdap-saldi-storico-stato/discussions/9) Lo Stato e strutturalmente in deficit?
- [#10](https://github.com/dataciviclab/openbdap-saldi-storico-stato/discussions/10) Le spese correnti comprimono gli investimenti?
- [#12](https://github.com/dataciviclab/openbdap-saldi-storico-stato/discussions/12) Le entrate tributarie coprono la macchina dello Stato?
- [#14](https://github.com/dataciviclab/openbdap-saldi-storico-stato/discussions/14) L'avanzo primario e un mito o una realta?
- [#16](https://github.com/dataciviclab/openbdap-saldi-storico-stato/discussions/16) Il ricorso al mercato e una costante?
- [#17](https://github.com/dataciviclab/openbdap-saldi-storico-stato/discussions/17) Quanto paga lo Stato in interessi?

## License

CC BY 4.0 - [DataCivicLab](https://dataciviclab.org/)
