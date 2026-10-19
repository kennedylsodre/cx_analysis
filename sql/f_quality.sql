with csat AS (
   SELECT
     *
   FROM planflow-512014.planflow_raw.raw_csat
   where csat_score >= 1 and csat_score <= 5
   qualify row_number() over(partition by ticket_id order by response_datetime desc) = 1
)

 SELECT
   quality_id,
   qualidade.ticket_id,
   CAST(qualidade.ticket_date AS DATE) AS ticket_date,
   qualidade.agent_id,
   quality_score,
   monitor_type,
   leader_id,
   csat.csat_score
 FROM planflow-512014.planflow_raw.raw_qualidade qualidade
 LEFT JOIN csat
   on qualidade.ticket_id = csat.ticket_id
 LEFT JOIN planflow-512014.planflow_raw.historico_lideranca hst
 on hst.agent_id = qualidade.agent_id
 and cast(hst.valid_from as date) <= cast(qualidade.ticket_date as date)
 and coalesce(cast(valid_to as date), date(9999,12,31)) >= cast(qualidade.ticket_date as date)
