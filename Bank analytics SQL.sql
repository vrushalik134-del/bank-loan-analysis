create database BankData;
use bankdata;

select * from fin1;


SELECT issue_d FROM fin1 WHERE issue_d IS NULL OR issue_d = '';

SET SQL_SAFE_UPDATES = 0;

UPDATE fin1
SET issue_d = CURDATE()
WHERE issue_d IS NULL OR issue_d = '';

UPDATE fin1
SET issue_d = STR_TO_DATE(issue_d, '%d-%m-%Y')
WHERE issue_d IS NOT NULL AND issue_d <> '';


## -- Kpi 1 Year wise loan amount stat

SELECT YEAR(issue_d) AS year,
       CASE
           WHEN SUM(loan_amnt) >= 1000000 
           THEN CONCAT(FORMAT(SUM(loan_amnt)/1000000,2),'M')
           ELSE SUM(loan_amnt)
       END AS loan_amount
FROM fin1
GROUP BY YEAR(issue_d)
ORDER BY YEAR(issue_d) ASC;

------ year wise loan Amount stat with respect to loan status---------
select year(issue_d) as year, loan_status,
case
    when sum(loan_amnt) >= 1000000 then concat(format(sum(loan_amnt) / 1000000,2),'M')
    when sum(loan_amnt) >= 1000 then concat(format(sum(loan_amnt)/1000,2),'K')
    else sum(loan_amnt)
    end as loan_amount
from fin1
group by year,loan_status
order by year asc;

DESCRIBE fin1;
DESCRIBE fin2;


##### KPI 2 (GRADE AND SUB GRADE WISE REVOL_BAL) #####
select grade, sub_grade,sum(revol_bal) as total_revol_bal
from fin1 f1 inner join fin2 f2 
on(f1.id = f2.loan_id) 
group by grade,sub_grade
order by grade;


##### KPI 3 (Total Payment for Verified Status Vs Total Payment for Non Verified Status) #####
select verification_status, round(sum(total_pymnt),2) as Total_payment
from fin1 f1 inner join fin2 f2 
on(f1.id = f2.loan_id)
where verification_status in('Verified', 'Not Verified')
group by verification_status;



##### KPI 4 (State wise and last_credit_pull_d wise loan status) #####
SELECT addr_state,
       last_credit_pull_d,
       MAX(loan_status) AS loan_status
FROM fin1 f1
INNER JOIN fin2 f2 ON f1.id = f2.loan_id
GROUP BY addr_state, last_credit_pull_d
ORDER BY addr_state;


##### KPI 5 (Home ownership Vs last payment date stats) #####

SELECT MAX(STR_TO_DATE(last_pymnt_d,'%d/%m/%Y')) AS latest_payment_date
FROM fin2;

SELECT f1.home_ownership,
       STR_TO_DATE(f2.last_pymnt_d,'%d/%m/%Y') AS last_payment_date,
       SUM(f2.last_pymnt_amnt) AS total_payment
FROM fin1 f1
INNER JOIN fin2 f2 ON f1.id = f2.loan_id
WHERE STR_TO_DATE(f2.last_pymnt_d,'%d/%m/%Y') = (
    SELECT MAX(STR_TO_DATE(last_pymnt_d,'%d/%m/%Y')) FROM fin2
)
GROUP BY f1.home_ownership, STR_TO_DATE(f2.last_pymnt_d,'%d/%m/%Y')
ORDER BY total_payment DESC;

SELECT COUNT(*) AS row_count FROM fin2;
SELECT SUM(last_pymnt_amnt) AS total_payments FROM fin2;

SELECT f1.home_ownership,
       f2.last_pymnt_d AS last_payment_date,
       f1.loan_status,
       SUM(f2.last_pymnt_amnt) AS total_payment
FROM fin1 f1
INNER JOIN fin2 f2 ON f1.id = f2.loan_id
WHERE STR_TO_DATE(f2.last_pymnt_d,'%d/%m/%Y') = (
    SELECT MAX(STR_TO_DATE(last_pymnt_d,'%d/%m/%Y')) FROM fin2
)
GROUP BY f1.home_ownership, f2.last_pymnt_d, f1.loan_status
ORDER BY total_payment DESC;

SELECT f1.home_ownership,
       SUM(f2.last_pymnt_amnt) AS total_payment
FROM fin1 f1
INNER JOIN fin2 f2 ON f1.id = f2.loan_id
GROUP BY f1.home_ownership
ORDER BY total_payment DESC;






















CREATE TABLE fin2 (
    loan_id INT PRIMARY KEY,
    delinq_2yrs INT,
    earliest_cr_line VARCHAR(20),
    inq_last_6mths INT,
    mths_since_last_delinq INT,
    mths_since_last_record INT,
    open_acc INT,
    pub_rec INT,
    revol_bal BIGINT,
    revol_util DECIMAL(5,2),
    total_acc INT,
    initial_list_status CHAR(1),
    out_prncp DECIMAL(12,2),
    out_prncp_inv DECIMAL(12,2),
    total_pymnt DECIMAL(12,2),
    total_pymnt_inv DECIMAL(12,2),
    total_rec_prncp DECIMAL(12,2),
    total_rec_int DECIMAL(12,2),
    total_rec_late_fee DECIMAL(12,2),
    recoveries DECIMAL(12,2),
    collection_recovery_fee DECIMAL(12,2),
    last_pymnt_d VARCHAR(20),
    last_pymnt_amnt DECIMAL(12,2),
    next_pymnt_d VARCHAR(20),
    last_credit_pull_d VARCHAR(20)
);

ALTER TABLE fin2 
MODIFY revol_util VARCHAR(10);

ALTER TABLE fin2 
MODIFY revol_util DECIMAL(5,2);




SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/fin2.csv'
INTO TABLE fin2
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(loan_id, delinq_2yrs, earliest_cr_line, inq_last_6mths,
 mths_since_last_delinq, mths_since_last_record, open_acc, pub_rec,
 revol_bal, revol_util, total_acc, initial_list_status, out_prncp,
 out_prncp_inv, total_pymnt, total_pymnt_inv, total_rec_prncp,
 total_rec_int, total_rec_late_fee, recoveries, collection_recovery_fee,
 last_pymnt_d, last_pymnt_amnt, next_pymnt_d, last_credit_pull_d);
 
 
 select * from fin2;
 SELECT DATABASE();
 





