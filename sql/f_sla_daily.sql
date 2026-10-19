SELECT
  CAST(date AS DATE)                              AS date,
  sla.agent_id,
  scheduled_hours,
  CAST(REPLACE(adherence, ',', '.') AS FLOAT64)   AS adherence,
  leader_id
FROM planflow-512014.planflow_raw.raw_sla_diario sla
LEFT JOIN planflow-512014.planflow_raw.historico_lideranca hst
on hst.agent_id = sla.agent_id
and cast(hst.valid_from as date) <= cast(sla.date as date)
and coalesce(cast(valid_to as date), date(9999,12,31)) >= cast(sla.date as date)
