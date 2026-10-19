-- Conferência da carga: total de linhas por tabela e estatísticas das colunas numéricas
-- Tabelas sem indicador numérico mostram só o total de linhas (demais colunas ficam NULL)
-- Troque planflow-512014 pelo PROJECT_ID do .env, se for outro

SELECT 'dim_agentes' AS tabela, CAST(NULL AS STRING) AS indicador, COUNT(*) AS linhas,
       CAST(NULL AS INT64) AS preenchidos, CAST(NULL AS FLOAT64) AS media, CAST(NULL AS FLOAT64) AS soma,
       CAST(NULL AS FLOAT64) AS minimo, CAST(NULL AS FLOAT64) AS maximo
FROM `planflow-512014.planflow_raw.dim_agentes`

UNION ALL
SELECT 'dim_lideres', NULL, COUNT(*), NULL, NULL, NULL, NULL, NULL
FROM `planflow-512014.planflow_raw.dim_lideres`

UNION ALL
SELECT 'historico_lideranca', NULL, COUNT(*), NULL, NULL, NULL, NULL, NULL
FROM `planflow-512014.planflow_raw.historico_lideranca`

UNION ALL
SELECT 'dim_clientes', NULL, COUNT(*), NULL, NULL, NULL, NULL, NULL
FROM `planflow-512014.planflow_raw.dim_clientes`

UNION ALL
SELECT 'raw_tickets', 'tma_minutes', COUNT(*), COUNT(tma_minutes),
       AVG(tma_minutes), SUM(tma_minutes), MIN(tma_minutes), MAX(tma_minutes)
FROM `planflow-512014.planflow_raw.raw_tickets`

UNION ALL
SELECT 'raw_csat', 'csat_score', COUNT(*), COUNT(csat_score),
       AVG(csat_score), SUM(csat_score), MIN(csat_score), MAX(csat_score)
FROM `planflow-512014.planflow_raw.raw_csat`

UNION ALL
SELECT 'raw_qualidade', 'quality_score', COUNT(*), COUNT(quality_score),
       AVG(quality_score), SUM(quality_score), MIN(quality_score), MAX(quality_score)
FROM `planflow-512014.planflow_raw.raw_qualidade`

UNION ALL
SELECT 'raw_sla_diario', 'scheduled_hours', COUNT(*), COUNT(scheduled_hours),
       AVG(scheduled_hours), SUM(scheduled_hours), MIN(scheduled_hours), MAX(scheduled_hours)
FROM `planflow-512014.planflow_raw.raw_sla_diario`

UNION ALL
SELECT 'raw_absenteismo', 'scheduled_hours', COUNT(*), COUNT(scheduled_hours),
       AVG(scheduled_hours), SUM(scheduled_hours), MIN(scheduled_hours), MAX(scheduled_hours)
FROM `planflow-512014.planflow_raw.raw_absenteismo`

ORDER BY tabela;
