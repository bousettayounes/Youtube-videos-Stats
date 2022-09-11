Create proc ALLComments 
as begin 
Select * from comments
end 

Create proc ALLvideos
as begin 
Select * from [videos-stats]
end 


Exec ALLComments
Exec ALLvideos

--Loading Data--

--Removing unwanted columns  from both tables 

ALTER TABLE comments
DROP COLUMN F1;
ALTER TABLE [videos-stats]
DROP COLUMN F1;

--Renaming columns From [Like: Video likes ] ,[Like, comment likes]

EXEC sp_rename 'YTB.dbo.comments.Comment Like', 'Comment Likes', 'COLUMN';
EXEC sp_rename 'YTB.dbo.videos-stats.Likes', 'Video Likes', 'COLUMN';

--Exploring Data--

		-------------Video-Stats-------------
Select *
From INFORMATION_SCHEMA.COLUMNS

--Loking for null values
			------ Comment Null values ----
With Cte_NullCheckComments as (
Select SUM ( case when [video ID] is null then 1 else 0 end ) count_nulls, COUNT ([video ID]) non_null_values
From comments 
Union all
Select  SUM ( case when [Comment] is null then 1 else 0 end ) count_nulls, COUNT ([Comment]) non_null_values
From comments --contains 1 null value 
Union all
Select SUM ( case when [Comment Likes] is null then 1 else 0 end ) count_nulls, COUNT ([Comment Likes]) non_null_values
From comments 
Union all
Select SUM ( case when [Sentiment] is null then 1 else 0 end ) count_nulls, COUNT ([Sentiment]) non_null_values
From comments 
)
select * from Cte_NullCheckComments

			------ Video-stats Null values ----
With Cte_NullCheckVideostats as (
Select SUM ( case when [video ID] is null then 1 else 0 end ) count_nulls, COUNT ([video ID]) non_null_values
From [videos-stats] 
Union all
Select SUM ( case when [Title] is null then 1 else 0 end ) count_nulls, COUNT ([Title]) non_null_values
From [videos-stats] 
Union all
Select SUM ( case when [Published At] is null then 1 else 0 end ) count_nulls, COUNT ([Published At]) non_null_values
From [videos-stats] 
Union all
Select SUM ( case when Keyword is null then 1 else 0 end ) count_nulls, COUNT (Keyword) non_null_values
From [videos-stats] 
Union all
Select SUM ( case when [video Likes] is null then 1 else 0 end ) count_nulls, COUNT ([video Likes]) non_null_values
From [videos-stats] -- contien 2 null values 
Union all
Select SUM ( case when Comments is null then 1 else 0 end ) count_nulls, COUNT (Comments) non_null_values
From [videos-stats] -- contien 2 null values 
Union all
Select SUM ( case when Views is null then 1 else 0 end ) count_nulls, COUNT (Views) non_null_values
From [videos-stats] -- contien 2 null values 
)Select * from Cte_NullCheckVideostats


Exec ALLComments
Exec ALLvideos

--- Count Of numerical value

Select COUNT (comments) Count_Comments	From [videos-stats] 

Select COUNT ([Video Likes]) Count_of_Video_Likes From [videos-stats]

Select COUNT (Views) Count_Views 	From [videos-stats]

--- MIN Of numerical value
Select MIN (comments) Min_count_of_comment	From [videos-stats]

Select MIN ([Video Likes]) Min_count_of_VideoLikes	From [videos-stats]

Select MIN (Views) Min_count_of_Views	From [videos-stats]

--- MAX Of numerical value

Select MAX (comments) MAX_count_of_Comment	From [videos-stats]

Select MAX ([Video Likes]) MAX_count_of_Video_likes	From [videos-stats]

Select MAX (Views) MAX_count_of_View	From [videos-stats]

--- AVG Of numerical value


Select AVG (comments) average_number_of_comments	From [videos-stats]

Select AVG ([Video Likes]) average_number_of_Video_Likes	From [videos-stats]

Select AVG (Views) average_number_of_Views	From [videos-stats]

--- Standare diviation Of numerical value

Select STDEV (comments) STDEV_of_comments	From [videos-stats]
Select STDEV ([Video Likes]) STDEV_of_Video_Likes	From [videos-stats]
Select STDEV (Views) STDEV_of_Views	From [videos-stats]


exec ALLvideos


--- Count Of numerical value

Select COUNT ([comment Likes]) Count_Comment_Likes	From [comments] 

Select COUNT ([Sentiment]) Count_Sentiment	From [comments] 

--- MIN Of numerical value
Select MIN ([comment Likes]) Min_Count_Comment_Likes	From [comments] 

Select MIN ([Sentiment]) Min_Sentiment	From [comments] 



--- MAX Of numerical value

Select MAX ([comment Likes]) Max_Count_Comment_Likes	From [comments] 

Select MAX ([Sentiment]) Max_Sentiment	From [comments] 


--- AVG Of numerical value


Select AVG ([comment Likes]) AVG_Comment_Likes	From [comments] 

Select AVG ([Sentiment]) AVG_Sentiment	From [comments] 


--- Standare diviation Of numerical value

Select STDEV ([comment Likes]) STDEV_Comment_Likes	From [comments] 

Select STDEV ([Sentiment]) STDEV_Sentiment	From [comments] 


-----------Dropping Missing Values----------

alter VIEW [Comments Stats] AS
SELECT *
FROM Comments
WHERE [Comment] is not null

Select * from [Comments Stats]

alter VIEW [Video Stats] AS

SELECT * FROM [videos-stats] 
WHERE NOT ([video Likes] IS NULL and
Comments IS NULL and
 [Views] IS NULL 
)


Select * from [Video Stats] where [Video Likes] is null

delete from [Video Stats] where [Video Likes] is null

alter View Full_data 
as 
Select v.[Video ID],v.Title,year(v.[Published At]) [Published Year],v.Keyword,v.Views,v.[Video Likes],v.Comments,c.Comment,c.[Comment Likes],c.Sentiment
from [Video Stats] v
inner join [Comments Stats] c
on v.[Video ID]=c.[Video ID]


Select * from Full_data


---Keywords most used
Select Keyword, COUNT(Keyword) Count
From Full_data
Group by Keyword
order by COUNT(Keyword) desc 


-- number of comment by Vid id and title 
Select [Video ID],Title,COUNT(comment) Comments_number
from Full_data
group by [Video ID],[Title]
order by Count(comment) desc

-- number of videos published in year 

Select [published Year] , COUNT ([Video ID])number_of_videos
From full_data
group by [published Year] 
order by COUNT ([Video ID]) desc

-- Videos with keywords arranged by maximum, minimum, average and total views

Select keyword,Sum(Views) Sum ,MIN(Views) Min , MAX(Views) max ,round(AVG(views),2) average
From full_data
group by  keyword
order by Sum(views) desc

-- Average Number of views for each Keyword

Select keyword, AVG(Views) average_view
From Full_Data
group by keyword
order by AVG(Views)desc


-- Top 10 most viewed Videos in all Years 

Select distinct(Title),[Published Year],Views
From Full_Data
order by Views desc

-- Top 10 most Liked Videos in all Years 
Select distinct(Title),[Published Year],[Video Likes]
From Full_Data
order by [Video Likes] desc

-- Top 10 most discussed Videos (Most Comments)

Select distinct title,comments
from Full_data
order by comments desc

-- Data Science and Machine Learning Videos


Select  distinct(title), [video id] ,Views,[Video Likes],Keyword ,comments
from Full_data
where Keyword like '%data science%' or Title like '%machine learning%'

-- Data Science and Machine Learning Videos Count 

Select [published year] ,COUNT ( Keyword ) [ML & DS Videos]
from Full_data
where Keyword like '%data science%' or Title like '%machine learning%'
Group by [published year]

-- Top 10 most Viewed Data Videos Category 

Select Keyword ,Sum ( [Views] ) Totalview
from Full_data
where Keyword like '%data science%' or Title like '%machine learning%'
Group by Keyword

-- Top 10 most Viewed Data Videos  
Select distinct Title ,Sum ( [Views] ) Totalview
from Full_data
where Keyword like '%data science%' or Title like '%machine learning%'
Group by Title
order by Sum ( [Views] ) desc


-- Top 10 Most Comments Videos DS & ML 

Select distinct title,comments
from Full_data
where Keyword like '%data science%' or Title like '%machine learning%'
order by comments desc

-- Top 10 most Liked Data Videos
Select distinct title,[Video Likes]
from Full_data
where Keyword like '%data science%' or Title like '%machine learning%'
order by [Video Likes] desc

-- Merging video-stats and comments dataframes to get the Title column


select Title,Keyword,round(AVG(sentiment),2) average
from Full_data
group by Title,Keyword
order by round(AVG(sentiment),2) desc

select * from Full_data 



