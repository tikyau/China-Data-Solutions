CREATE TABLE [dbo].[Diffusion_prob](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[kol_uid] [nvarchar](50) NULL,
	[user_followers_count] [int] NOT NULL,
	[user_statuses_count] [int] NOT NULL,
	[user_gender] [nvarchar](50) NULL,
	[user_province] [nvarchar](50) NULL,
	[user_verified] [nvarchar](10) NULL,
	[value] [float] NULL,
 CONSTRAINT [PK_diffusion_prob] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)


CREATE TABLE [dbo].[KOL_pagerank](
	[uid] [nvarchar](50) NOT NULL,
	[value] [float] NULL,
 CONSTRAINT [PK_KOL_pagerank] PRIMARY KEY CLUSTERED 
(
	[uid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)


CREATE TABLE [dbo].[Weibo_detailed](
	[id] [bigint] NULL,
	[bmiddle_pic] [nvarchar](4000) NULL,
	[channel_types] [bigint] NULL,
	[comments_count] [bigint] NULL,
	[content] [nvarchar](4000) NULL,
	[created_at] [datetime] NULL,
	[gather_time] [datetime] NULL,
	[md5] [nvarchar](4000) NULL,
	[mid] [nvarchar](50) NOT NULL,
	[music_url] [nvarchar](4000) NULL,
	[original_pic] [nvarchar](4000) NULL,
	[reposts_count] [bigint] NULL,
	[retweeted_bmiddle_pic] [nvarchar](4000) NULL,
	[retweeted_comments_count] [bigint] NULL,
	[retweeted_created_at] [datetime] NULL,
	[retweeted_mid] [nvarchar](50) NULL,
	[retweeted_music_url] [nvarchar](4000) NULL,
	[retweeted_name] [nvarchar](4000) NULL,
	[retweeted_original_pic] [nvarchar](4000) NULL,
	[retweeted_reposts_count] [bigint] NULL,
	[retweeted_screen_name] [nvarchar](4000) NULL,
	[retweeted_source] [nvarchar](4000) NULL,
	[retweeted_text] [nvarchar](4000) NULL,
	[retweeted_thumbnail_pic] [nvarchar](4000) NULL,
	[retweeted_uid] [nvarchar](50) NULL,
	[retweeted_url] [nvarchar](4000) NULL,
	[retweeted_video_picurl] [nvarchar](4000) NULL,
	[retweeted_video_playerurl] [nvarchar](4000) NULL,
	[retweeted_video_realurl] [nvarchar](4000) NULL,
	[source] [nvarchar](4000) NULL,
	[status] [nvarchar](4000) NULL,
	[thumbnail_pic] [nvarchar](4000) NULL,
	[url] [nvarchar](4000) NULL,
	[user_uid] [nvarchar](50) NULL,
	[video_picurl] [nvarchar](4000) NULL,
	[video_playerurl] [nvarchar](4000) NULL,
	[video_realurl] [nvarchar](4000) NULL,
	[wtype] [bigint] NULL,
	[Processed] [bit] NULL,
 CONSTRAINT [PK_weibo_detailed] PRIMARY KEY CLUSTERED 
(
	[mid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)


CREATE TABLE [dbo].[Weibo_user_detailed](
	[user_uid] [nvarchar](50) NOT NULL,
	[user_followers_count] [int] NULL,
	[user_friends_count] [int] NULL,
	[user_statuses_count] [int] NULL,
	[user_gender] [nvarchar](50) NULL,
	[user_province] [nvarchar](50) NULL,
	[user_city] [nvarchar](50) NULL,
	[user_verified] [nvarchar](10) NULL,
 CONSTRAINT [PK_weibo_user_detailed] PRIMARY KEY CLUSTERED 
(
	[user_uid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)




exec('create view [dbo].[v_DailyHotTopic5] as 
 SELECT Top 5  case when [retweeted_mid] is null  then ''-1'' else  [retweeted_mid] END as [retweeted_mid] , count(1) as count  
 FROM 
	( select *, CONVERT(VARCHAR(10),created_at,120) as created_at_date,CONVERT(VARCHAR(13),created_at,120)+'':00'' as created_at_hour 
	  from [dbo].[weibo_detailed]  ) temp 
 WHERE created_at_hour >''2016-12-13 10:00'' and created_at_hour <=''2016-12-14 10:00''   and [retweeted_mid] <>''-1''
 GROUP BY [retweeted_mid],[retweeted_text],retweeted_uid, retweeted_name 
 ORDER BY  count desc');



exec('create view [dbo].[v_DailyHotTopic_Followers] as 
SELECT created_at_hour,a.[retweeted_mid],sum(user_followers_count) as  user_followers_count
FROM (select *,CONVERT(VARCHAR(10),created_at,120) as created_at_date, CONVERT(VARCHAR(13),created_at,120)+'':00'' as created_at_hour
      from weibo_detailed) a
	  ,v_DailyHotTopic5 c, Weibo_user_detailed d
WHERE  a.retweeted_mid= c.retweeted_mid  and created_at_hour <=''2016-12-14 10:00''and a.user_uid=d.user_uid
GROUP BY created_at_hour,a.[retweeted_mid]');



exec('create view [dbo].[v_SocialNetwork] as 
SELECT user_uid as[id_to]
      ,retweeted_uid as [id_from]
      ,1 as [weight]
      ,''#8ec9ff'' as [to_color]
      ,''#1436b4'' as [from_color]
      ,[mid]
  FROM [dbo].Weibo_detailed where retweeted_uid is not null');
