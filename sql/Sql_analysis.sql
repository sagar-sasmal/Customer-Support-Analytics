CREATE TABLE support_tickets (
    ticket_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    customer_email VARCHAR(150),
    customer_age INT,
    customer_gender VARCHAR(20),
    product_purchased VARCHAR(100),
    date_of_purchase DATE,
    ticket_type VARCHAR(50),
    ticket_subject VARCHAR(255),
    ticket_description TEXT,
    ticket_status VARCHAR(50),
    resolution TEXT,
    ticket_priority VARCHAR(20),
    ticket_channel VARCHAR(50),
    first_response_time DATETIME NULL,
    time_to_resolution DATETIME NULL,
    customer_satisfaction_rating DECIMAL(3,1) NULL
);

Alter Table support_tickets
Add Column purchase_year Int,
Add Column purchase_month VARCHAR(20),
Add Column is_resolved Boolean,
Add Column satisfaction_category VARCHAR(20);

Select Count(*) As total_tickets
From support_tickets; -- Total imported tickets

Select
    ticket_status,
    Count(*) As ticket_count
From support_tickets
Group by ticket_status
Order by ticket_count Desc; -- Ticket volume by status

Select
    ticket_priority,
    Count(*) As ticket_count
From support_tickets
Group by ticket_priority
Order by ticket_count Desc; -- Ticket volume by priority

Select
    ticket_channel,
    Count(*) As ticket_count
From support_tickets
Group by ticket_channel
Order by ticket_count Desc; -- Ticket volume by support channel

Select
    ticket_type,
    Count(*) As ticket_count
From support_tickets
Group by ticket_type
Order by ticket_count Desc; -- Ticket volume by ticket type

Select
    Round(Avg(customer_satisfaction_rating), 2) As average_satisfaction
From support_tickets; -- Average customer satisfaction rating

Select
    ticket_type,
    Round(Avg(customer_satisfaction_rating), 2) As average_satisfaction
From support_tickets
Group by ticket_type
Order by average_satisfaction Desc; -- Average satisfaction by ticket type

Select
    is_resolved,
    Count(*) As ticket_count
From support_tickets
Group by is_resolved; 

Update support_tickets
Set is_resolved = Case
    When ticket_status = 'Closed' Then 1
    Else 0
End; -- Resolved flag from ticket status

Select
    Round(Avg(is_resolved) * 100, 2) As resolution_rate
From support_tickets; -- Percentage of tickets marked as resolved

Select
    ticket_priority,
    Round(Avg(is_resolved) * 100, 2) As resolution_rate
From support_tickets
Group by ticket_priority
Order by resolution_rate Desc; -- Resolution rate by ticket priority

Select
    ticket_type,
    Round(Avg(is_resolved) * 100, 2) As resolution_rate
From support_tickets
Group by ticket_type
Order by resolution_rate Desc; -- Resolution rate by ticket type

Select
    ticket_priority,
    Round(Avg(customer_satisfaction_rating), 2) As average_satisfaction
From support_tickets
Group by ticket_priority
Order by average_satisfaction Desc; -- Average satisfaction by ticket priority

Select
    product_purchased,
    Count(*) As ticket_count
From support_tickets
Group by product_purchased
Order by ticket_count Desc; -- Ticket volume by product

Select
    customer_gender,
    Count(*) As ticket_count
From support_tickets
Group by customer_gender
Order by ticket_count Desc; -- Ticket volume by customer gender

Select
    ticket_channel,
    Round(Avg(customer_satisfaction_rating), 2) As average_satisfaction
From support_tickets
Group by ticket_channel
Order by average_satisfaction Desc; -- Average satisfaction by support channel

Select
    is_resolved,
    Round(Avg(customer_satisfaction_rating), 2) As average_satisfaction
From support_tickets
Group by is_resolved
Order by is_resolved Desc; -- Average satisfaction by resolution status

Select
    ticket_type,
    ticket_priority,
    Count(*) As ticket_count
From support_tickets
Group by ticket_type, ticket_priority
Order by ticket_type, ticket_count Desc; -- Ticket volume by type and priority

Select
    ticket_type,
    Count(customer_satisfaction_rating) As rated_tickets,
    Round(Avg(customer_satisfaction_rating), 2) As average_satisfaction
From support_tickets
Group by ticket_type
Order by average_satisfaction; -- Satisfaction and rating volume by ticket type

Select
    ticket_channel,
    Count(customer_satisfaction_rating) As rated_tickets,
    Round(Avg(customer_satisfaction_rating), 2) As average_satisfaction
From support_tickets
Group by ticket_channel
Order by average_satisfaction Desc; -- Satisfaction and rating volume by support channel

Select
    ticket_priority,
    Count(*) As ticket_count,
    Sum(is_resolved) As resolved_tickets,
    Round(Avg(is_resolved) * 100, 2) As resolution_rate,
    Round(Avg(customer_satisfaction_rating), 2) As average_satisfaction
From support_tickets
Group by ticket_priority
Order by ticket_priority; -- Resolution and satisfaction by priority

Select
    purchase_year,
    purchase_month,
    Count(*) As ticket_count
From support_tickets
Group by purchase_year, purchase_month
Order by purchase_year, purchase_month; -- Monthly ticket volume trend

Select
    Year(date_of_purchase) As purchase_year,
    Month(date_of_purchase) As purchase_month,
    Count(*) As ticket_count
From support_tickets
Group by Year(date_of_purchase), Month(date_of_purchase)
Order by purchase_year, purchase_month; -- Monthly ticket volume in chronological order

Select
    Year(date_of_purchase) As purchase_year,
    Count(*) As ticket_count
From support_tickets
Group by Year(date_of_purchase)
Order by purchase_year; -- Ticket volume by year

Select
    Count(*) As total_rows,
    Count(Distinct ticket_id) As unique_ticket_ids
From support_tickets; -- Validate ticket ID uniqueness

Select
    Count(*) As total_tickets
From support_tickets; -- Validate total ticket count

Select
    Count(*) - Count(ticket_id) As missing_ticket_ids
From support_tickets; -- Check for missing ticket IDs

Select
    Count(*) - Count(Distinct ticket_id) As duplicate_ticket_ids
From support_tickets; -- Check for duplicate ticket IDs

Select
    ticket_status,
    Count(*) As ticket_count,
    Sum(Case When resolution Is Null Then 1 Else 0 End) As missing_resolution,
    Sum(Case When resolution Is Not Null Then 1 Else 0 End) As has_resolution
From support_tickets
Group by ticket_status
Order by ticket_status; -- Check resolution consistency by ticket status

Select
    Min(customer_satisfaction_rating) As minimum_rating,
    Max(customer_satisfaction_rating) As maximum_rating,
    Count(customer_satisfaction_rating) As rated_tickets,
    Sum(
        Case
            When customer_satisfaction_rating < 1
              Or customer_satisfaction_rating > 5
            Then 1
            Else 0
        End
    ) As invalid_ratings
From support_tickets; -- Validate customer satisfaction rating range

Select
    Min(customer_age) As minimum_age,
    Max(customer_age) As maximum_age,
    Count(customer_age) As known_ages,
    Sum(
        Case
            When customer_age < 18
              Or customer_age > 100
            Then 1
            Else 0
        End
    ) As invalid_ages
From support_tickets; -- Validate customer age range

Select
    'Ticket Status' As column_name,
    ticket_status As category,
    Count(*) As ticket_count
From support_tickets
Group by ticket_status

Union All

Select
    'Ticket Priority',
    ticket_priority,
    Count(*)
From support_tickets
Group by ticket_priority

Union All

Select
    'Ticket Channel',
    ticket_channel,
    Count(*)
From support_tickets
Group by ticket_channel

Union All
Select
    'Customer Gender',
    customer_gender,
    Count(*)
From support_tickets
Group by customer_gender
Order by column_name, ticket_count Desc; -- Validate categorical values

Select
    Count(*) As total_tickets,
    Sum(Case When ticket_id Is Null Then 1 Else 0 End) As missing_ticket_id,
    Sum(Case When customer_email Is Null Then 1 Else 0 End) As missing_customer_email,
    Sum(Case When product_purchased Is Null Then 1 Else 0 End) As missing_product,
    Sum(Case When ticket_type Is Null Then 1 Else 0 End) As missing_ticket_type,
    Sum(Case When ticket_status Is Null Then 1 Else 0 End) As missing_status,
    Sum(Case When ticket_priority Is Null Then 1 Else 0 End) As missing_priority,
    Sum(Case When ticket_channel Is Null Then 1 Else 0 End) As missing_channel,
    Sum(Case When date_of_purchase Is Null Then 1 Else 0 End) As missing_purchase_date,
    Sum(Case When is_resolved Is Null Then 1 Else 0 End) As missing_resolution_flag
From support_tickets; -- Check missing values in key business columns

Select
    Min(first_response_time) As earliest_first_response,
    Max(first_response_time) As latest_first_response,
    Min(time_to_resolution) As earliest_time_to_resolution,
    Max(time_to_resolution) As latest_time_to_resolution
From support_tickets; -- Inspect the actual range of support time fields

Select
    Count(*) As total_tickets,
    Sum(
        Case
            When time_to_resolution < first_response_time
            Then 1
            Else 0
        End
    ) As resolution_before_response,
    Sum(
        Case
            When time_to_resolution >= first_response_time
            Then 1
            Else 0
        End
    ) As resolution_after_response
From support_tickets; -- Validate the chronological relationship between response and resolution timestamps

Select
    ticket_status,
    Count(*) As ticket_count,
    Sum(
        Case
            When time_to_resolution < first_response_time
            Then 1
            Else 0
        End
    ) As resolution_before_response,
    Sum(
        Case
            When time_to_resolution >= first_response_time
            Then 1
            Else 0
        End
    ) As resolution_after_response
From support_tickets
Group by ticket_status
Order by ticket_status; -- Check timestamp consistency by ticket status

Select
    Case
        When ticket_count = 1 Then 'One-time customer'
        Else 'Repeat-support customer'
    End As customer_type,
    Count(*) As customer_count
From (
    Select
        customer_email,
        Count(*) As ticket_count
    From support_tickets
    Group by customer_email
) As customer_summary
Group by
    Case
        When ticket_count = 1 Then 'One-time customer'
        Else 'Repeat-support customer'
    End
Order by customer_count Desc; -- Classify customers by support frequency

With customer_summary As (
    Select
        customer_email,
        Count(*) As ticket_count,
        Avg(is_resolved) As resolution_rate,
        Avg(customer_satisfaction_rating) As average_satisfaction
    From support_tickets
    Group by customer_email
)

Select
    Case
        When ticket_count = 1 Then 'One-time customer'
        Else 'Repeat-support customer'
    End As customer_type,
    Count(*) As customer_count,
    Sum(ticket_count) As ticket_count,
    Round(Avg(resolution_rate) * 100, 2) As resolution_rate,
    Round(Avg(average_satisfaction), 2) As average_satisfaction
From customer_summary
Group by
    Case
        When ticket_count = 1 Then 'One-time customer'
        Else 'Repeat-support customer'
    End
Order by customer_count Desc; -- Compare support outcomes by customer type

Select
    Case
        When customer_age Between 18 And 24 Then '18-24'
        When customer_age Between 25 And 34 Then '25-34'
        When customer_age Between 35 And 44 Then '35-44'
        When customer_age Between 45 And 54 Then '45-54'
        Else '55+'
    End As age_group,
    Count(*) As ticket_count,
    Round(Avg(is_resolved) * 100, 2) As resolution_rate,
    Round(Avg(customer_satisfaction_rating), 2) As average_satisfaction
From support_tickets
Group by
    Case
        When customer_age Between 18 And 24 Then '18-24'
        When customer_age Between 25 And 34 Then '25-34'
        When customer_age Between 35 And 44 Then '35-44'
        When customer_age Between 45 And 54 Then '45-54'
        Else '55+'
    End
Order by
    Min(customer_age); -- Support outcomes by customer age group
    
With overall_metrics As (
    Select
        Count(*) As total_tickets,
        Avg(is_resolved) * 100 As overall_resolution_rate,
        Avg(customer_satisfaction_rating) As overall_satisfaction
    From support_tickets
),

ticket_type_metrics As (
    Select
        ticket_type,
        Count(*) As ticket_count,
        Avg(is_resolved) * 100 As resolution_rate,
        Avg(customer_satisfaction_rating) As average_satisfaction
    From support_tickets
    Group by ticket_type
)

Select
    t.ticket_type,
    t.ticket_count,
    Round(t.ticket_count * 100.0 / o.total_tickets, 2) As ticket_share,
    Round(t.resolution_rate, 2) As resolution_rate,
    Round(t.average_satisfaction, 2) As average_satisfaction,
    Case
        When t.ticket_count > (
                Select Avg(ticket_count)
                From ticket_type_metrics
            )
            And t.resolution_rate < o.overall_resolution_rate
            And t.average_satisfaction < o.overall_satisfaction
        Then 'High-priority problem area'
        Else 'No clear problem signal'
    End As performance_flag
From ticket_type_metrics t
Cross Join overall_metrics o
Order by t.ticket_count Desc; -- Identify ticket types with combined performance issues

With overall_metrics As (
    Select
        Count(*) As total_tickets,
        Avg(is_resolved) * 100 As overall_resolution_rate,
        Avg(customer_satisfaction_rating) As overall_satisfaction
    From support_tickets
),

product_metrics As (
    Select
        product_purchased,
        Count(*) As ticket_count,
        Avg(is_resolved) * 100 As resolution_rate,
        Avg(customer_satisfaction_rating) As average_satisfaction
    From support_tickets
    Group by product_purchased
)

Select
    p.product_purchased,
    p.ticket_count,
    Round(p.ticket_count * 100.0 / o.total_tickets, 2) As ticket_share,
    Round(p.resolution_rate, 2) As resolution_rate,
    Round(p.average_satisfaction, 2) As average_satisfaction,
    Case
        When p.ticket_count > (
                Select Avg(ticket_count)
                From product_metrics
            )
            And p.resolution_rate < o.overall_resolution_rate
            And p.average_satisfaction < o.overall_satisfaction
        Then 'High-priority problem area'
        Else 'No clear problem signal'
    End As performance_flag
From product_metrics p
Cross Join overall_metrics o
Order by p.ticket_count Desc; -- Identify products with combined support performance issues

With product_performance As (
    Select
        product_purchased,
        Count(*) As ticket_count,
        Round(Avg(is_resolved) * 100, 2) As resolution_rate,
        Round(Avg(customer_satisfaction_rating), 2) As average_satisfaction
    From support_tickets
    Group by product_purchased
    Having Count(*) >= 100
)

Select
    product_purchased,
    ticket_count,
    resolution_rate,
    average_satisfaction,
    Rank() Over (
        Order by average_satisfaction Desc
    ) As satisfaction_rank
From product_performance
Order by satisfaction_rank; -- Rank products by customer satisfaction