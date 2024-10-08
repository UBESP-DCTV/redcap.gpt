compose_sys_role <- function() {
  "Sei un biostatistico specializzato nell'analisi di campi testuali in linguaggio naturale di sondaggi e questionari."
}

compose_sys_context <- function() {
  "Le risposte provengono dallo studio COPPER, che esamina l'impatto della crioanalgesia sulla gestione del dolore e sul recupero nei pazienti di età superiore ai 12 anni sottoposti a riparazione del pectus excavatum."
}

compose_usr_task <- function() {
  "Il tup compito è quello di estrarre/inferire informazioni strutturate dalle risposte che ti vengono fornite."
}

compose_usr_instructions <- function() {
  "Dal testo fornito dal soggetto, riportato qui di seguito tra la coppia di delimitatori `#####`, estrai le seguenti informazioni:
    - [sensazione_calmo]: basandosi sul tono/stile e su quanto esplicitamente scritto, il soggetto sembra calmo/tranquillo/sereno? - {si/no}
    - [sensazione_irritato]: basandosi sul tono/stile e su quanto esplicitamente scritto, il soggetto sembra irritato/infastidito? - {si/no}
    - [sensazione_ansioso]: basandosi sul tono/stile e su quanto esplicitamente scritto, il soggetto sembra ansioso/preoccupato/nervoso? - {si/no}
    - [sensazione_ottimista]: basandosi sul tono/stile e su quanto esplicitamente scritto, il soggetto sembra ottimista/positivo verso il recupero? - {si/no}
    - [sensazione_demotivato]: basandosi sul tono/stile e su quanto esplicitamente scritto, il soggetto sembra demotivato/negativo verso il recupero? - {si/no}
    - [sensazione_stanco]: basandosi sul tono/stile e su quanto esplicitamente scritto, il soggetto sembra stanco/esaurito fisicamente o mentalmente? - {si/no}
    - [momento_mattina]: ci sono sensazioni che nella descrizione sono state collocate (esplicitamente) al mattino? - {si/no}
    - [momento_pomeriggio]: ci sono sensazioni che nella descrizione sono state collocate (esplicitamente) al pomeriggio? - {si/no}
    - [momento_sera]: ci sono sensazioni che nella descrizione sono state collocate (esplicitamente) alla sera? - {si/no}
    - [momento_notte]: ci sono sensazioni che nella descrizione sono state collocate (esplicitamente) nella notte? - {si/no}
    - [andamento]: come pare stia procedendo il recupero? - {peggiore/migliore/costante/altalenante}
    - [impatto]: che impatto sulle attività si manifesta? - {nessuno (attività regolari) / leggero (disagio nel condurre le attività) / moderato (impedimenti nel condurre le attività) / grave (limitazioni nel condurre le attività) / critico (impossibilità di condurre le attività)}  
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
        "risposta": <rispsota>,
        "motivazione": <motivazione per la risposta data>
      },
      sensazione_irritato = {
        "risposta": <rispsota>,
        "motivazione": <motivazione per la risposta data>
      },
      sensazione_ansioso = {
        "risposta": <rispsota>,
        "motivazione": <motivazione per la risposta data>
      },
      sensazione_ottimista = {
        "risposta": <rispsota>,
        "motivazione": <motivazione per la risposta data>
      },
      sensazione_demotivato = {
        "risposta": <rispsota>,
        "motivazione": <motivazione per la risposta data>
      },
      sensazione_stanco = {
        "risposta": <rispsota>,
        "motivazione": <motivazione per la risposta data>
      },
      momento_mattina = {
        "risposta": <rispsota>,
        "motivazione": <motivazione per la risposta data>
      },
      momento_pomeriggio = {
        "risposta": <rispsota>,
        "motivazione": <motivazione per la risposta data>
      },
      momento_sera = {
        "risposta": <rispsota>,
        "motivazione": <motivazione per la risposta data>
      },
      momento_notte = {
        "risposta": <rispsota>,
        "motivazione": <motivazione per la risposta data>
      },
      andamento = {
        "risposta": <rispsota>,
        "motivazione": <motivazione per la risposta data>
      },
      impatto = {
        "risposta": <rispsota>,
        "motivazione": <motivazione per la risposta data>
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