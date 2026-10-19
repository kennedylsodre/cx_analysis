SELECT
  ticket_id,
  CAST(ticket_date AS DATE) AS ticket_date,
  agent_id,
  channel,
  csat_score,
  survey_sent = 'Sim'       AS survey_sent,
  response_datetime
FROM `planflow-512014.planflow_raw.raw_csat`
