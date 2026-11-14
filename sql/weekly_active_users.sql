-- Weekly Active Users (WAU)
-- Definition: number of DISTINCT users with at least one session in the week.
-- Grain: one row per week.
-- Source: ANALYTICS.SESSION_SUMMARY, built by elt_weekly_active_users.py.
-- Notes: the first and last weeks in the data may be partial.
--        Week boundaries follow Snowflake's WEEK_START session setting.
select
    date_trunc('week', ts)  as week_start,
    count(distinct userid)  as wau
from USER_DB_LIZARD.ANALYTICS.SESSION_SUMMARY
group by 1
order by 1;
