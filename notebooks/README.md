# /notebooks/discussions

Questa cartella raccoglie i notebook collegati direttamente alle Discussions pubbliche del progetto.

Qui vanno solo notebook che hanno almeno una di queste caratteristiche:

- sono stati condivisi pubblicamente come risposta a una Discussion
- generano i numeri o i grafici usati in un commento pubblico
- rappresentano il layer `mart` effettivo del progetto legacy

Non vanno qui:

- notebook puramente esplorativi
- prove temporanee
- versioni duplicate o intermedie

## Naming consigliato

Usare un nome che renda chiaro il collegamento con la Discussion.

Esempi:

- `04_risposta_discussion_09_deficit_strutturale.ipynb`
- `05_risposta_discussion_10_spese_correnti_investimenti.ipynb`
- `06_risposta_discussion_16_ricorso_mercato.ipynb`
- `07_risposta_discussion_17_interessi_sul_debito.ipynb`

Il prefisso numerico segue l'ordine di lavorazione/import dei notebook Discussion-linked nel repo.

## Stato atteso

Ogni notebook importato qui dovrebbe:

- evitare path locali non replicabili
- avere almeno una nota iniziale su input e output
- essere collegato nel `README.md` del repo

Finche i notebook non sono importati, questa cartella resta la destinazione canonica per chiudere il legame tra Discussions e output analitici.

## Stato attuale

- `04_risposta_discussion_09_deficit_strutturale.ipynb` importato
- `05_risposta_discussion_10_spese_correnti_investimenti.ipynb` creato (split da `openbdap_discussions_risposte_v3.ipynb`)
- `06_risposta_discussion_16_ricorso_mercato.ipynb` creato (split da `openbdap_discussions_risposte_v3.ipynb`)
- `07_risposta_discussion_17_interessi_sul_debito.ipynb` creato (split da `openbdap_discussions_risposte_v3.ipynb`)
