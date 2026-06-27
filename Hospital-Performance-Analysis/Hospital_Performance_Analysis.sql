
-- HOSPITAL MANAGEMENT DATABASE

-- CREATE TABLES

CREATE TABLE Departments (
    Department_ID INT PRIMARY KEY,
    Department_Name VARCHAR(100)
);

CREATE TABLE Doctors (
    Doctor_ID INT PRIMARY KEY,
    Doctor_Name VARCHAR(100),
    Department_ID INT,
    Specialization VARCHAR(100),
    FOREIGN KEY (Department_ID) REFERENCES Departments(Department_ID)
);

CREATE TABLE Patients (
    Patient_ID INT PRIMARY KEY,
    Patient_Name VARCHAR(100),
    Gender VARCHAR(10),
    Age INT,
    City VARCHAR(50),
    Contact_No VARCHAR(15)
);

CREATE TABLE Admissions (
    Admission_ID INT PRIMARY KEY,
    Patient_ID INT,
    Doctor_ID INT,
    Department_ID INT,
    Admission_Date DATE,
    Discharge_Date DATE,
    Diagnosis VARCHAR(255),
    FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID),
    FOREIGN KEY (Doctor_ID) REFERENCES Doctors(Doctor_ID),
    FOREIGN KEY (Department_ID) REFERENCES Departments(Department_ID)
);

CREATE TABLE Billing (
    Billing_ID INT PRIMARY KEY,
    Admission_ID INT,
    Treatment_Cost NUMERIC(10,2),
    Medicine_Cost NUMERIC(10,2),
    Room_Charge NUMERIC(10,2),
    Total_Amount NUMERIC(10,2),
    Payment_Status VARCHAR(50),
    FOREIGN KEY (Admission_ID) REFERENCES Admissions(Admission_ID)
);

-- INSERT DEPARTMENTS

INSERT INTO Departments VALUES
(1,'Cardiology'),
(2,'Neurology'),
(3,'Orthopedics'),
(4,'Pediatrics'),
(5,'General Medicine');


-- INSERT DOCTORS

INSERT INTO Doctors VALUES
(1,'Dr. Raj',1,'Cardiologist'),
(2,'Dr. Priya',1,'Cardiologist'),
(3,'Dr. Arun',1,'Cardiologist'),
(4,'Dr. Kiran',1,'Cardiologist'),
(5,'Dr. Meena',2,'Neurologist'),
(6,'Dr. Suresh',2,'Neurologist'),
(7,'Dr. Kavya',2,'Neurologist'),
(8,'Dr. Naveen',2,'Neurologist'),
(9,'Dr. Ramesh',3,'Orthopedic'),
(10,'Dr. Divya',3,'Orthopedic'),
(11,'Dr. Hari',3,'Orthopedic'),
(12,'Dr. Rekha',3,'Orthopedic'),
(13,'Dr. Ashok',4,'Pediatrician'),
(14,'Dr. Swathi',4,'Pediatrician'),
(15,'Dr. Vimal',4,'Pediatrician'),
(16,'Dr. Nisha',4,'Pediatrician'),
(17,'Dr. Kumar',5,'General Physician'),
(18,'Dr. Anitha',5,'General Physician'),
(19,'Dr. Mohan',5,'General Physician'),
(20,'Dr. Deepa',5,'General Physician');

-- INSERT PATIENTS (200 RECORDS)

INSERT INTO Patients
(Patient_ID, Patient_Name, Gender, Age, City, Contact_No)
SELECT
g,
'Patient_' || g,
CASE WHEN g % 2 = 0 THEN 'Female' ELSE 'Male' END,
18 + (g % 60),
CASE
WHEN g % 5 = 0 THEN 'Chennai'
WHEN g % 5 = 1 THEN 'Coimbatore'
WHEN g % 5 = 2 THEN 'Madurai'
WHEN g % 5 = 3 THEN 'Trichy'
ELSE 'Salem'
END,
'98765' || LPAD(g::text,5,'0')
FROM generate_series(1,200) g;

-- INSERT ADMISSIONS (500 RECORDS)


INSERT INTO Admissions
(Admission_ID, Patient_ID, Doctor_ID, Department_ID,
Admission_Date, Discharge_Date, Diagnosis)
SELECT
g,
((g-1)%200)+1,
((g-1)%20)+1,
((g-1)%5)+1,
CURRENT_DATE-(g%365),
CURRENT_DATE-(g%365)+5,
'Diagnosis_'||g
FROM generate_series(1,500) g;

-- INSERT BILLING (500 RECORDS)

INSERT INTO Billing
(Billing_ID, Admission_ID, Treatment_Cost,
Medicine_Cost, Room_Charge,
Total_Amount, Payment_Status)
SELECT
g,
g,
(5000+random()*10000)::numeric(10,2),
(1000+random()*5000)::numeric(10,2),
(2000+random()*7000)::numeric(10,2),
(8000+random()*22000)::numeric(10,2),
CASE
WHEN g%3=0 THEN 'Paid'
WHEN g%3=1 THEN 'Pending'
ELSE 'Partially Paid'
END
FROM generate_series(1,500) g;


-- Total Patients Count

SELECT COUNT(*) AS Total_Patients 
FROM Patients;

-- Total Admissions Count

SELECT COUNT(*) AS Total_Admissions 
FROM Admissions;

-- Total Revenue

SELECT SUM(Total_Amount) AS Total_Revenue 
FROM Billing;

-- Average Treatment Cost

SELECT ROUND(AVG(Treatment_Cost), 2) AS Average_Treatment_Cost 
FROM Billing;

-- Top Doctors

SELECT
    d.Doctor_Name,
    COUNT(a.Admission_ID) AS Patients_Treated,
    SUM(b.Total_Amount) AS Revenue_Generated
FROM Doctors d
JOIN Admissions a ON d.Doctor_ID = a.Doctor_ID
JOIN Billing b ON a.Admission_ID = b.Admission_ID
GROUP BY d.Doctor_Name
ORDER BY Revenue_Generated DESC
LIMIT 5;

-- Department Performance

SELECT 
    dp.Department_Name,
    COUNT(a.Admission_ID) AS Total_Admissions,
    SUM(b.Total_Amount) AS Total_Revenue,
    ROUND(AVG(b.Room_Charge), 2) AS Avg_Room_Charge
FROM Departments dp
JOIN Doctors d ON dp.Department_ID = d.Department_ID
JOIN Admissions a ON d.Doctor_ID = a.Doctor_ID
JOIN Billing b ON a.Admission_ID = b.Admission_ID
GROUP BY dp.Department_Name
ORDER BY Total_Revenue DESC;

-- Doctors Wise Revenue

Select d.Doctor_Name ,sum(r.Total_Amount) as Total_Revenue
from Departments dp
JOIN Doctors d
ON dp.Department_ID=d.Department_ID
JOIN Admissions a
ON d.Department_ID= a.Department_ID
JOIN Billing r
ON a.Admission_ID=r.Admission_ID
group by Doctor_Name
order by Total_Revenue DESC;

-- Department Wise Revenue

SELECT dp.Department_Name,SUM(b.Total_Amount) AS Revenue
FROM Departments dp
JOIN Doctors d
ON dp.Department_ID = d.Department_ID
JOIN Admissions a
ON d.Doctor_ID = a.Doctor_ID
JOIN Billing b
ON a.Admission_ID = b.Admission_ID
GROUP BY dp.Department_Name
ORDER BY Revenue DESC;

-- Month Wise Revenue Trends

SELECT 
    TO_CHAR(Admission_Date, 'YYYY-MM') AS Year_Month,
    COUNT(a.Admission_ID) AS Monthly_Admissions,
    SUM(b.Total_Amount) AS Monthly_Revenue
FROM Admissions a
JOIN Billing b ON a.Admission_ID = b.Admission_ID
GROUP BY TO_CHAR(Admission_Date, 'YYYY-MM')
ORDER BY Year_Month ASC;


