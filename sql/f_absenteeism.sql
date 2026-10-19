SELECT
  CAST(date AS DATE) AS date,
  absenteismo.agent_id,
  attendance_status,
  scheduled_hours,
  leader_id
FROM planflow-512014.planflow_raw.raw_absenteismo absenteismo
LEFT JOIN planflow-512014.planflow_raw.historico_lideranca hst
on hst.agent_id = absenteismo.agent_id
and cast(hst.valid_from as date) <= cast(absenteismo.date as date)
and coalesce(cast(valid_to as date), date(9999,12,31)) >= cast(absenteismo.date as date)
