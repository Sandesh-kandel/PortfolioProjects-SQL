SELECT *
FROM PortfolioProject.dbo.Shark_Tank

SELECT max( distinct[Ep# No#])
FROM PortfolioProject.dbo.Shark_Tank

--pitches
SELECT count (Distinct Brand)
FROM PortfolioProject.dbo.Shark_Tank


--who got fubdign
SELECT
    COUNT(CASE WHEN [Amount_Invested_lakhs] > 0 THEN 1 END) AS companies_with_investment,
    COUNT(CASE WHEN [Amount_Invested_lakhs] = 0 THEN 1 END) AS companies_without_investment,
	COUNT(CASE WHEN [Amount_Invested_lakhs] > 0 THEN 1 END) * 100.0 / COUNT(*) AS percentage_with_investment,
    COUNT(CASE WHEN [Amount_Invested_lakhs] = 0 THEN 1 END) * 100.0 / COUNT(*) AS percentage_without_investment
FROM PortfolioProject.dbo.Shark_Tank;


--IN percentges
Select
	COUNT(CASE WHEN [Amount_Invested_lakhs] > 0 THEN 1 END) * 100.0 / COUNT(*) AS percentage_with_investment,
    COUNT(CASE WHEN [Amount_Invested_lakhs] = 0 THEN 1 END) * 100.0 / COUNT(*) AS percentage_without_investment
FROM PortfolioProject.dbo.Shark_Tank;

--total male and female

select sum(Male)
FROM PortfolioProject.dbo.Shark_Tank;

select sum(Female)
FROM PortfolioProject.dbo.Shark_Tank;


--gender ratio

select sum(Female)/ sum(Male)
FROM PortfolioProject.dbo.Shark_Tank;


--average equity taken by sharks

SELECT avg([Equity Taken %]) as average_equity_taken
FROM PortfolioProject.dbo.Shark_Tank 
WHERE [Equity Taken %]>0;

--highest equity and highest amount invested

SELECT max(Amount_Invested_lakhs)
FROM PortfolioProject.dbo.Shark_Tank

SELECT max([Equity Taken %])
FROM PortfolioProject.dbo.Shark_Tank

--at least one women

select sum(a.total_female) From(
SELECT Female , case when Female>0 then 1 else 0 end as total_female
FROM PortfolioProject.dbo.Shark_Tank ) a 

--total female =52

--total male
select sum(a.total_male) From(
SELECT Male , case when Male>0 then 1 else 0 end as total_male
FROM PortfolioProject.dbo.Shark_Tank ) a 



--pitches which got converted where at least there is one womeen

select * from PortfolioProject.dbo.Shark_Tank


select sum(b.female_count) from(

select case when a.female>0 then 1 else 0 end as female_count ,a.*from (
(select * from  PortfolioProject.dbo.Shark_Tank where deal!='No Deal')) a)b



--average amount invested per deal


select avg(a.Amount_Invested_lakhs ) amount_invested_per_deal from
(select * from PortfolioProject.dbo.Shark_Tank where deal!='No Deal') a



-- avg age group of contestants

select [Avg age] ,count([Avg age]) count_age
from PortfolioProject.dbo.Shark_Tank
group by [Avg age] order by count_age desc


-- location group of contestants

select location,count(location)count_locatiokn
from PortfolioProject.dbo.Shark_Tank
group by location 
order by count_locatiokn desc


-- sector group of contestants

select Sector,count(sector) cnt
from PortfolioProject.dbo.Shark_Tank
group by sector order by cnt desc


--partner deals

select partners,count(partners) cnt
from PortfolioProject.dbo.Shark_Tank  where partners!='-' 
group by partners order by cnt desc


-- making the matrix

-- Count of non-null 'Ashneer' amount invested
SELECT 'Ashneer' as keyy, COUNT([Ashneer Amount Invested]) as total_deals_present
FROM PortfolioProject.dbo.Shark_Tank
WHERE [Ashneer Amount Invested] IS NOT NULL;

-- Count of non-zero 'Ashneer' amount invested
SELECT 'Ashneer' as keyy, COUNT([Ashneer Amount Invested]) as total_deals
FROM PortfolioProject.dbo.Shark_Tank
WHERE [Ashneer Amount Invested] IS NOT NULL AND [Ashneer Amount Invested] != 0;

-- Sum and average of 'Ashneer' amount invested and equity taken percentage
SELECT 'Ashneer' as keyy, SUM([Ashneer Amount Invested]) as total_amount_invested, AVG( [Ashneer Equity Taken %]) as avg_equity_taken
FROM PortfolioProject.dbo.Shark_Tank
WHERE [Ashneer Equity Taken %] != 0 AND [Ashneer Equity Taken %] IS NOT NULL;

-- Combining the results into a single table
SELECT m.keyy, m.total_deals_present, m.total_deals, n.total_amount_invested, n.avg_equity_taken
FROM
(
    SELECT a.keyy, a.total_deals_present, b.total_deals
    FROM
    (
        SELECT 'Ashneer' as keyy, COUNT([Ashneer Amount Invested]) as total_deals_present
        FROM PortfolioProject.dbo.Shark_Tank
        WHERE [Ashneer Amount Invested] IS NOT NULL
    ) a
    INNER JOIN
    (
        SELECT 'Ashneer' as keyy, COUNT([Ashneer Amount Invested]) as total_deals
        FROM PortfolioProject.dbo.Shark_Tank
        WHERE [Ashneer Amount Invested] IS NOT NULL AND [Ashneer Amount Invested] != 0
    ) b
    ON a.keyy = b.keyy
) m
INNER JOIN
(
    SELECT 'Ashneer' as keyy, SUM([Ashneer Amount Invested]) as total_amount_invested, AVG([Ashneer Equity Taken %]) as avg_equity_taken
    FROM PortfolioProject.dbo.Shark_Tank
    WHERE [Ashneer Equity Taken %] != 0 AND [Ashneer Equity Taken %] IS NOT NULL
) n
ON m.keyy = n.keyy;





--most  important

-- which is the startup in which the highest amount has been invested in each domain/sector


SELECT Sector, MAX(Amount_Invested_lakhs) AS Max_Investment
FROM PortfolioProject.dbo.Shark_Tank
GROUP BY Sector
ORDER BY Max_Investment DESC;

