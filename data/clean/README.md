# /data/clean - Dati puliti

Questa cartella documenta il layer CLEAN del dataset OpenBDAP "Rendiconto pubblicato - Serie storica - Saldi".

Notebook che genera il clean:
[02_raw_clean.ipynb](https://github.com/dataciviclab/openbdap-saldi-storico-stato/blob/20e49144f32db9a4a727e59b861f9935ef9cf5cd/notebooks/02_raw_clean.ipynb)

## Obiettivo del CLEAN

Produrre una serie storica annuale coerente e pronta per analisi, senza alterare il significato dei valori di business.

Il passaggio RAW -> CLEAN applica solo:
- parsing CSV
- rename colonne in `snake_case`
- mapping semantico dei nomi colonna attesi
- cast dei tipi
- export parquet
- metadata di tracciabilita

Non vengono applicati:
- ricalcoli contabili
- correzioni manuali dei saldi
- normalizzazioni economiche
- interpretazioni del dato

## Struttura output

Ogni esecuzione salva i file in:

`data/clean/openbdap_rendiconto_saldi_storico/<RUN_ID>/`

Output attesi:
- `saldi_storico.parquet`
- `columns_mapping_raw_to_clean.json`
- `profile_clean.json`
- `clean_manifest.json`

## Schema logico atteso

Chiave:
- `esercizio_finanziario` -> `INTEGER`

Misure principali:
- `risparmio_pubblico` -> `DOUBLE`
- `saldo_netto_da_finanziare` -> `DOUBLE`
- `indebitamento_netto` -> `DOUBLE`
- `ricorso_al_mercato` -> `DOUBLE`
- `avanzo_primario` -> `DOUBLE`

Aggregati di spesa:
- `spese_correnti` -> `DOUBLE`
- `spese_per_interessi` -> `DOUBLE`
- `spese_in_conto_capitale` -> `DOUBLE`
- `spese_acquisizione_attivita_finanziarie` -> `DOUBLE`
- `spese_per_rimborso_prestiti` -> `DOUBLE`
- `spese_complessive` -> `DOUBLE`
- `spese_finali` -> `DOUBLE`
- `spese_finali_netto_att_fin` -> `DOUBLE`

Aggregati di entrata:
- `entrate_tributarie` -> `DOUBLE`
- `entrate_extra_tributarie` -> `DOUBLE`
- `entrate_alienazioni_patrimoniali_e_riscossioni` -> `DOUBLE`
- `riscossione_crediti` -> `DOUBLE`
- `entrate_accensione_prestiti` -> `DOUBLE`
- `entrate_finali` -> `DOUBLE`
- `entrate_fin_netto_riscossione_crediti` -> `DOUBLE`
- `entrate_correnti` -> `DOUBLE`

Colonne non riconosciute dal mapping:
- fallback a `snake_case`
- cast conservativo a `VARCHAR`, salvo gestione esplicita nel notebook

## Policy di parsing

Parsing numerico:
- trim degli spazi
- supporto a valori con `,` o `.`
- cast finale a `DOUBLE`

Valori speciali:
- `NULL` se il valore e vuoto o non parseabile
- nessuna sostituzione arbitraria di valori economici

Policy generale:
- i valori vengono solo convertiti di tipo
- il significato economico resta invariato rispetto al RAW

## Controlli qualita minimi consigliati

- numero righe atteso coerente con la serie annuale
- presenza della colonna `esercizio_finanziario`
- assenza di duplicati sulla chiave anno
- presenza delle colonne core attese
- controllo null per colonna

## Metadata salvati

- `columns_mapping_raw_to_clean.json`: mapping colonne RAW -> CLEAN
- `profile_clean.json`: dimensioni, colonne, null, sample righe
- `clean_manifest.json`: input/output e hash SHA256
