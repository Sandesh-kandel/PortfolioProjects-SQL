
SELECT *
FROM nba_players

-- (1) Player Performance Analysis:
--Retrieve the top 10 players with the highest Points Per Game (PTS)

SELECT TOP 10 Player, PTS
FROM nba_players
ORDER BY PTS DESC

--Find the players with the highest field goal percentage (FG%) and three-point percentage (3P%) for each position:

SELECT Pos, Player, FG, _3P
FROM nba_players
WHERE FG = (SELECT MAX(FG) FROM nba_players WHERE Pos = nba_players.Pos)
   OR _3P = (SELECT MAX(_3P) FROM nba_players WHERE Pos = nba_players.Pos);


--Identify the players with the most rebounds per game (TRB) and assists per game (AST) for each position:

SELECT Pos, Player, TRB, AST
FROM nba_players
WHERE TRB = (SELECT MAX(TRB) FROM nba_players WHERE Pos = nba_players.Pos)
   OR AST = (SELECT MAX(AST) FROM nba_players WHERE Pos = nba_players.Pos);


--Calculate the overall efficiency rating for each player by considering a combination
--of statistics like points, rebounds, assists, steals, and blocks:

SELECT Player, (PTS + TRB + AST + STL + BLK) AS Efficiency
FROM nba_players
ORDER BY Efficiency DESC;


--Determine the team with the highest average points per game (PTS) and the lowest average turnovers per game (TOV):

SELECT TOP 1 Tm, AVG(PTS) AS AvgPoints, AVG(TOV) AS AvgTurnovers
FROM nba_players
GROUP BY Tm
ORDER BY AvgPoints DESC, AvgTurnovers ASC


-- To calculate the average field goal percentage (FG%) and three-point percentage (3P%) for each team:

SELECT Tm, AVG(FG) AS AvgFGPercentage, AVG(_3P) AS Avg3PPercentage
FROM nba_players
GROUP BY Tm;


--Identify the team with the most blocks per game (BLK) and steals per game (STL):

SELECT Tm, MAX(BLK) AS MaxBlocks, MAX(STL) AS MaxSteals
FROM nba_players
GROUP BY Tm;


--Compare the average statistics (points, rebounds, assists, etc.) 
--for different positions and identify any significant differences:

SELECT Pos, AVG(PTS) AS AvgPoints, AVG(TRB) AS AvgRebounds, AVG(AST) AS AvgAssists
FROM nba_players
GROUP BY Pos;


--Calculate the average player efficiency rating for each position and analyze the variations

SELECT Pos, AVG(PTS + TRB + AST + STL + BLK) AS AvgEfficiency
FROM nba_players
GROUP BY Pos;


--Analyze the improvement in performance (e.g., points, shooting percentage) of players over the course of the season:

WITH player_stats AS (
   SELECT Player, PTS, FG, LAG(PTS) OVER (PARTITION BY Player ORDER BY Rk) AS PTS_prev, LAG(FG) OVER (PARTITION BY Player ORDER BY Rk) AS FG_prev
   FROM nba_players
)
SELECT player, (PTS - PTS_prev) AS PointsImprovement, (FG - FG_prev) AS FGPercentageImprovement
FROM player_stats
WHERE (PTS - PTS_prev) > 0 OR (FG - FG_prev) > 0;


-- Identify players who have shown the most significant improvement in specific statistical categories:
WITH player_stats AS (
   SELECT Player, PTS, TRB, AST, LAG(PTS) OVER (PARTITION BY Player ORDER BY Rk) AS PTS_prev, LAG(TRB) OVER (PARTITION BY Player ORDER BY Rk) AS TRB_prev, LAG(AST) OVER (PARTITION BY Player ORDER BY Rk) AS AST_prev
   FROM nba_players
)
SELECT Player, (PTS - PTS_prev) AS PointsImprovement, (TRB - TRB_prev) AS ReboundsImprovement, (AST - AST_prev) AS AssistsImprovement
FROM player_stats
WHERE PTS_prev IS NOT NULL AND TRB_prev IS NOT NULL AND AST_prev IS NOT NULL
  AND PTS IS NOT NULL AND TRB IS NOT NULL AND AST IS NOT NULL
  AND (PTS - PTS_prev) > 0 AND (TRB - TRB_prev) > 0 AND (AST - AST_prev) > 0;


--Calculate the effective field goal percentage (eFG) for each player and compare it across positions:

SELECT POS,
       Player,
       CASE
           WHEN FGA = 0 THEN NULL  -- Return NULL if FGA is zero to avoid divide by zero error
           ELSE (FG + 0.5 * _3P) / FGA
       END AS eFGPercentage
FROM nba_players;



--Use advanced metrics like Player Efficiency Rating (PER) or Box Plus/Minus (BPM) to evaluate player performance and rank them:

SELECT TOP 100 Player, 
       CASE WHEN FGA = 0 THEN 0 ELSE (FG + 0.5*_3P) / FGA END as eFG, 
       (PTS + TRB + AST + STL + BLK - TOV) as Player_Efficiency_Rating, 
       CASE WHEN (MP/48) = 0 THEN 0 ELSE (PTS + TRB + AST + STL + BLK - TOV) / (MP/48) END as Box_Plus_Minus
FROM nba_players
ORDER BY Player_Efficiency_Rating DESC, Box_Plus_Minus DESC;



















