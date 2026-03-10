# /data/mart

Questo layer raccoglie gli output finali usati per rispondere alle Discussions e alimentare eventuali dashboard.

Nel progetto attuale il layer `MART` non è gestito da un file SQL unico o da un `dataset.yml`.
La sua implementazione vive nei notebook / query di analisi che partono dai parquet CLEAN.

## Stato del layer

Legacy stabile.

Significa che:

- il progetto ha output pubblici reali
- i notebook svolgono anche il ruolo di `mart`
- il repo non promette ora una rifondazione del layer finale

## Dataset finali attesi

### 1. Saldi storici dello Stato

Granularita:

- una riga per anno

KPI principali:

- `saldo_netto_da_finanziare`
- `indebitamento_netto`
- `avanzo_primario`
- `ricorso_al_mercato`
- `risparmio_pubblico`
- aggregati di entrata e spesa

Usi principali:

- risposte alle Discussions sui saldi di finanza pubblica
- confronto storico 2003-2024

### 2. Spese per missione / programma / macroaggregato

Granularita:

- anno / missione / programma / macroaggregato

KPI principali:

- `previsioni_definitive_cp`
- `previsioni_definitive_cs`

Usi principali:

- leggere composizione e dinamica della spesa
- verificare se la compressione degli investimenti e strutturale o cambia per missione

Stato attuale:

- questo dataset ha pipeline e struttura documentate
- non esiste ancora, nel repo attuale, un notebook discussion-linked equivalente a quelli gia chiusi sui `saldi`
- quindi il suo ruolo oggi e di base dati pronta per follow-up, non di filone pubblico gia esaurito

## Sorgente del mart

I mart effettivi di questo progetto sono prodotti da:

- notebook di analisi / risposta alle Discussions
- eventuali query documentate in `queries/`

Se in futuro nascerà una versione `toolkit-native`, dovrà essere trattata come filone separato.
