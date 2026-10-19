with csat AS (
    SELECT
      *
    FROM planflow-512014.planflow_raw.raw_csat
    where csat_score >= 1 and csat_score <= 5
    qualify row_number() over(partition by ticket_id order by response_datetime desc) = 1
 ),

 tickets as (

 SELECT DISTINCT
          ticket_id,
          CAST(ticket_date AS DATE) AS ticket_date,
          agent_id,
          customer_id,
          channel,
          contact_reason,
          tma_minutes,
          within_sla = 'Sim'        AS within_sla,
          reopened = 'Sim'          AS reopened,
          escalated = 'Sim'         AS escalated
  FROM `planflow-512014.planflow_raw.raw_tickets`
  WHERE tma_minutes < 999
 )


SELECT
  tickets.*,
  csat.csat_score,
  csat.response_datetime,
  case when csat.csat_score is not null then 1 else 0 end as fl_responded,
  case
    when csat_score >= 4 then TRUE
    when csat_score is not null and csat_score <4 then FALSE
    else null
  end as fl_csat_percentual,
  case
    when csat_score is not null then date_diff( CAST(response_datetime AS DATE), CAST(tickets.ticket_date AS DATE),DAY)
    else null
  end as sla_reposta,
  leader_id
FROM tickets
LEFT JOIN CSAT
  on tickets.ticket_id = CSAT.Ticket_Id
LEFT JOIN planflow-512014.planflow_raw.historico_lideranca hst
  on hst.agent_id = tickets.agent_id
  and cast(hst.valid_from as date) <= cast(tickets.ticket_date as date)
  and coalesce(cast(valid_to as date), date(9999,12,31)) >= cast(tickets.ticket_date as date)
