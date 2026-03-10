# Metodo del progetto

## Obiettivo

Rispondere a domande civiche sul bilancio dello Stato usando una pipeline semplice, trasparente e replicabile su due dataset OpenBDAP:

- saldi storici
- spese per missione / programma / macroaggregato

## Architettura adottata

Questo repo usa una architettura legacy esplicita:

- notebook `01_source_raw.ipynb` per il layer `RAW`
- notebook `02_raw_clean.ipynb` per il layer `CLEAN`
- notebook di analisi / risposta alle Discussions come layer `MART` e output pubblico

Questa scelta e accettata come parte del progetto.
Non viene trattata come migrazione incompleta.

## Assunzioni

- il CSV ufficiale OpenBDAP e la fonte di verita per ogni dataset
- il layer `RAW` deve restare immutato
- il layer `CLEAN` normalizza naming e tipi, ma non reinterpreta i dati
- le risposte pubbliche usano notebook e output dati espliciti, non trasformazioni nascoste

## Limiti dei dati

- i valori sono nominali
- i dati possono essere rivisti ex post dalla fonte
- non c'e contesto macro integrato (PIL, inflazione, debito)
- il dataset spese non copre da solo l'intero lato entrate / fabbisogno

## Scelte metodologiche

- tenere separati i due dataset invece di forzare subito un modello unico
- usare le Discussions come punto di atterraggio degli output, non solo come backlog
- chiudere il progetto come legacy stabile invece di forzare ora un retrofit completo al `toolkit`

## Cosa NON copre questo progetto

- una terza pipeline sulle entrate
- una migrazione completa dell'architettura al `toolkit`
- una dashboard unica che esaurisca tutto il progetto

## Come replicare

1. scaricare i dataset RAW ufficiali con `01_source_raw.ipynb`
2. costruire i parquet CLEAN con `02_raw_clean.ipynb`
3. usare i notebook / query di analisi per generare gli output pubblici
4. aggiornare README e cartelle `data/` con link e note coerenti
