# docs/dataset.md

## Dataset coperti dal progetto

Questo progetto chiude il proprio perimetro su due dataset OpenBDAP:

1. `Rendiconto Pubblicato - Serie storica - Saldi`
2. `Rendiconto Pubblicato - Serie storica - Spese aggregato per missione, programma e macroaggregato`

L'obiettivo e mantenere una pipeline trasparente e replicabile:

`RAW -> CLEAN -> MART`

senza introdurre interpretazioni o rielaborazioni concettuali nel layer dati.

## Dataset 1 - Saldi storici dello Stato

Fonte primaria:

- Portale OpenBDAP - Ragioneria Generale dello Stato (RGS)
- Dataset: [Rendiconto Pubblicato - Serie storica - Saldi](https://bdap-opendata.rgs.mef.gov.it/content/rendiconto-pubblicato-serie-storica-saldi)
- Metadata ufficiale: [documentazione tecnica](https://bdap-opendata.rgs.mef.gov.it/sites/default/files/metadata_updfile/report/5191_Saldi%20Rendiconto.pdf)

Accesso dati:

- nel progetto viene utilizzato il CSV diretto come snapshot RAW

Unita di analisi:

- primaria: `esercizio_finanziario`
- livello: Stato centrale
- aggregazione: nazionale

Campi core:

- saldi: `saldo_netto_da_finanziare`, `indebitamento_netto`, `avanzo_primario`, `ricorso_al_mercato`, `risparmio_pubblico`
- spesa aggregata: `spese_correnti`, `spese_per_interessi`, `spese_in_conto_capitale`, `spese_finali`, `spese_complessive`
- entrata aggregata: `entrate_tributarie`, `entrate_extra_tributarie`, `entrate_correnti`, `entrate_finali`, `entrate_accensione_prestiti`

## Dataset 2 - Spese per missione, programma e macroaggregato

Fonte primaria:

- Portale OpenBDAP - Ragioneria Generale dello Stato (RGS)
- Dataset: [Rendiconto Pubblicato - Serie storica - Spese aggregato per missione, programma e macroaggregato](https://bdap-opendata.rgs.mef.gov.it/content/rendiconto-pubblicato-serie-storica-spese-aggregato-missione-programma-e-macroaggregato)

Accesso dati:

- nel progetto viene utilizzato il CSV diretto come snapshot RAW

Unita di analisi:

- chiave composta: `esercizio_finanziario`, `codice_missione`, `codice_programma`, `codice_macroaggregato`
- livello: Stato centrale
- granularita: missione / programma / macroaggregato

Campi core:

- dimensioni: `missione`, `programma`, `macroaggregato`
- misure principali: `previsioni_definitive_cp`, `previsioni_definitive_cs`

Stato nel repo:

- il dataset 2 e coperto a livello `RAW -> CLEAN`
- la sua presenza nel repo serve a tenere aperto un possibile filone di lettura sulla composizione della spesa
- al momento, pero, gli output pubblici discussion-linked gia chiusi restano centrati soprattutto sul dataset 1 (`saldi storici`)

## Limiti noti

1. Revisione storica possibile
- i valori possono essere oggetto di revisioni nel tempo da parte di RGS

2. Valori nominali
- nessun aggiustamento per inflazione nel CLEAN

3. Assenza di contesto macro
- il progetto non integra PIL, inflazione o debito pubblico totale

4. Definizioni tecniche
- i saldi e le voci di spesa seguono le definizioni contabili ufficiali

5. Perimetro chiuso
- questo repo non aggiunge ora una terza linea dataset su `entrate`

## Assunzioni minime adottate

Nel passaggio `RAW -> CLEAN`:

- nessuna modifica semantica ai valori
- nessun ricalcolo di saldi
- nessuna imputazione dei null
- rename coerente in `snake_case`
- cast tipi numerici
- export Parquet

## Cosa questo progetto non fa

- non costruisce un data model unico multi-dataset in stile `toolkit`
- non integra ora una serie dedicata sulle entrate
- non usa i layer dati per produrre giudizi politici automatici

## Evoluzione futura fuori scope

Possibili evoluzioni future, ma non parte della chiusura di questo repo:

- prototipo `toolkit-native` separato
- estensione a un dataset entrate
- serie integrate con indicatori macro esterni
