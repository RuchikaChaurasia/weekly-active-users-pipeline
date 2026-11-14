# Weekly Active Users (WAU) Pipeline: raw load, then in-warehouse transform (Airflow + Snowflake)

Two Airflow DAGs from coursework (SJSU DATA 226) that prepare the data behind a Weekly Active Users metric.

| File | Schedule | What it does |
|---|---|---|
| `etl_weekly_active_users.py` | daily 02:30 | Creates two raw tables, `user_session_channel` and `session_timestamp`, and loads them from a stage with `COPY INTO` inside a transaction |
| `elt_weekly_active_users.py` | daily 02:45 | Joins the raw tables into `ANALYTICS.SESSION_SUMMARY` using SQL in the warehouse. It builds a temp table, checks primary-key uniqueness and duplicate rows, and only then swaps it into place |
| `sql/weekly_active_users.sql` | n/a | The WAU query on top of `SESSION_SUMMARY` |

## WAU definition
WAU is the **count of distinct users** with at least one session in a week. It is defined in `sql/weekly_active_users.sql`. In class I charted the same metric in Preset (managed Superset) on top of `SESSION_SUMMARY`.

## About the file names
The file names keep the ETL and ELT labels from the course. In practice, the ETL file only loads raw data and applies no transformation. The transformation happens in the ELT file, using SQL inside the warehouse. Together they form one pipeline: load raw, then transform and validate.

## Why the build, check, swap step matters
The ELT DAG never writes to the published table until its checks pass. A failed check stops the run, so the dashboard keeps showing the last good version instead of a broken one.

## Limitations
- The database name `USER_DB_LIZARD` is hard-coded (a course training account).
- The checks cover key uniqueness and duplicate rows only. There are no checks on nulls or freshness.
- The two DAGs are scheduled 15 minutes apart. They are not wired to wait for each other.

## Tech
Python, Apache Airflow, Snowflake
