# CX Analysis - PlanFlow

Análise de indicadores de atendimento (CX) a partir da base `Base_Case_PlanFlow.xlsx`. Os dados são carregados no BigQuery e consumidos por um relatório no Power BI.

## Estrutura

```
Base_Case_PlanFlow.xlsx   base original do case
load_bigquery.py          carga das abas do Excel no BigQuery
conferencia_carga.sql     query de conferência da carga
sql/                      queries usadas em cada tabela do Power BI
Power Bi/                 projeto do Power BI (formato PBIP)
```

## 1. Carga no BigQuery

Cada aba do Excel vira uma tabela no dataset `planflow_raw`, com o nome da aba em minúsculo:

- `dim_agentes`
- `dim_lideres`
- `historico_lideranca`
- `dim_clientes`
- `raw_tickets`
- `raw_csat`
- `raw_qualidade`
- `raw_sla_diario`
- `raw_absenteismo`

Nesta camada os dados ficam como no Excel, quase todos como texto. As exceções são as colunas numéricas (`tma_minutes`, `quality_score`, `scheduled_hours`, `csat_score`) e o `response_datetime`, que já são carregados com o tipo correto. A carga sobrescreve as tabelas a cada execução.

Para rodar:

1. Instalar as dependências: `poetry install`
2. Criar um arquivo `.env` na raiz:
   ```
   PROJECT_ID=seu-projeto-gcp
   DATASET_ID=planflow_raw
   ```
3. Autenticar no Google Cloud: `gcloud auth application-default login`
4. Executar: `poetry run python load_bigquery.py`

## 2. Conferência da carga

A query `conferencia_carga.sql` traz, em uma única consulta, a quantidade de linhas de cada tabela e a média, soma, mínimo e máximo das colunas numéricas. Esses valores foram comparados com o Excel: as 9 tabelas bateram em linhas e colunas.

## 3. Modelo no Power BI

O modelo segue o formato estrela: as dimensões guardam os atributos descritivos e as fatos guardam as chaves e as métricas. Cada tabela é uma consulta nativa no BigQuery, e as queries estão na pasta `sql/`.

| Tabela | Conteúdo |
|---|---|
| `d_agents` | Agentes e torre |
| `d_leader` | Líderes |
| `d_clients` | Clientes, segmento, plano e setor |
| `d_calendar` | Calendário gerado em M, da menor à maior data de tickets |
| `f_tickets` | Um registro por ticket, com TMA, SLA, reabertura, escalonamento e nota CSAT |
| `f_quality` | Monitorias de qualidade |
| `f_sla_daily` | Aderência e horas escaladas por agente e dia |
| `f_absenteeism` | Registro de presença por agente e dia |

Tratamentos aplicados nas queries:

- Conversão de datas de texto para `DATE`.
- Conversão de "Sim"/"Não" para booleano.
- Conversão da aderência, que vinha como texto com vírgula decimal, para número.
- Remoção das linhas duplicadas de tickets.
- Nota CSAT levada para a `f_tickets`, considerando só notas de 1 a 5 e uma resposta por ticket. Isso permite calcular a taxa de resposta e analisar o CSAT por canal, motivo e cliente.
- O líder de cada registro é o líder do agente na data do evento, com base no `historico_lideranca`. Assim, uma troca de líder não altera o histórico.

## Observações sobre os dados

- `raw_tickets` tem 342 linhas duplicadas e TMAs inválidos (valores negativos e 999,99).
- `raw_csat` tem notas fora da escala de 1 a 5 e tickets com duas respostas.
- `raw_qualidade` tem notas fora da escala de 0 a 100 e 19 revisões duplicadas.
- `raw_absenteismo` só tem registros "Presente", então não é possível medir ausências com essa base.
