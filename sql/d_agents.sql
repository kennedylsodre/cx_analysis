SELECT
  agent_id,
  agent_name,
  agent_email,
  tower,
  CAST(hire_date AS DATE) AS hire_date
FROM `planflow-512014.planflow_raw.dim_agentes`
