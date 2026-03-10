# Bilancio dello Stato - Serie storica saldi e spese per missione (2003-2024)

## Domanda civica

La spesa corrente comprime strutturalmente gli investimenti, o il pattern cambia per missione e programma?

## Perché questo progetto

Negli ultimi vent'anni lo Stato italiano ha chiuso ogni esercizio in deficit, con la spesa corrente che assorbe in media il 64% del totale. La spesa in conto capitale si e fermata all'8,5%, toccando il minimo del 4,9% nel 2015. L'avanzo primario e stato positivo in 16 anni su 22, ma gli interessi sul debito (75-90 mld/anno) lo hanno azzerato sistematicamente.

Questo progetto verifica se la compressione degli investimenti sia strutturale o congiunturale, analizzando:

- la serie storica dei saldi aggregati dello Stato
- la serie storica delle spese per missione, programma e macroaggregato

## Ruoli

- Project Lead: [Gabri](https://github.com/Gabrymi93)
- Data: [Matteo](https://github.com/matteocavo) · [Gabri](https://github.com/Gabrymi93)
- Ricerca semantica CERES: [Andrea](https://github.com/AndreaBozzo)
- Viz: [Matteo](https://github.com/matteocavo)
- QA: [Gabri](https://github.com/Gabrymi93)
- Docs: [Matteo](https://github.com/matteocavo)

## Dataset utilizzati

- Fonte: [OpenBDAP - Rendiconto Pubblicato, Serie storica Saldi](https://bdap-opendata.rgs.mef.gov.it/content/rendiconto-pubblicato-serie-storica-saldi)
- Fonte: [OpenBDAP - Spese per Missione, Programma e Macroaggregato](https://bdap-opendata.rgs.mef.gov.it/content/rendiconto-pubblicato-serie-storica-spese-aggregato-missione-programma-e-macroaggregato)
- Periodo: 2003-2024 (saldi) · 2008-2024 (spese)
- Livello: Nazionale - Stato centrale

## Perimetro finale del progetto

Questo repo chiude il proprio perimetro su due dataset:

- `saldi storici`
- `spese per missione / programma / macroaggregato`

Non entra in questo perimetro finale:

- una terza linea su `entrate`
- una migrazione completa al `toolkit`
- una rifondazione dell'architettura dati del repo

Il progetto viene quindi mantenuto come `legacy-active / stable`, con pipeline esplicita nei notebook e output pubblici nelle Discussions / dashboard.

## Output pubblico

- Tipo: dashboard / discussions
- Link: (quando disponibile)

## Stato progetto

Legacy-active / stable

- il repo resta valido e consultabile
- la pipeline corrente e documentata
- eventuali evoluzioni future `toolkit-native` vanno trattate come filone separato

## Come si contribuisce

1. **[Discussion](https://github.com/dataciviclab/openbdap-saldi-storico-stato/discussions)** per idee / contesto
2. **[Issue](https://github.com/orgs/dataciviclab/projects/5/views/7?sliceBy%5Bvalue%5D=dataciviclab%2Fopenbdap-saldi-storico-stato)** per task concreti
3. **Branch** per lavorare
4. **Pull Request** per revisione e merge

Dettagli in `WORKFLOW.md`.

## Link utili

- [Avanzamento progetto](https://github.com/orgs/dataciviclab/projects/5)
- [Metodo DataCivicLab](https://github.com/dataciviclab/dataciviclab/blob/main/METHOD.md)

## Chiusura del progetto

Questo progetto si considera chiuso bene quando:

- le principali Discussions hanno almeno una risposta dati pubblica
- i notebook principali sono identificati e documentati come pipeline / output
- `raw`, `clean` e `mart` sono descritti in modo coerente con il perimetro reale
- README, metodo e dataset dicono chiaramente cosa il progetto copre e cosa no

## Discussions principali e stato

| Discussion | Tema | Stato | Notebook collegato |
|---|---|---|---|
| `#9` | Deficit strutturale | risposta pubblicata + follow-up numerico pubblicato | `notebooks/discussions/04_risposta_discussion_09_deficit_strutturale.ipynb` |
| `#16` | Ricorso al mercato | commento pronto / notebook in attesa di push | da importare |
| `#14` | Avanzo primario | materiale analitico presente, stato da riallineare nel repo | da collegare |
| `#12` | Entrate tributarie e copertura della macchina | materiale analitico presente, notebook in attesa di push | da collegare |
| `#10` | Spese correnti vs investimenti | commento pronto / notebook in attesa di push | da importare |
| `#17` | Interessi sul debito | discussion pubblicata, output da collegare nel repo | da collegare |

Il criterio di chiusura non e avere una nuova architettura, ma rendere leggibile il legame:

`Discussion -> notebook -> risposta dati`
