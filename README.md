# Multi-Channel Marketing Analytics 

End-to-end marketing analytics pipeline for a fictional D2C skincare brand. Covers ad performance, web traffic, and revenue using SQL, Power BI, and n8n automation.

---

## Files

| File | Description |
|------|-------------|
| `ads_combined.csv` | Ad performance data (Meta, Google, TikTok) |
| `ga4_simulated.csv` | Simulated GA4 traffic & revenue data |
| `orders_daily.csv` | Daily order revenue and transactions |
| `views.sql` | PostgreSQL views for KPI aggregation |
| `weekly_marketing_refresh.json` | n8n automation workflow |

---

## Flow

```
Raw CSVs → PostgreSQL (SQL Views) → Power BI Dashboard → n8n Weekly Refresh
```

1. **Load CSVs** into PostgreSQL
2. **Run `views.sql`** to create 3 KPI views (by channel, traffic source, daily)
3. **Connect Power BI** to PostgreSQL and explore the dashboard
4. **Import n8n workflow** for automated weekly data refresh via email

---

## Setup

```bash
# Load data into PostgreSQL
\COPY ads_combined FROM 'ads_combined.csv' CSV HEADER;
\COPY ga4_simulated FROM 'ga4_simulated.csv' CSV HEADER;
\COPY orders_daily FROM 'orders_daily.csv' CSV HEADER;

# Create views
psql -d your_db -f views.sql
```

Then open Power BI Desktop → Get Data → PostgreSQL → connect to your database.

For n8n: import the JSON workflow, configure your PostgreSQL and SMTP credentials, and activate.

---

## Dependencies

- PostgreSQL 13+
- Power BI Desktop
- n8n (self-hosted or cloud)
- Python + pandas *(optional, for preprocessing)*

---

## Author

**Harsh Mistry** — OVGU Magdeburg  
Stack: PostgreSQL · Power BI · Python · n8n
