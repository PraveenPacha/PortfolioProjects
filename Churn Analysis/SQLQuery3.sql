
--Data Exploration 
select gender, count(Gender) as TotalCount,
count(Gender) *100.0/ (select count(*) from stg_churn) as Percentage
from stg_churn
group by Gender

select Contract, count(Contract) as TotalCount,
count(Contract) *100.0/ (select count(*) from stg_churn) as Percentage
from stg_churn
group by Contract

select Customer_Status, count(Customer_Status) as TotalCount, sum(Total_Revenue) as TotalRev,
sum(Total_Revenue)/ (select sum(Total_Revenue) from stg_churn) * 100 as RevPercentage
from stg_churn
group by Customer_Status

select state, count(state) as TotalCount,
count(state) * 100.0 / (select count(*) from stg_churn) as Percentage
from stg_churn
group by State
order by Percentage desc

select distinct Internet_Type
from stg_churn


--Remove null values and place in new table

SELECT 
    Customer_ID,
    Gender,
    Age,
    Married,
    State,
    Number_of_Referrals,
    Tenure_in_Months,
    ISNULL(Value_Deal, 'None') AS Value_Deal,
    Phone_Service,
    ISNULL(Multiple_Lines, 'No') As Multiple_Lines,
    Internet_Service,
    ISNULL(Internet_Type, 'None') AS Internet_Type,
    ISNULL(Online_Security, 'No') AS Online_Security,
    ISNULL(Online_Backup, 'No') AS Online_Backup,
    ISNULL(Device_Protection_Plan, 'No') AS Device_Protection_Plan,
    ISNULL(Premium_Support, 'No') AS Premium_Support,
    ISNULL(Streaming_TV, 'No') AS Streaming_TV,
    ISNULL(Streaming_Movies, 'No') AS Streaming_Movies,
    ISNULL(Streaming_Music, 'No') AS Streaming_Music,
    ISNULL(Unlimited_Data, 'No') AS Unlimited_Data,
    Contract,
    Paperless_Billing,
    Payment_Method,
    Monthly_Charge,
    Total_Charges,
    Total_Refunds,
    Total_Extra_Data_Charges,
    Total_Long_Distance_Charges,
    Total_Revenue,
    Customer_Status,
    ISNULL(Churn_Category, 'Others') AS Churn_Category,
    ISNULL(Churn_Reason , 'Others') AS Churn_Reason

INTO [db_Churn].[dbo].[prod_Churn]
FROM [db_Churn].[dbo].[stg_Churn]


--Views for Power BI
Create View vw_ChurnData as 
select * from prod_Churn where Customer_Status In ('Churned', 'Stayed')

Create View vw_JoinData as
select * from prod_Churn where Customer_Status = 'Joined'