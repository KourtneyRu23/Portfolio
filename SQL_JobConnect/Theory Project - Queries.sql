---------------------------------- NAME: TO NU QUYNH NHU ----------------------------------
------------------------------------ STUDENT ID: 210117 -----------------------------------

---------------------------------- Basic Query ----------------------------------

-- Question 1: Get Employees'names and their addresses --
SELECT Name, Email 
FROM JobConnect..Employees

-- Question 2: Get opening jobs --
SELECT JobName 
FROM JobConnect..Jobs 
WHERE JobStatus = 'open'

-- Question 3: Count the number of applications for each job --
SELECT JobCode, COUNT(*) AS ApplicationCount 
FROM JobConnect..Applications 
GROUP BY JobCode

-- Question 4: Get the companies' names and their fields --
SELECT C.CompanyName, F.FieldName 
FROM JobConnect..Companies C, JobConnect..CompanyFields F
WHERE C.CompanyFieldCode = F.FieldCode

-- Question 5: Get the feedback details (date and content) for each application --
SELECT FeedbackContent, FeedbackDate 
FROM JobConnect..FeedbackForms

---------------------------------- Nested Enquiries ----------------------------------

-- Question 1: Get employees who applied for jobs --
SELECT * 
FROM JobConnect..Employees E
WHERE E.EmployeeCode 
IN (SELECT DISTINCT EmployeeCode FROM JobConnect..Applications)

-- Question 2: Find the job which has the most applications --
SELECT JobCode, JobName 
FROM JobConnect..Jobs
WHERE JobCode = (SELECT TOP 1 JobCode FROM JobConnect..Applications GROUP BY JobCode ORDER BY COUNT(*) DESC)

-- Question 3: Get employees who applied for more than 1 job --
SELECT *
FROM JobConnect..Employees
WHERE EmployeeCode IN (SELECT EmployeeCode FROM JobConnect..Applications GROUP BY EmployeeCode HAVING COUNT(DISTINCT JobCode) > 1)


-- Question 4: Get applications that are feedbacked --
SELECT * 
FROM JobConnect..Applications
WHERE ApplicationCode IN (SELECT DISTINCT ApplicationCode FROM JobConnect..FeedbackForms)

-- Question 5: Find the MBTI types of employees who applied for jobs at 'Tech Solutions Inc.' --
SELECT EmployeeCode, MBTIType 
FROM JobConnect..MBTITestResults
WHERE EmployeeCode IN (SELECT A.EmployeeCode FROM JobConnect..Applications A, JobConnect..Jobs J
                      WHERE A.JobCode = J.JobCode AND J.CompanyCode = 1)

---------------------------------- Joining Enquiries ----------------------------------

-- Question 1: Get employees who applied for a job and the job they are applying for --
SELECT E.EmployeeCode, E.Name, J.JobName
FROM JobConnect..Employees E, JobConnect..Applications A, JobConnect..Jobs J
WHERE E.EmployeeCode = A.EmployeeCode
AND A.JobCode = J.JobCode

-- Question 2: Get feedbacks and the companies that give the feedbacks --
SELECT C.CompanyName, F.*
FROM JobConnect..FeedbackForms F, JobConnect..Companies C
WHERE F.CompanyCode = C.CompanyCode

-- Question 3: Get employees, their applications, and the corresponding job details --
SELECT E.*, A.ApplicationDate, A.ApplicationStatus, J.JobName, J.JobDescription, J.JobStatus
FROM JobConnect..Employees E, JobConnect..Applications A, JobConnect..Jobs J
WHERE E.EmployeeCode = A.EmployeeCode
AND A.JobCode = J.JobCode

-- Question 4: Get the MBTI types and personalities of employees --
SELECT R.*, P.PersonalityName
FROM JobConnect..MBTITestResults R, JobConnect..MBTIPersonalities P
WHERE R.MBTIType = P.MBTICode

-- Question 5: Job applications and their corresponding fields --
SELECT A.*, F.FieldName
FROM JobConnect..Applications A, JobConnect..CompanyFields F, JobConnect..Jobs J, JobConnect..Companies C
WHERE A.JobCode = J.JobCode
AND J.CompanyCode = C.CompanyCode
AND C.CompanyFieldCode = F.FieldCode

---------------------------------- Grouping Enquiries ----------------------------------

-- Question 1: Jobs with fewer than 2 applications and their application count. --
SELECT JobCode, COUNT(*) AS ApplicationCount
FROM JobConnect..Applications
GROUP BY JobCode
HAVING COUNT(*) <= 2

-- Question 2: Most common MBTI personality --
SELECT TOP 1 MBTIType, COUNT(*) AS EmployeeCount
FROM JobConnect..MBTITestResults 
GROUP BY MBTIType
ORDER BY EmployeeCount DESC 

-- Question 3: Find the most common job status for each job --
SELECT J.JobCode, J.JobStatus, COUNT(*) AS StatusCount
FROM JobConnect..Jobs J, JobConnect..Applications A
WHERE J.JobCode = A.JobCode
GROUP BY J.JobCode, J.JobStatus
ORDER BY StatusCount DESC

-- Question 4: Find the job with the highest number of accepted applicants --
SELECT TOP 1 JobCode, COUNT(*) AS AcceptedApplicationsCount
FROM JobConnect..Applications
WHERE ApplicationStatus = 'accepted'
GROUP BY JobCode
ORDER BY AcceptedApplicationsCount DESC

-- Question 5: Find the most common interview location for each company --
SELECT C.CompanyCode, I.InterviewLocation, COUNT(*) AS LocationCount
FROM JobConnect..InterviewSchedules I, JobConnect..Companies C
WHERE I.CompanyCode = C.CompanyCode
GROUP BY C.CompanyCode, I.InterviewLocation
ORDER BY LocationCount DESC


SELECT * FROM JobConnect..Employees
SELECT * FROM JobConnect..Companies
SELECT * FROM JobConnect..Applications
SELECT * FROM JobConnect..InterviewSchedules
SELECT * FROM JobConnect..FeedbackForms
SELECT * FROM JobConnect..CompanyFields
SELECT * FROM JobConnect..Professions
SELECT * FROM JobConnect..Jobs
SELECT * FROM JobConnect..MBTIPersonalities
SELECT * FROM JobConnect..MBTITestResults





