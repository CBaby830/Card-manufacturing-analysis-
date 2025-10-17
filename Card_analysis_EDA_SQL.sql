create database Card_manufacturing_analysis;
use Card_manufacturing_analysis;
show tables;

#Sample 10 rows
SELECT * FROM dataset_gsm_cards LIMIT 10;

#Number of rows in the table
SELECT COUNT(*) AS total_rows FROM dataset_gsm_cards;

#describe
DESCRIBE dataset_gsm_cards;

 #Check colomns count
SELECT COUNT(*) AS columns_count
FROM information_schema.columns
WHERE table_name = 'dataset_gms_cards';

#Finding total_duplicate_rows
SELECT COUNT(*) - COUNT(DISTINCT CONCAT_WS('|',
    `Batch ID`, `Job Order Number`, `Printer Operator ID`, `Ink Type`,
    `Paper Type`, `Chip Type`, `Personalization Operator ID`, `PO_number`
)) AS total_duplicate_rows
FROM dataset_gsm_cards;

#check null values
SELECT 
    SUM(CASE WHEN `Batch ID` IS NULL OR `Batch ID` = '' THEN 1 ELSE 0 END) AS batch_id_blanks,
    SUM(CASE WHEN `Job Order Number` IS NULL OR `Job Order Number` = '' THEN 1 ELSE 0 END) AS job_order_blanks,
    SUM(CASE WHEN `Printer Operator ID` IS NULL OR `Printer Operator ID` = '' THEN 1 ELSE 0 END) AS printer_op_blanks,
    SUM(CASE WHEN `Ink Type` IS NULL OR `Ink Type` = '' THEN 1 ELSE 0 END) AS ink_type_blanks,
    SUM(CASE WHEN `Paper Type` IS NULL OR `Paper Type` = '' THEN 1 ELSE 0 END) AS paper_type_blanks,
    SUM(CASE WHEN `Chip Type` IS NULL OR `Chip Type` = '' THEN 1 ELSE 0 END) AS chip_type_blanks,
    SUM(CASE WHEN `Personalization Operator ID` IS NULL OR `Personalization Operator ID` = '' THEN 1 ELSE 0 END) AS personalization_op_blanks,
    SUM(CASE WHEN `PO_number` IS NULL OR `PO_number` = '' THEN 1 ELSE 0 END) AS po_number_blanks,
    sum(case when `No. of Quarter Cards` is null or `No. of Quarter Cards` = '' then 1 else 0 end) as No_OF_Quarter_cards,
    SUM(CASE WHEN `ICCID` IS NULL OR `ICCID` = '' THEN 1 ELSE 0 END) AS iccid_blanks,
    SUM(CASE WHEN `PO_number` IS NULL OR `PO_number` = '' THEN 1 ELSE 0 END) AS po_number_blanks,
    SUM(CASE WHEN `Personalization Operator ID` IS NULL OR `Personalization Operator ID` = '' THEN 1 ELSE 0 END) AS personalization_operator_id_blanks
FROM dataset_gsm_cards;

# remove the null values
DELETE FROM dataset_gsm_cards
WHERE `No. of Quarter Cards` IS NULL OR `No. of Quarter Cards` = '';

select sum(case when `No. of Quarter Cards` is null or `No. of Quarter Cards` = '' then 1 else 0 end) as No_of_Quarter_cards
from dataset_gsm_cards;

#Unique Count of Each Column
SELECT 
    COUNT(DISTINCT `Batch ID`) AS batch_id_unique,
    COUNT(DISTINCT `Job Order Number`) AS job_order_unique,
    COUNT(DISTINCT `Printer Operator ID`) AS printer_operator_unique,
    COUNT(DISTINCT `Ink Type`) AS ink_type_unique,
    COUNT(DISTINCT `Paper Type`) AS paper_type_unique,
    COUNT(DISTINCT `No. of Sheets Used`) AS sheets_used_unique,
    COUNT(DISTINCT `No. of Cards Printed`) AS cards_printed_unique,
    COUNT(DISTINCT `No. of Half Cards`) AS half_cards_unique,
    COUNT(DISTINCT `No. of Quarter Cards`) AS quarter_cards_unique,
    COUNT(DISTINCT `Accepted Cards`) AS accepted_cards_unique,
    COUNT(DISTINCT `Rejected Cards`) AS rejected_cards_unique,
    COUNT(DISTINCT `Color Matching Data`) AS color_matching_unique,
    COUNT(DISTINCT `Quality Control Result (Printing)`) AS qc_printing_unique,
    COUNT(DISTINCT `Printing QC - Alignment`) AS printing_qc_alignment_unique,
    COUNT(DISTINCT `Printing QC - Color Accuracy`) AS printing_qc_color_accuracy_unique,
    COUNT(DISTINCT `Printing QC - Material Integrity`) AS printing_qc_material_unique,
    COUNT(DISTINCT `Lamination Date/Time`) AS lamination_datetime_unique,
    COUNT(DISTINCT `Lamination Operator ID`) AS lamination_operator_unique,
    COUNT(DISTINCT `Chip Type`) AS chip_type_unique,
    COUNT(DISTINCT `Embedding Errors`) AS embedding_errors_unique,
    COUNT(DISTINCT `Chip Serial Numbers`) AS chip_serial_unique,
    COUNT(DISTINCT `Quality Control Result (Embedding)`) AS qc_embedding_unique,
    COUNT(DISTINCT `Embedding QC - Chip Functionality`) AS embedding_chip_func_unique,
    COUNT(DISTINCT `Embedding QC - Alignment`) AS embedding_alignment_unique,
    COUNT(DISTINCT `Network Data`) AS network_data_unique,
    COUNT(DISTINCT `Encryption Key`) AS encryption_key_unique,
    COUNT(DISTINCT `Laser Engraving Serial`) AS laser_serial_unique,
    COUNT(DISTINCT `ICCID`) AS iccid_unique,
    COUNT(DISTINCT `Personalization Operator ID`) AS personalization_operator_unique,
    COUNT(DISTINCT `Quality Control Result (Personalization)`) AS qc_personalization_unique,
    COUNT(DISTINCT `Personalization QC - Data Accuracy`) AS personalization_data_unique,
    COUNT(DISTINCT `Personalization QC - Laser Engraving`) AS personalization_laser_unique,
    COUNT(DISTINCT `Audit Trail Logs`) AS audit_trail_unique,
    COUNT(DISTINCT `PO_number`) AS po_number_unique
FROM dataset_gsm_cards;


 /*-------------------------------------------------------------------Measures of Central Tendency---------------------------------------------------------------------*/
/* Calculate average (mean) values for numerical columns*/
SELECT
    AVG(`No. of Sheets Used`) AS avg_sheets_used,
    AVG(`No. of Cards Printed`) AS avg_cards_printed,
    AVG(`No. of Half Cards`) AS avg_half_cards,
    AVG(`No. of Quarter Cards`) AS avg_quarter_cards,
    AVG(`Accepted Cards`) AS avg_accepted_cards,
    AVG(`Rejected Cards`) AS avg_rejected_cards,
    AVG(`Embedding Errors`) AS avg_embedding_errors
FROM dataset_gsm_cards;

/*Calculate median 3434*/ 
SELECT AVG(`No. of Cards Printed`) AS median_cards_printed
FROM (
    SELECT 
        `No. of Cards Printed`,
        ROW_NUMBER() OVER (ORDER BY `No. of Cards Printed`) AS row_num,
        COUNT(*) OVER () AS total_count
    FROM dataset_gsm_cards
    WHERE `No. of Cards Printed` IS NOT NULL
) AS subquery
WHERE row_num = (total_count + 1) / 2 OR row_num = (total_count + 2) / 2;

-- Median of No. of Sheets Used
SELECT `No. of Sheets Used` AS median_sheets_used
FROM (
    SELECT `No. of Sheets Used`, 
           ROW_NUMBER() OVER (ORDER BY `No. of Sheets Used`) AS row_num,
           COUNT(*) OVER () AS total_count
    FROM dataset_gsm_cards
    WHERE `No. of Sheets Used` IS NOT NULL
) AS subquery
WHERE row_num = (total_count + 1) / 2 OR row_num = (total_count + 2) / 2;

-- Median of No. of Cards Printed
SELECT `No. of Cards Printed` AS median_cards_printed
FROM (
    SELECT `No. of Cards Printed`, 
           ROW_NUMBER() OVER (ORDER BY `No. of Cards Printed`) AS row_num,
           COUNT(*) OVER () AS total_count
    FROM dataset_gsm_cards
    WHERE `No. of Cards Printed` IS NOT NULL
) AS subquery
WHERE row_num = (total_count + 1) / 2 OR row_num = (total_count + 2) / 2;

-- Median of No. of Half Cards
SELECT `No. of Half Cards` AS median_half_cards
FROM (
    SELECT `No. of Half Cards`, 
           ROW_NUMBER() OVER (ORDER BY `No. of Half Cards`) AS row_num,
           COUNT(*) OVER () AS total_count
    FROM dataset_gsm_cards
    WHERE `No. of Half Cards` IS NOT NULL
) AS subquery
WHERE row_num = (total_count + 1) / 2 OR row_num = (total_count + 2) / 2;

-- Median of No. of Quarter Cards
SELECT `No. of Quarter Cards` AS median_quarter_cards
FROM (
    SELECT `No. of Quarter Cards`, 
           ROW_NUMBER() OVER (ORDER BY `No. of Quarter Cards`) AS row_num,
           COUNT(*) OVER () AS total_count
    FROM dataset_gsm_cards
    WHERE `No. of Quarter Cards` IS NOT NULL
) AS subquery
WHERE row_num = (total_count + 1) / 2 OR row_num = (total_count + 2) / 2;

-- Median of Accepted Cards
SELECT `Accepted Cards` AS median_accepted_cards
FROM (
    SELECT `Accepted Cards`, 
           ROW_NUMBER() OVER (ORDER BY `Accepted Cards`) AS row_num,
           COUNT(*) OVER () AS total_count
    FROM dataset_gsm_cards
    WHERE `Accepted Cards` IS NOT NULL
) AS subquery
WHERE row_num = (total_count + 1) / 2 OR row_num = (total_count + 2) / 2;

-- Median of Rejected Cards
SELECT `Rejected Cards` AS median_rejected_cards
FROM (
    SELECT `Rejected Cards`, 
           ROW_NUMBER() OVER (ORDER BY `Rejected Cards`) AS row_num,
           COUNT(*) OVER () AS total_count
    FROM dataset_gsm_cards
    WHERE `Rejected Cards` IS NOT NULL
) AS subquery
WHERE row_num = (total_count + 1) / 2 OR row_num = (total_count + 2) / 2;

-- Median of Embedding Errors
SELECT `Embedding Errors` AS median_embedding_errors
FROM (
    SELECT `Embedding Errors`, 
           ROW_NUMBER() OVER (ORDER BY `Embedding Errors`) AS row_num,
           COUNT(*) OVER () AS total_count
    FROM dataset_gsm_cards
    WHERE `Embedding Errors` IS NOT NULL
) AS subquery
WHERE row_num = (total_count + 1) / 2 OR row_num = (total_count + 2) / 2;

/*------------------------------------------------------------------- Measures of Dispersion------------------------------------------------------------------*/
SELECT
    MIN(`No. of Sheets Used`) AS min_sheets_used,
    MAX(`No. of Sheets Used`) AS max_sheets_used,
    MAX(`No. of Sheets Used`) - MIN(`No. of Sheets Used`) AS range_sheets_used,
    VAR_SAMP(`No. of Sheets Used`) AS variance_sheets_used,
    STDDEV_SAMP(`No. of Sheets Used`) AS stddev_sheets_used 
FROM dataset_gsm_cards;

select 
    MIN(`No. of Cards Printed`) AS min_cards_printed,
    MAX(`No. of Cards Printed`) AS max_cards_printed,
    MAX(`No. of Cards Printed`) - MIN(`No. of Cards Printed`) AS range_cards_printed,
    VAR_SAMP(`No. of Cards Printed`) AS variance_cards_printed,
    STDDEV_SAMP(`No. of Cards Printed`) AS stddev_cards_printed FROM dataset_gsm_cards;

 select   MIN(`No. of Half Cards`) AS min_half_cards,
    MAX(`No. of Half Cards`) AS max_half_cards,
    MAX(`No. of Half Cards`) - MIN(`No. of Half Cards`) AS range_half_cards,
    VAR_SAMP(`No. of Half Cards`) AS variance_half_cards,
    STDDEV_SAMP(`No. of Half Cards`) AS stddev_half_cards FROM dataset_gsm_cards;

select  MIN(`No. of Quarter Cards`) AS min_quarter_cards,
    MAX(`No. of Quarter Cards`) AS max_quarter_cards,
    MAX(`No. of Quarter Cards`) - MIN(`No. of Quarter Cards`) AS range_quarter_cards,
    VAR_SAMP(`No. of Quarter Cards`) AS variance_quarter_cards,
    STDDEV_SAMP(`No. of Quarter Cards`) AS stddev_quarter_cards FROM dataset_gsm_cards;

select  MIN(`Accepted Cards`) AS min_accepted_cards,
    MAX(`Accepted Cards`) AS max_accepted_cards,
    MAX(`Accepted Cards`) - MIN(`Accepted Cards`) AS range_accepted_cards,
    VAR_SAMP(`Accepted Cards`) AS variance_accepted_cards,
    STDDEV_SAMP(`Accepted Cards`) AS stddev_accepted_cards FROM dataset_gsm_cards;

select MIN(`Rejected Cards`) AS min_rejected_cards,
    MAX(`Rejected Cards`) AS max_rejected_cards,
    MAX(`Rejected Cards`) - MIN(`Rejected Cards`) AS range_rejected_cards,
    VAR_SAMP(`Rejected Cards`) AS variance_rejected_cards,
    STDDEV_SAMP(`Rejected Cards`) AS stddev_rejected_cards FROM dataset_gsm_cards;

select   MIN(`Embedding Errors`) AS min_embedding_errors,
    MAX(`Embedding Errors`) AS max_embedding_errors,
    MAX(`Embedding Errors`) - MIN(`Embedding Errors`) AS range_embedding_errors,
    VAR_SAMP(`Embedding Errors`) AS variance_embedding_errors,
    STDDEV_SAMP(`Embedding Errors`) AS stddev_embedding_errors FROM dataset_gsm_cards;

/*-----------------------------------------------------------------Third Moment Business Decision / Skewness---------------------------------------------------------------*/
SELECT
    SUM(POWER(`No. of Sheets Used` - ANY_VALUE(stats.mean_sheets), 3)) /
    ((ANY_VALUE(stats.n_sheets) - 1) * POWER(ANY_VALUE(stats.std_sheets), 3)) AS skewness_sheets_used,

    SUM(POWER(`No. of Cards Printed` - ANY_VALUE(stats.mean_cards), 3)) /
    ((ANY_VALUE(stats.n_cards) - 1) * POWER(ANY_VALUE(stats.std_cards), 3)) AS skewness_cards_printed,

    SUM(POWER(`No. of Half Cards` - ANY_VALUE(stats.mean_half), 3)) /
    ((ANY_VALUE(stats.n_half) - 1) * POWER(ANY_VALUE(stats.std_half), 3)) AS skewness_half_cards,

    SUM(POWER(`No. of Quarter Cards` - ANY_VALUE(stats.mean_quarter), 3)) /
    ((ANY_VALUE(stats.n_quarter) - 1) * POWER(ANY_VALUE(stats.std_quarter), 3)) AS skewness_quarter_cards,

    SUM(POWER(`Accepted Cards` - ANY_VALUE(stats.mean_accepted), 3)) /
    ((ANY_VALUE(stats.n_accepted) - 1) * POWER(ANY_VALUE(stats.std_accepted), 3)) AS skewness_accepted_cards,

    SUM(POWER(`Rejected Cards` - ANY_VALUE(stats.mean_rejected), 3)) /
    ((ANY_VALUE(stats.n_rejected) - 1) * POWER(ANY_VALUE(stats.std_rejected), 3)) AS skewness_rejected_cards,

    SUM(POWER(`Embedding Errors` - ANY_VALUE(stats.mean_embedding), 3)) /
    ((ANY_VALUE(stats.n_embedding) - 1) * POWER(ANY_VALUE(stats.std_embedding), 3)) AS skewness_embedding_errors
FROM dataset_gsm_cards
CROSS JOIN (
    SELECT
        COUNT(*) AS n_sheets, AVG(`No. of Sheets Used`) AS mean_sheets, STDDEV_SAMP(`No. of Sheets Used`) AS std_sheets,
        COUNT(*) AS n_cards, AVG(`No. of Cards Printed`) AS mean_cards, STDDEV_SAMP(`No. of Cards Printed`) AS std_cards,
        COUNT(*) AS n_half, AVG(`No. of Half Cards`) AS mean_half, STDDEV_SAMP(`No. of Half Cards`) AS std_half,
        COUNT(*) AS n_quarter, AVG(`No. of Quarter Cards`) AS mean_quarter, STDDEV_SAMP(`No. of Quarter Cards`) AS std_quarter,
        COUNT(*) AS n_accepted, AVG(`Accepted Cards`) AS mean_accepted, STDDEV_SAMP(`Accepted Cards`) AS std_accepted,
        COUNT(*) AS n_rejected, AVG(`Rejected Cards`) AS mean_rejected, STDDEV_SAMP(`Rejected Cards`) AS std_rejected,
        COUNT(*) AS n_embedding, AVG(`Embedding Errors`) AS mean_embedding, STDDEV_SAMP(`Embedding Errors`) AS std_embedding
    FROM dataset_gsm_cards
) AS stats;

/*-----------------------------------------------------------------Fourth Moment Business Decision / Kurtosis---------------------------------------------------------------*/

SELECT
    SUM(POWER(`No. of Sheets Used` - ANY_VALUE(stats.mean_sheets), 4)) /
    ((ANY_VALUE(stats.n_sheets) - 1) * POWER(ANY_VALUE(stats.std_sheets), 4)) AS kurtosis_sheets_used,

    SUM(POWER(`No. of Cards Printed` - ANY_VALUE(stats.mean_cards), 4)) /
    ((ANY_VALUE(stats.n_cards) - 1) * POWER(ANY_VALUE(stats.std_cards), 4)) AS kurtosis_cards_printed,

    SUM(POWER(`No. of Half Cards` - ANY_VALUE(stats.mean_half), 4)) /
    ((ANY_VALUE(stats.n_half) - 1) * POWER(ANY_VALUE(stats.std_half), 4)) AS kurtosis_half_cards,

    SUM(POWER(`No. of Quarter Cards` - ANY_VALUE(stats.mean_quarter), 4)) /
    ((ANY_VALUE(stats.n_quarter) - 1) * POWER(ANY_VALUE(stats.std_quarter), 4)) AS kurtosis_quarter_cards,

    SUM(POWER(`Accepted Cards` - ANY_VALUE(stats.mean_accepted), 4)) /
    ((ANY_VALUE(stats.n_accepted) - 1) * POWER(ANY_VALUE(stats.std_accepted), 4)) AS kurtosis_accepted_cards,

    SUM(POWER(`Rejected Cards` - ANY_VALUE(stats.mean_rejected), 4)) /
    ((ANY_VALUE(stats.n_rejected) - 1) * POWER(ANY_VALUE(stats.std_rejected), 4)) AS kurtosis_rejected_cards,

    SUM(POWER(`Embedding Errors` - ANY_VALUE(stats.mean_embedding), 4)) /
    ((ANY_VALUE(stats.n_embedding) - 1) * POWER(ANY_VALUE(stats.std_embedding), 4)) AS kurtosis_embedding_errors
FROM dataset_gsm_cards
CROSS JOIN (
    SELECT
        COUNT(*) AS n_sheets, AVG(`No. of Sheets Used`) AS mean_sheets, STDDEV_SAMP(`No. of Sheets Used`) AS std_sheets,
        COUNT(*) AS n_cards, AVG(`No. of Cards Printed`) AS mean_cards, STDDEV_SAMP(`No. of Cards Printed`) AS std_cards,
        COUNT(*) AS n_half, AVG(`No. of Half Cards`) AS mean_half, STDDEV_SAMP(`No. of Half Cards`) AS std_half,
        COUNT(*) AS n_quarter, AVG(`No. of Quarter Cards`) AS mean_quarter, STDDEV_SAMP(`No. of Quarter Cards`) AS std_quarter,
        COUNT(*) AS n_accepted, AVG(`Accepted Cards`) AS mean_accepted, STDDEV_SAMP(`Accepted Cards`) AS std_accepted,
        COUNT(*) AS n_rejected, AVG(`Rejected Cards`) AS mean_rejected, STDDEV_SAMP(`Rejected Cards`) AS std_rejected,
        COUNT(*) AS n_embedding, AVG(`Embedding Errors`) AS mean_embedding, STDDEV_SAMP(`Embedding Errors`) AS std_embedding
    FROM dataset_gsm_cards
) AS stats;

/*---------------------------------------------------------------------Handling Duplicates-----------------------------------------------------------------------*/
-- Find duplicates based on Batch ID and PO_number
SELECT `Batch ID`, `PO_number`, COUNT(*) AS duplicate_count
FROM dataset_gsm_cards
GROUP BY `Batch ID`, `PO_number`
HAVING COUNT(*) > 1;

sELECT `Batch ID`, `PO_number`, COUNT(*) AS duplicate_count
FROM dataset_gsm_cards
GROUP BY `Batch ID`, `PO_number`
HAVING COUNT(*) > 1;

-- Calculate Q1 and Q3 for numeric columns using MySQL window functions
WITH ranked AS (
  SELECT 
    `No. of Sheets Used`,
    `No. of Cards Printed`,
    `No. of Half Cards`,
    `No. of Quarter Cards`,
    `Accepted Cards`,
    `Rejected Cards`,
    PERCENT_RANK() OVER (ORDER BY `No. of Sheets Used`) AS rnk_sheets,
    PERCENT_RANK() OVER (ORDER BY `No. of Cards Printed`) AS rnk_cards,
    PERCENT_RANK() OVER (ORDER BY `No. of Half Cards`) AS rnk_half,
    PERCENT_RANK() OVER (ORDER BY `No. of Quarter Cards`) AS rnk_quarter,
    PERCENT_RANK() OVER (ORDER BY `Accepted Cards`) AS rnk_accepted,
    PERCENT_RANK() OVER (ORDER BY `Rejected Cards`) AS rnk_rejected
  FROM dataset_gsm_cards
)
SELECT
  MAX(CASE WHEN rnk_sheets <= 0.25 THEN `No. of Sheets Used` END) AS Q1_sheets,
  MAX(CASE WHEN rnk_sheets <= 0.75 THEN `No. of Sheets Used` END) AS Q3_sheets,

  MAX(CASE WHEN rnk_cards <= 0.25 THEN `No. of Cards Printed` END) AS Q1_cards,
  MAX(CASE WHEN rnk_cards <= 0.75 THEN `No. of Cards Printed` END) AS Q3_cards,

  MAX(CASE WHEN rnk_half <= 0.25 THEN `No. of Half Cards` END) AS Q1_half,
  MAX(CASE WHEN rnk_half <= 0.75 THEN `No. of Half Cards` END) AS Q3_half,

  MAX(CASE WHEN rnk_quarter <= 0.25 THEN `No. of Quarter Cards` END) AS Q1_quarter,
  MAX(CASE WHEN rnk_quarter <= 0.75 THEN `No. of Quarter Cards` END) AS Q3_quarter,

  MAX(CASE WHEN rnk_accepted <= 0.25 THEN `Accepted Cards` END) AS Q1_accepted,
  MAX(CASE WHEN rnk_accepted <= 0.75 THEN `Accepted Cards` END) AS Q3_accepted,

  MAX(CASE WHEN rnk_rejected <= 0.25 THEN `Rejected Cards` END) AS Q1_rejected,
  MAX(CASE WHEN rnk_rejected <= 0.75 THEN `Rejected Cards` END) AS Q3_rejected
FROM ranked;

