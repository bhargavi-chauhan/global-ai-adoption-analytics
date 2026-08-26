USE ai_adoption_analysis;

-- =========================================================
-- VIEW 1: Overall KPIs
-- Purpose: KPI cards / executive overview
-- =========================================================

CREATE OR REPLACE VIEW vw_ai_overall_kpis AS
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT company_id) AS total_companies,
    ROUND(AVG(ai_adoption_rate), 2) AS avg_adoption_rate,
    ROUND(AVG(ai_maturity_score), 3) AS avg_maturity_score,
    ROUND(AVG(productivity_change_percent), 2) AS avg_productivity_change,
    ROUND(AVG(ai_investment_per_employee), 2) AS avg_investment_per_employee,
    ROUND(AVG(revenue_growth_percent), 2) AS avg_revenue_growth,
    ROUND(AVG(cost_reduction_percent), 2) AS avg_cost_reduction,
    SUM(jobs_created) AS total_jobs_created,
    SUM(jobs_displaced) AS total_jobs_displaced,
    SUM(reskilled_employees) AS total_reskilled
FROM ai_company_adoption;


-- =========================================================
-- VIEW 2: Yearly AI Adoption Trend
-- Purpose: Adoption, maturity and productivity trend
-- =========================================================

CREATE OR REPLACE VIEW vw_ai_yearly_trend AS
SELECT
    survey_year,
    ROUND(AVG(ai_adoption_rate), 2) AS avg_adoption_rate,
    ROUND(AVG(ai_maturity_score), 3) AS avg_maturity_score,
    ROUND(AVG(productivity_change_percent), 2) AS avg_productivity_change,
    ROUND(AVG(revenue_growth_percent), 2) AS avg_revenue_growth,
    ROUND(AVG(cost_reduction_percent), 2) AS avg_cost_reduction
FROM ai_company_adoption
GROUP BY survey_year
ORDER BY survey_year;


-- =========================================================
-- VIEW 3: Industry Analysis
-- Purpose: Compare AI adoption, productivity and business outcomes
-- =========================================================

CREATE OR REPLACE VIEW vw_ai_industry_analysis AS
SELECT
    industry,
    COUNT(*) AS observations,
    ROUND(AVG(ai_adoption_rate), 2) AS avg_adoption_rate,
    ROUND(AVG(ai_maturity_score), 3) AS avg_maturity_score,
    ROUND(AVG(productivity_change_percent), 2) AS avg_productivity_change,
    ROUND(AVG(revenue_growth_percent), 2) AS avg_revenue_growth,
    ROUND(AVG(cost_reduction_percent), 2) AS avg_cost_reduction,
    ROUND(AVG(customer_satisfaction), 2) AS avg_customer_satisfaction
FROM ai_company_adoption
GROUP BY industry
ORDER BY avg_adoption_rate DESC;


-- =========================================================
-- VIEW 4: Adoption & Investment Outcomes
-- Purpose: Compare Low / Medium / High groups
-- Uses NTILE(3) to create balanced groups
-- =========================================================

CREATE OR REPLACE VIEW vw_ai_adoption_investment_outcomes AS

WITH investment_groups AS (
    SELECT
        *,
        NTILE(3) OVER (
            ORDER BY ai_investment_per_employee
        ) AS investment_tercile
    FROM ai_company_adoption
),

adoption_groups AS (
    SELECT
        *,
        NTILE(3) OVER (
            ORDER BY ai_adoption_rate
        ) AS adoption_tercile
    FROM ai_company_adoption
)

SELECT
    'Investment' AS analysis_type,
    CASE
        WHEN investment_tercile = 1 THEN 'Low Investment'
        WHEN investment_tercile = 2 THEN 'Medium Investment'
        WHEN investment_tercile = 3 THEN 'High Investment'
    END AS analysis_group,
    COUNT(*) AS observations,
    ROUND(AVG(ai_investment_per_employee), 2) AS avg_investment,
    ROUND(AVG(ai_adoption_rate), 2) AS avg_adoption_rate,
    ROUND(AVG(productivity_change_percent), 2) AS avg_productivity_change,
    ROUND(AVG(revenue_growth_percent), 2) AS avg_revenue_growth,
    ROUND(AVG(cost_reduction_percent), 2) AS avg_cost_reduction
FROM investment_groups
GROUP BY investment_tercile

UNION ALL

SELECT
    'Adoption' AS analysis_type,
    CASE
        WHEN adoption_tercile = 1 THEN 'Low Adoption'
        WHEN adoption_tercile = 2 THEN 'Medium Adoption'
        WHEN adoption_tercile = 3 THEN 'High Adoption'
    END AS analysis_group,
    COUNT(*) AS observations,
    ROUND(AVG(ai_investment_per_employee), 2) AS avg_investment,
    ROUND(AVG(ai_adoption_rate), 2) AS avg_adoption_rate,
    ROUND(AVG(productivity_change_percent), 2) AS avg_productivity_change,
    ROUND(AVG(revenue_growth_percent), 2) AS avg_revenue_growth,
    ROUND(AVG(cost_reduction_percent), 2) AS avg_cost_reduction
FROM adoption_groups
GROUP BY adoption_tercile;


-- =========================================================
-- VIEW 5: Company Size Analysis
-- Purpose: Startup vs SME vs Enterprise comparison
-- =========================================================

CREATE OR REPLACE VIEW vw_ai_company_size_analysis AS
SELECT
    company_size,
    COUNT(*) AS observations,
    ROUND(AVG(ai_adoption_rate), 2) AS avg_adoption_rate,
    ROUND(AVG(ai_investment_per_employee), 2) AS avg_investment_per_employee,
    ROUND(AVG(productivity_change_percent), 2) AS avg_productivity_change,
    ROUND(AVG(revenue_growth_percent), 2) AS avg_revenue_growth,
    ROUND(AVG(cost_reduction_percent), 2) AS avg_cost_reduction
FROM ai_company_adoption
GROUP BY company_size
ORDER BY avg_productivity_change DESC;


-- =========================================================
-- VIEW 6: Workforce Impact
-- Purpose: Jobs created, displaced and reskilled
-- =========================================================

CREATE OR REPLACE VIEW vw_ai_workforce_impact AS
SELECT
    industry,
    SUM(jobs_created) AS jobs_created,
    SUM(jobs_displaced) AS jobs_displaced,
    SUM(jobs_created) - SUM(jobs_displaced) AS net_jobs_impact,
    SUM(reskilled_employees) AS reskilled_employees
FROM ai_company_adoption
GROUP BY industry
ORDER BY net_jobs_impact DESC;


-- =========================================================
-- VIEW 7: Country & Regional Analysis
-- Purpose: Connect company adoption with country-level AI context
-- =========================================================

CREATE OR REPLACE VIEW vw_ai_country_analysis AS
SELECT
    c.country,
    c.region,
    c.digital_maturity_index,
    c.internet_penetration,
    c.country_ai_policy,
    c.ai_patent_filings_2024,
    c.ai_researchers_per_million,
    ROUND(AVG(a.ai_adoption_rate), 2) AS avg_company_adoption,
    ROUND(AVG(a.ai_maturity_score), 3) AS avg_ai_maturity,
    ROUND(AVG(a.productivity_change_percent), 2) AS avg_productivity
FROM country_ai_index c
JOIN ai_company_adoption a
    ON c.country = a.country
GROUP BY
    c.country,
    c.region,
    c.digital_maturity_index,
    c.internet_penetration,
    c.country_ai_policy,
    c.ai_patent_filings_2024,
    c.ai_researchers_per_million
ORDER BY avg_company_adoption DESC;

-- VIEW 8: AI Governance
CREATE OR REPLACE VIEW vw_ai_governance_analysis AS
SELECT
    data_privacy_level,
    ai_ethics_committee,
    COUNT(*) AS observations,
    ROUND(AVG(regulatory_compliance_score), 2) AS avg_compliance_score,
    ROUND(AVG(ai_risk_management_score), 2) AS avg_risk_management_score,
    ROUND(AVG(ai_adoption_rate), 2) AS avg_adoption_rate,
    ROUND(AVG(ai_maturity_score), 3) AS avg_ai_maturity,
    ROUND(AVG(productivity_change_percent), 2) AS avg_productivity_change
FROM ai_company_adoption
GROUP BY
    data_privacy_level,
    ai_ethics_committee
ORDER BY
    avg_adoption_rate DESC;
    
    
SHOW FULL TABLES
WHERE Table_type = 'VIEW';

SELECT * FROM vw_ai_overall_kpis;
SELECT * FROM vw_ai_yearly_trend;
SELECT * FROM vw_ai_industry_analysis;
SELECT * FROM vw_ai_adoption_investment_outcomes;
SELECT * FROM vw_ai_company_size_analysis;
SELECT * FROM vw_ai_workforce_impact;
SELECT * FROM vw_ai_country_analysis;