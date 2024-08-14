test_that("gpt_to_tibble works", {
  # setup
  resp <- "```json\n{\n  \"sensazione_calmo\": {\n    \"risposta\": \"no\",\n    \"motivazione\": \"Il soggetto riporta gonfiore e dolore, il che suggerisce una condizione di disagio e quindi non sembra calmo.\"\n  },\n  \"sensazione_irritato\": {\n    \"risposta\": \"si\",\n    \"motivazione\": \"Il dolore e il gonfiore possono causare irritazione e fastidio, quindi è probabile che il soggetto si senta irritato.\"\n  },\n  \"sensazione_ansioso\": {\n    \"risposta\": \"si\",\n    \"motivazione\": \"La presenza di dolore e gonfiore può generare ansia e preoccupazione riguardo alla propria salute.\"\n  },\n  \"sensazione_ottimista\": {\n    \"risposta\": \"no\",\n    \"motivazione\": \"Non ci sono indicazioni di ottimismo nel messaggio, dato che il soggetto sta affrontando un problema di salute.\"\n  },\n  \"sensazione_demotivato\": {\n    \"risposta\": \"NA\",\n    \"motivazione\": \"Non ci sono informazioni sufficienti per determinare se il soggetto si sente demotivato riguardo al recupero.\"\n  },\n  \"sensazione_stanco\": {\n    \"risposta\": \"NA\",\n    \"motivazione\": \"Non ci sono dettagli sul livello di energia o stanchezza del soggetto, quindi non è possibile inferire questa sensazione.\"\n  },\n  \"momento\": {\n    \"risposta\": \"NA\",\n    \"motivazione\": \"Non è specificato in quale momento della giornata è stato scritto il messaggio.\"\n  },\n  \"andamento\": {\n    \"risposta\": \"NA\",\n    \"motivazione\": \"Non ci sono informazioni sull'andamento del recupero, quindi non è possibile fare un'analisi.\"\n  },\n  \"impatto\": {\n    \"risposta\": \"moderato\",\n    \"motivazione\": \"Il dolore e il gonfiore alla parte alta della pancia possono causare impedimenti nel condurre le attività quotidiane.\"\n  }\n}\n```"

  # evaluation
  parsed <- gpt_to_tibble(resp)

  # test
  expect_tibble(parsed, ncols = 18, nrows = 1)
})
