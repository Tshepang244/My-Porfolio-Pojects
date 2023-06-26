SELECT TOP 1 CustomerId
FROM (
    SELECT CustomerId, COUNT(*) AS OrderCount
    FROM [Data Analyst Take Home Test].[dbo].[TakeHomeTest]
    WHERE [Date] >= '2021-01-15' AND [Date] <= '2021-06-15'
    GROUP BY CustomerId
    ORDER BY OrderCount DESC
    OFFSET 3 ROWS FETCH NEXT 1 ROW ONLY
) AS subquery;


SELECT ROUND(AVG(OrderCount), 3) AS AverageOrders
FROM (
    SELECT CustomerId, COUNT(*) AS OrderCount
    FROM [Data Analyst Take Home Test].[dbo].[TakeHomeTest]
    WHERE [Date] >= '2021-01-15' AND [Date] <= '2021-06-15'
    GROUP BY CustomerId
) AS subquery;


SELECT COUNT(*) AS CustomerCount
FROM (
    SELECT CustomerId, COUNT(*) AS OrderCount
    FROM [Data Analyst Take Home Test].[dbo].[TakeHomeTest]
    WHERE [Date] >= '2021-01-15' AND [Date] <= '2021-06-15'
    GROUP BY CustomerId
) AS subquery
WHERE OrderCount = 1;


SELECT ROUND(AVG(DaysBetween), 3) AS AverageDaysBetween
FROM (
    SELECT CustomerId, DATEDIFF(day, MIN([Date]), MAX([Date])) AS DaysBetween
    FROM [Data Analyst Take Home Test].[dbo].[TakeHomeTest]
    WHERE CustomerId IN (
        SELECT CustomerId
        FROM [Data Analyst Take Home Test].[dbo].[TakeHomeTest]
        WHERE [Date] >= '2021-01-15' AND [Date] <= '2021-06-15'
        GROUP BY CustomerId
        HAVING COUNT(*) >= 3
    )
    GROUP BY CustomerId
) AS subquery;

SELECT COUNT(*) AS CustomerCount
FROM (
    SELECT CustomerId, COUNT(*) AS OrderCount
    FROM [Data Analyst Take Home Test].[dbo].[TakeHomeTest]
    WHERE [Date] >= '2021-01-15' AND [Date] <= '2021-06-15'
    GROUP BY CustomerId
    HAVING COUNT(*) > 8
) AS subquery;




SELECT ROUND(AVG(DaysBetween), 3) AS AverageDaysBetween
FROM (
SELECT CustomerId, DATEDIFF(day, [ThirdOrderDate], [EighthOrderDate]) AS DaysBetween
 FROM (
SELECT CustomerId,
MIN(CASE WHEN OrderRank = 3 THEN [Date] END) AS [ThirdOrderDate],
MIN(CASE WHEN OrderRank = 8 THEN [Date] END) AS [EighthOrderDate]
FROM (
SELECT CustomerId, [Date],
ROW_NUMBER() OVER (PARTITION BY CustomerId ORDER BY [Date]) AS OrderRank
FROM [Data Analyst Take Home Test].[dbo].[TakeHomeTest]
WHERE CustomerId IN (
SELECT CustomerId
FROM [Data Analyst Take Home Test].[dbo].[TakeHomeTest]
WHERE [Date] >= '2021-01-15' AND [Date] <= '2021-06-15'
GROUP BY CustomerId
HAVING COUNT(*) >= 8
)
        ) AS subquery
        WHERE OrderRank = 3 OR OrderRank = 8
        GROUP BY CustomerId
        HAVING COUNT(*) = 2
    ) AS subquery
) AS subquery;

SELECT TOP 1 [Date]
FROM (
    SELECT [Date], ROW_NUMBER() OVER (ORDER BY OrderCount DESC) AS OrderRank
    FROM (
        SELECT [Date], COUNT(*) AS OrderCount
        FROM [Data Analyst Take Home Test].[dbo].[TakeHomeTest]
        GROUP BY [Date]
    ) AS subquery
) AS subquery
WHERE OrderRank = 7
ORDER BY [Date];


SELECT TOP 1 RestaurantId, COUNT(*) AS OrderCount
FROM [Data Analyst Take Home Test].[dbo].[TakeHomeTest]
WHERE [Date] >= '2021-06-01' AND [Date] <= '2021-06-30'
GROUP BY RestaurantId
ORDER BY OrderCount DESC;



SELECT
    CASE
        WHEN DATEPART(dw, [Date]) IN (2, 3, 4, 5) THEN 'Weekdays'
        ELSE 'Weekends'
    END AS Period,
    COUNT(*) AS OrderCount
FROM [Data Analyst Take Home Test].[dbo].[TakeHomeTest]
WHERE [Date] >= '2021-01-15' AND [Date] <= '2021-06-15'
GROUP BY
    CASE
        WHEN DATEPART(dw, [Date]) IN (2, 3, 4, 5) THEN 'Weekdays'
        ELSE 'Weekends'
    END;

	SELECT
    YEAR([Date]) AS Year,
    MONTH([Date]) AS Month,
    COUNT(DISTINCT [RestaurantId]) AS RestaurantsWithOrders
FROM [Data Analyst Take Home Test].[dbo].[TakeHomeTest]
WHERE [Date] >= '2021-01-15' AND [Date] <= '2021-06-15'
GROUP BY YEAR([Date]), MONTH([Date])
ORDER BY YEAR([Date]), MONTH([Date]);

SELECT
    ((restaurants_mar - restaurants_feb) / CAST(restaurants_feb AS DECIMAL(10, 2))) * 100 AS PercentageDifference
FROM
    (SELECT
        COUNT(DISTINCT RestaurantId) AS restaurants_feb
    FROM
        [Data Analyst Take Home Test].[dbo].[TakeHomeTest]
    WHERE
        MONTH(Date) = 2
        AND YEAR(Date) = 2021) AS feb_count,
    (SELECT
        COUNT(DISTINCT RestaurantId) AS restaurants_mar
    FROM
        [Data Analyst Take Home Test].[dbo].[TakeHomeTest]
    WHERE
        MONTH(Date) = 3
        AND YEAR(Date) = 2021) AS mar_count;


