# Global AI Adoption & Workforce Impact Analysis

An end-to-end data analytics project examining how AI adoption, investment, and maturity relate to business outcomes and workforce impact across 10,000 companies in 30 countries. Built with Python (pandas) for data cleaning and validation, SQL (MySQL) for analysis, and Power BI for an interactive dashboard.

---

## 🎯 Business Problem

AI adoption is often reported as a single headline number ("X% of companies use AI"), but that hides the real business question: is adoption actually translating into productivity, revenue, and cost outcomes — and what happens to the workforce along the way? This project traces that relationship end-to-end across a multi-table, multi-country dataset to answer:
- How effectively are companies converting AI adoption and investment into productivity and business growth?
- Is AI adoption creating net job gains or net job losses, and does that vary by industry?
- Does company size, adoption maturity, or internal governance change the outcome?
- Does a country's digital maturity, AI policy, or economic environment influence company-level adoption and outcomes?

---

## 🗂️ Dataset

The project uses a relational dataset covering company-level survey responses, a country-level reference table, and a pre-aggregated industry benchmark table:

| Table | Records | Description |
|---|---:|---|
| Country AI Index| 30 | Country-level GDP, digital maturity, AI policy, patents, researchers|
| AI Company Adoption| 150,000 | Company-quarter survey observations: adoption, investment, governance, workforce, and business outcomes |
| AI Industry Summary | 9 | Pre-aggregated industry-level benchmark averages |

**Dataset Source:** [Kaggle](https://www.kaggle.com/datasets/mohankrishnathalla/global-ai-adoption-and-workforce-impact-dataset)

---

## 🛠️ Tools & Technologies

- Python (pandas) — data validation, referential integrity checks, grain confirmation
- SQL (MySQL) — aggregation, window functions, joins, reusable views
- Data Visualization (Microsoft Power BI) — 4-page interactive dashboard with DAX measures

---

## 📊 Dashboard Preview

The final Power BI report contains four interactive analytical pages:

### 1. Executive Overview
<img src="screenshots/1_Executive_Overview.png" alt="Executive Overview Dashboard" width="50%" height="50%">

High-level view of the global adoption landscape. 10,000 companies, 36.41% average AI adoption rate, 9.27% average productivity change, 4.61% average revenue growth, 4.81% average cost reduction, and a net workforce impact of +977K jobs. Both adoption and productivity trend steadily upward from 2023 to 2026 (33.50% → 39.24% adoption; 8.53% → 10.00% productivity change). Enterprises outperform SMEs and Startups on productivity gains (12.08% vs 8.92% vs 8.20%).

### 2. AI Adoption & Business Impact
<img src="screenshots/2_AI Adoption_&_Business Impact.png" alt="AI Adoption & Business Impact Dashboard" width="50%" height="50%">

Answers whether higher adoption actually corresponds to better outcomes. Technology leads all industries on both adoption (42.47%) and productivity change (11.17%). Productivity climbs sharply and consistently with adoption stage — from 2.39% (none) to 6.17% (pilot) to 12.03% (partial) to 19.79% (full). Primary AI tool choice makes only a marginal difference (9.09%–9.47% productivity change across GitHub Copilot, Claude, ChatGPT, Gemini, and custom internal tools) — no single tool stands out as a clear driver.

### 3. Workforce Impact
<img src="screenshots/3_Workforce_Impact.png" alt="Workforce Impact Dashboard" width="50%" height="50%"> 

17.68M jobs created, 16.71M jobs displaced, a net impact of +977K jobs, and 27.25M employees reskilled. The net-impact story is not uniform: Technology (+323,747), Finance (+241,647), and Healthcare (+176,667) show the strongest net job gains, while Manufacturing (−69,374), Retail (−68,995), and Logistics (−63,565) show net job losses. Job creation and displacement both scale sharply with adoption stage — full-adoption companies create ~54x more jobs on average than non-adopters (438.5 vs 8.1), but displace proportionally as well (396.2 vs 13.5).

### 4. Country & Industry Analysis
<img src="screenshots/4_Country_&_Industry Analysis.png" alt="Country & Industry Analysis Dashboard" width="50%" height="50%"> 

Connects company-level outcomes to national context. Australia, Singapore, and the USA lead country-level adoption (39.9%, 39.3%, 39.2%), all under Moderate policy regimes. Digital maturity index shows a loose positive association with adoption rate but no tight linear relationship — several Lenient-policy, mid-digital-maturity countries (Colombia, Vietnam, Indonesia) still post above-average adoption. Country AI policy strictness (Strict/Moderate/Lenient) shows only a modest difference in average adoption, suggesting policy environment alone is not a strong standalone predictor.

---

## 💡 Key Insights

1. Adoption maturity is the strongest lever, not tool choice — productivity change scales cleanly with adoption stage (2.39% → 19.79%), while the specific AI tool used barely moves the needle (a <0.4 point spread across all six tools).
2. AI adoption's workforce effect is industry-dependent, not uniformly positive — three of nine industries (Manufacturing, Retail, Logistics) show net job losses even as the overall dataset nets positive, meaning a single blended "AI creates jobs" headline hides real sector-level disruption.
3. Investment and adoption both show a monotonic, tercile-consistent relationship with productivity — moving from the bottom third to top third of either investment or adoption roughly doubles average productivity change, a pattern that held up under percentile-based (not arbitrary) grouping.
4. Country-level policy strictness is a weak standalone predictor of adoption — geographic/economic context does not override differences at the industry and adoption-stage level, and should be treated as a secondary rather than primary driver.

---

## 🚧 Limitations

- The dataset is synthetic and used for analytical and portfolio purposes.
- One row represents a company-quarter observation, not a unique company — all company-level metrics (e.g. total investment) were computed with this grain explicitly accounted for to avoid double-counting across quarters.
- ai_investment_per_employee has a long right tail (99th percentile ~$419K vs a max of ~$1.9M); high-investment group averages are influenced by this tail and were not independently outlier-corrected in the final dashboard.
- The "efficiency proxy" and quadrant segmentation (AI Leader / Efficient Adopter / Over-Investor / Emerging Adopter) are descriptive segmentations based on median splits, not validated financial ROI calculations.
- Associations between adoption, maturity, investment, governance, and outcomes are observational and should not be interpreted as causal.
The analysis does not include external factors such as macroeconomic conditions, company-specific strategy, or unobserved confounders behind why some companies adopt AI more aggressively than others.

---
