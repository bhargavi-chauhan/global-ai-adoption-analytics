USE ai_adoption_analysis;
-- AI Adoption ROI & Workforce Productivity Analysis

-- Q1 — Overall adoption metrics
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT company_id) AS total_companies,
    ROUND(AVG(ai_adoption_rate), 2) AS avg_adoption_rate,
    ROUND(AVG(ai_maturity_score), 3) AS avg_maturity_score,
    ROUND(AVG(productivity_change_percent), 2) AS avg_productivity_change,
    ROUND(AVG(ai_investment_per_employee), 2) AS avg_investment_per_employee
FROM ai_company_adoption;

-- Q2 — Adoption trend over time
SELECT
    survey_year,
    ROUND(AVG(ai_adoption_rate), 2) AS avg_adoption_rate,
    ROUND(AVG(ai_maturity_score), 3) AS avg_maturity_score,
    ROUND(AVG(productivity_change_percent), 2) AS avg_productivity_change
FROM ai_company_adoption
GROUP BY survey_year
ORDER BY survey_year;

-- Q3 — Industry comparison
SELECT
    industry,
    COUNT(*) AS observations,
    ROUND(AVG(ai_adoption_rate), 2) AS avg_adoption_rate,
    ROUND(AVG(ai_maturity_score), 3) AS avg_maturity,
    ROUND(AVG(productivity_change_percent), 2) AS avg_productivity_change,
    ROUND(AVG(revenue_growth_percent), 2) AS avg_revenue_growth,
    ROUND(AVG(cost_reduction_percent), 2) AS avg_cost_reduction
FROM ai_company_adoption
GROUP BY industry
ORDER BY avg_adoption_rate DESC;



-- Q5 — Startup vs SME vs Enterprise
SELECT
    company_size,
    COUNT(*) AS observations,
    ROUND(AVG(ai_adoption_rate), 2) AS avg_adoption_rate,
    ROUND(AVG(ai_investment_per_employee), 2) AS avg_investment_per_employee,
    ROUND(AVG(productivity_change_percent), 2) AS avg_productivity_change,
    ROUND(AVG(revenue_growth_percent), 2) AS avg_revenue_growth
FROM ai_company_adoption
GROUP BY company_size
ORDER BY avg_productivity_change DESC;

-- Q6 — Investment vs productivity
WITH investment_groups AS (
    SELECT
        *,
        NTILE(3) OVER (
            ORDER BY ai_investment_per_employee
        ) AS investment_tercile
    FROM ai_company_adoption
)

SELECT
    CASE
        WHEN investment_tercile = 1 THEN 'Low Investment'
        WHEN investment_tercile = 2 THEN 'Medium Investment'
        WHEN investment_tercile = 3 THEN 'High Investment'
    END AS investment_group,

    COUNT(*) AS observations,
    ROUND(AVG(ai_investment_per_employee), 2) AS avg_investment,
    ROUND(AVG(productivity_change_percent), 2) AS avg_productivity_change,
    ROUND(AVG(revenue_growth_percent), 2) AS avg_revenue_growth,
    ROUND(AVG(cost_reduction_percent), 2) AS avg_cost_reduction

FROM investment_groups

GROUP BY investment_tercile

ORDER BY investment_tercile;

-- Q7 — AI adoption vs productivity
WITH adoption_groups AS (
    SELECT
        *,
        NTILE(3) OVER (
            ORDER BY ai_adoption_rate
        ) AS adoption_tercile
    FROM ai_company_adoption
)

SELECT
    CASE
        WHEN adoption_tercile = 1 THEN 'Low Adoption'
        WHEN adoption_tercile = 2 THEN 'Medium Adoption'
        WHEN adoption_tercile = 3 THEN 'High Adoption'
    END AS adoption_group,

    COUNT(*) AS observations,
    ROUND(AVG(productivity_change_percent), 2) AS avg_productivity_change,
    ROUND(AVG(revenue_growth_percent), 2) AS avg_revenue_growth,
    ROUND(AVG(cost_reduction_percent), 2) AS avg_cost_reduction

FROM adoption_groups

GROUP BY adoption_tercile

ORDER BY adoption_tercile;


-- Q8 — Jobs created vs displaced
SELECT
    SUM(jobs_created) AS total_jobs_created,
    SUM(jobs_displaced) AS total_jobs_displaced,
    SUM(jobs_created) - SUM(jobs_displaced) AS net_jobs_impact,
    SUM(reskilled_employees) AS total_reskilled
FROM ai_company_adoption;

-- Q9 — Workforce impact by industry
SELECT
    industry,
    SUM(jobs_created) AS jobs_created,
    SUM(jobs_displaced) AS jobs_displaced,
    SUM(jobs_created) - SUM(jobs_displaced) AS net_jobs_impact,
    SUM(reskilled_employees) AS reskilled_employees
FROM ai_company_adoption
GROUP BY industry
ORDER BY net_jobs_impact DESC;

-- Q10 — Adoption stage and workforce impact
SELECT
    ai_adoption_stage,
    COUNT(*) AS observations,
    ROUND(AVG(productivity_change_percent), 2) AS avg_productivity_change,
    ROUND(AVG(jobs_created), 2) AS avg_jobs_created,
    ROUND(AVG(jobs_displaced), 2) AS avg_jobs_displaced,
    ROUND(AVG(reskilled_employees), 2) AS avg_reskilled
FROM ai_company_adoption
GROUP BY ai_adoption_stage
ORDER BY avg_productivity_change DESC;

-- Q11 — Country AI adoption
SELECT
    c.country,
    c.region,
    c.digital_maturity_index,
    c.internet_penetration,
    c.country_ai_policy,
    ROUND(AVG(a.ai_adoption_rate), 2) AS avg_company_adoption,
    ROUND(AVG(a.productivity_change_percent), 2) AS avg_productivity
FROM country_ai_index c
JOIN ai_company_adoption a
    ON c.country = a.country
GROUP BY
    c.country,
    c.region,
    c.digital_maturity_index,
    c.internet_penetration,
    c.country_ai_policy
ORDER BY avg_company_adoption DESC;


-- Q12 — Region comparison
SELECT
    a.region,
    COUNT(*) AS observations,
    ROUND(AVG(a.ai_adoption_rate), 2) AS avg_adoption_rate,
    ROUND(AVG(a.ai_maturity_score), 3) AS avg_maturity,
    ROUND(AVG(a.productivity_change_percent), 2) AS avg_productivity
FROM ai_company_adoption a
GROUP BY a.region
ORDER BY avg_adoption_rate DESC;



-- Q14 — Primary AI tool performance
SELECT
    ai_primary_tool,
    COUNT(*) AS observations,
    ROUND(AVG(ai_adoption_rate), 2) AS avg_adoption_rate,
    ROUND(AVG(productivity_change_percent), 2) AS avg_productivity_change,
    ROUND(AVG(time_saved_per_week), 2) AS avg_time_saved,
    ROUND(AVG(customer_satisfaction), 2) AS avg_customer_satisfaction
FROM ai_company_adoption
GROUP BY ai_primary_tool
ORDER BY avg_productivity_change DESC;

