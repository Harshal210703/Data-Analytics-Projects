-- Calculate the number of stations per line
WITH StationsPerLine AS (
    SELECT Line, COUNT(*) AS NumberOfStations
    FROM PortfolioProject.dbo.[Delhi-Metro-Network] 
    GROUP BY Line
)

-- Calculate the total distance per line (max distance from start)
, TotalDistancePerLine AS (
    SELECT Line, MAX([Distance from Start (km)]) AS TotalDistance
    FROM PortfolioProject.dbo.[Delhi-Metro-Network] 
    GROUP BY Line
)

-- Calculate the average distance between stations per line
, AvgDistancePerLine AS (
    SELECT sl.Line, sl.NumberOfStations,
           td.TotalDistance / NULLIF(sl.NumberOfStations - 1, 0) AS AvgDistanceBetweenStations
    FROM StationsPerLine sl
    JOIN TotalDistancePerLine td ON sl.Line = td.Line
)


-- Distribution of Delhi Metro Station Layouts
SELECT [Station Layout], COUNT(*) AS NumberOfStations
FROM PortfolioProject.dbo.[Delhi-Metro-Network]
GROUP BY [Station Layout]
ORDER BY NumberOfStations DESC;
