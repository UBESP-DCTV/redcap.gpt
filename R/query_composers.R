compose_sys_role <- function() {
  "Sei un biostatistico con un solido background clinico ed elevate competenze nell'analisi del linguaggio naturale applicata a dati testuali in ambito medico, con un focus sulla valutazione dell’evoluzione post-operatoria"
}

compose_sys_context <- function() {
  "Le risposte a testo libero provengono dallo studio COPPER, uno studio clinico randomizzato che valuta se la crio-analgesia migliori i risultati nella gestione del dolore post-operatorio e nel recupero delle normali attività entro due settimane dall'intervento chirurgico, in adolescenti di età superiore ai 12 anni sottoposti a riparazione del pectus excavatum."
}

compose_usr_task <- function() {
  "Il tuo compito è quello di estrarre/inferire informazioni strutturate dalle risposte testuali dei pazienti, che ti verranno fornite."
}

compose_usr_instructions <- function() {
  "Dal testo fornito dal soggetto, riportato qui di seguito tra la coppia di delimitatori `#####`, estrai le seguenti informazioni in modo coerente con il quadro clinico (tenendo conto che si tratta di testo scritto durante il post-operatorio):
    - [sensazione_calmo]: basandosi sul tono/stile e su quanto esplicitamente scritto, il soggetto sembra calmo/tranquillo/sereno? - {si/no}
    - [sensazione_irritato]: basandosi sul tono/stile e su quanto esplicitamente scritto, il soggetto sembra irritato/infastidito? - {si/no}
    - [sensazione_ansioso]: basandosi sul tono/stile e su quanto esplicitamente scritto, il soggetto sembra ansioso/preoccupato/nervoso? - {si/no}
    - [sensazione_ottimista]: basandosi sul tono/stile e su quanto esplicitamente scritto, il soggetto sembra ottimista/positivo verso il recupero? - {si/no}
    - [sensazione_demotivato]: basandosi sul tono/stile e su quanto esplicitamente scritto, il soggetto sembra demotivato/negativo verso il recupero? - {si/no}
    - [sensazione_stanco]: basandosi sul tono/stile e su quanto esplicitamente scritto, il soggetto sembra stanco/esaurito fisicamente o mentalmente? - {si/no}
    - [sensazione_dolorante]: basandosi sul tono/stile e su quanto esplicitamente scritto, il soggetto sembra dolorante/indolenzito? - {si/no}
    - [momento_mattina]: ci sono sensazioni che nella descrizione sono state collocate (esplicitamente) al mattino? - {si/no}
    - [momento_pomeriggio]: ci sono sensazioni che nella descrizione sono state collocate (esplicitamente) al pomeriggio? - {si/no}
    - [momento_sera]: ci sono sensazioni che nella descrizione sono state collocate (esplicitamente) alla sera? - {si/no}
    - [momento_notte]: ci sono sensazioni che nella descrizione sono state collocate (esplicitamente) nella notte? - {si/no}
    - [andamento]: ci sono elementi per valutare l'andamento post-operatorio? Se si, valutalo. - {si-peggiore/si-migliore/si-costante/si-altalenante/no-NA}
    - [impatto]: qual è l'impatto riferito nel recupero delle normali attività? - {nessuno (attività regolari) / leggero (disagio nel condurre le attività) / moderato (limitazioni nel condurre le attività) / grave (impedimenti nel condurre le attività) / critico (impossibilità di condurre le attività) / non-riferito}
  "
}

compose_usr_output <- function() {
  "Restituisci un JSON in output con le chiavi riportate qui sopra tra quadre, i cui valori sono a loro volta delle coppie chiave-valore in cui riporti la [risposta] che hai fornito (selezionata esclusivamente tra le opzioni riportate tra parentesi graffe per ciascuna domanda) e la [motivazione] in forma discorsiva del perchè hai deciso per quella risposta a partire dalle informazioni che avevi in tuo possesso."
}

compose_usr_style <- function() {
  "In caso di impossibilità a estrarre/inferire una risposta, riporta `NA`."
}

compose_usr_example <- function() {
  'La struttura dell\'output dovrà quindi essere la seguente:
    ```json
    {
      sensazione_calmo = {
        "motivazione": <motivazione per la rispota alla domanda>,
        "risposta": <risposta>
      },
      sensazione_irritato = {
        "motivazione": <motivazione per la rispota alla domanda>,
        "risposta": <risposta>
      },
      sensazione_ansioso = {
        "motivazione": <motivazione per la rispota alla domanda>,
        "risposta": <risposta>
      },
      sensazione_ottimista = {
        "motivazione": <motivazione per la rispota alla domanda>,
        "risposta": <risposta>
      },
      sensazione_demotivato = {
        "motivazione": <motivazione per la rispota alla domanda>,
        "risposta": <risposta>
      },
      sensazione_stanco = {
        "motivazione": <motivazione per la rispota alla domanda>,
        "risposta": <risposta>
      },
      sensazione_dolorante = {
        "motivazione": <motivazione per la rispota alla domanda>,
        "risposta": < risposta>
      },
      momento_mattina = {
        "motivazione": <motivazione per la rispota alla domanda>,
        "risposta": <risposta>
      },
      momento_pomeriggio = {
        "motivazione": <motivazione per la rispota alla domanda>,
        "risposta": <risposta>
      },
      momento_sera = {
        "motivazione": <motivazione per la rispota alla domanda>,
        "risposta": <risposta>
      },
      momento_notte = {
        "motivazione": <motivazione per la rispota alla domanda>,
        "risposta": <risposta>
      },
      andamento = {
        "motivazione": <motivazione per la rispota alla domanda>,
        "risposta": <risposta>
      },
      impatto = {
        "motivazione": <motivazione per la rispota alla domanda>,
        "risposta": <risposta>
      }
    }
    ```

  '
}

compose_usr_closing <- function() {
  "Non restituire null'altro se non il JSON risultante, nessun altro commento, introduzione, o conclusione; solo il JSON."
}

compose_final_closing <- function() {
  "Procedi passo-passo per assicurarti di restituire la migliore risposta corretta possibile."
}
