/*

The provided dataset contains detailed information about the Delhi Metro network, one of the largest and busiest urban transit systems in the world. Key features of the dataset include:

Station Information: Names and IDs of metro stations.
Geographical Coordinates: Latitude and longitude of each station.
Line Information: The specific metro line each station belongs to.
Distance Data: The distance of each station from the start of its line.
Station Layout: Type of station layout (e.g., Elevated, Underground, At-Grade).
Opening Date: Date of inauguration of each station.

*/


Select *
From PortfolioProject.dbo.[Delhi-Metro-Network]

-- Standardize Date Format
SELECT [Opening Date], CONVERT(Date, [Opening Date]) AS StandardizedDate
FROM PortfolioProject.dbo.[Delhi-Metro-Network];

ALTER TABLE PortfolioProject.dbo.[Delhi-Metro-Network]
Add [Opening Date Converted] Date;

Update PortfolioProject.dbo.[Delhi-Metro-Network]
SET [Opening Date Converted] = CONVERT(Date,[Opening Date])



-- Checking for Missing Values (NULLs)
Select *
From PortfolioProject.dbo.[Delhi-Metro-Network]
Where [Station ID] IS NULL OR [Station Name] IS NULL OR [Distance from Start (km)] IS NULL OR Line IS NULL OR [Station Layout] IS NULL OR Latitude IS NULL OR Longitude IS NULL OR [Opening Date Converted] IS NULL



-- Check for duplicate values across all columns
SELECT t1.*
FROM PortfolioProject.dbo.[Delhi-Metro-Network] AS t1
INNER JOIN (
    SELECT [Station ID], [Station Name], [Distance from Start (km)], Line, [Station Layout], Latitude, Longitude, [Opening Date Converted]
    FROM PortfolioProject.dbo.[Delhi-Metro-Network]
    GROUP BY [Station ID], [Station Name], [Distance from Start (km)], Line, [Station Layout], Latitude, Longitude, [Opening Date Converted]
    HAVING COUNT(*) > 1
) AS t2 ON 
    t1.[Station ID] = t2.[Station ID]
    AND t1.[Station Name] = t2.[Station Name]
    AND t1.[Distance from Start (km)] = t2.[Distance from Start (km)]
    AND t1.Line = t2.Line
    AND t1.[Station Layout] = t2.[Station Layout]
    AND t1.Latitude = t2.Latitude
    AND t1.Longitude = t2.Longitude
    AND t1.[Opening Date Converted] = t2.[Opening Date Converted]
    AND t1.[Station ID] <> t2.[Station ID] 