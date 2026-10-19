SELECT
  agent_id,
  leader_id,
  CAST(valid_from AS DATE) AS valid_from,
  CAST(valid_to AS DATE)   AS valid_to
FROM `planflow-512014.planflow_raw.historico_lideranca`
