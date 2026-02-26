# 📄 docs/dataset.md

## OpenBDAP – Saldi storici dello Stato

Fonte: Rendiconto Pubblicato – Serie storica – Saldi

# 🎯 Scopo del dataset

Questo progetto utilizza la **serie storica dei saldi di finanza pubblica dello Stato** pubblicata tramite OpenBDAP (RGS/MEF).

L’obiettivo è costruire una pipeline trasparente e replicabile:

RAW → CLEAN → MART

senza introdurre interpretazioni o rielaborazioni concettuali.

# 🔗 Fonte ufficiale

Fonte primaria:

* Portale OpenBDAP – Ragioneria Generale dello Stato (RGS)
* Dataset: *[Rendiconto Pubblicato – Serie storica – Saldi](https://bdap-opendata.rgs.mef.gov.it/content/rendiconto-pubblicato-serie-storica-saldi)*
* Metadata ufficiale [(documentazione tecnica)](https://bdap-opendata.rgs.mef.gov.it/sites/default/files/metadata_updfile/report/5191_Saldi%20Rendiconto.pdf)

Accesso dati:
Nel progetto viene utilizzato **il CSV diretto come snapshot RAW**.

# 🧩 Unità di analisi

Unità primaria:

* **Anno (Esercizio finanziario)**

Granularità:

* Livello: **Stato centrale**
* Aggregazione: **nazionale**
* Non sono presenti disaggregazioni territoriali o per missione.

Ogni riga rappresenta:

```
1 anno = insieme completo dei principali saldi e aggregati di entrata/spesa
```

# 🗝 Campi core identificati

Chiave primaria:

* `esercizio_finanziario`

Misure principali:

* `saldo_netto_da_finanziare`
* `indebitamento_netto`
* `avanzo_primario`
* `ricorso_al_mercato`
* `risparmio_pubblico`

Aggregati di spesa:

* `spese_correnti`
* `spese_per_interessi`
* `spese_in_conto_capitale`
* `spese_finali`
* `spese_complessive`

Aggregati di entrata:

* `entrate_tributarie`
* `entrate_extra_tributarie`
* `entrate_correnti`
* `entrate_finali`
* `entrate_accensione_prestiti`

Tutte le misure sono trattate come:

```
DOUBLE (valori nominali in euro)
```

# ⚠ Limiti noti

1. Revisione storica possibile
   I valori possono essere oggetto di revisioni nel tempo da parte di RGS.

2. Valori nominali
   Non sono deflazionati.
   Nessun aggiustamento per inflazione è applicato nel CLEAN.

3. Assenza di contesto macro
   Il dataset non include:

   * PIL
   * inflazione
   * debito pubblico totale

4. Definizioni tecniche
   I saldi sono definiti secondo criteri contabili ufficiali.
   Non sono reinterpretati nel progetto.

5. Serie limitata temporalmente
   La serie parte dal 2003 (nella versione attuale disponibile).

# 🧠 Assunzioni minime adottate nel progetto

Nel passaggio RAW → CLEAN:

* Nessuna modifica ai valori numerici
* Nessuna normalizzazione
* Nessuna conversione valutaria
* Nessun ricalcolo di saldi
* Nessuna correzione per inflazione

Operazioni applicate:

* Parsing CSV
* Rename coerente snake_case
* Cast tipi numerici
* Export Parquet

# 🚫 Cosa NON stiamo facendo (importante)

* Non stiamo reinterpretando i saldi.
* Non stiamo correggendo discrepanze contabili.
* Non stiamo stimando indicatori mancanti.
* Non stiamo producendo giudizi politici o valutazioni qualitative.

Il progetto è esclusivamente:

```
metodologico + analitico + riproducibile
```

# 🔄 Evoluzioni future (fuori scope attuale)

Possibili estensioni:

* Deflazione valori (euro costanti)
* Collegamento con PIL ISTAT
* Indicatori % su PIL
* Serie integrate con debito pubblico

Non fanno parte dello scope iniziale.