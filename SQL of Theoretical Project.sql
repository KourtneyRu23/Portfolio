-- Create the database
CREATE DATABASE JobConnect

------------------- Create tables for the database -------------------

-- Table for potential employees --
CREATE TABLE Employees (
    EmployeeCode			INT PRIMARY KEY,
    Name					VARCHAR(100),
    DateOfBirth				DATE,
    Address					VARCHAR(255),
    PhoneNumber				VARCHAR(10),
    Email					VARCHAR(100),
    CVLink					VARCHAR(255)
)

-- Table for companies --
CREATE TABLE Companies (
    CompanyCode				INT PRIMARY KEY,
    CompanyName				VARCHAR(100),
    CompanyAddress			VARCHAR(255),
    YearOfEstablishment		INT,
    CompanyHead				VARCHAR(100),
    CompanyFieldCode		INT,
    CompanyScope			VARCHAR(100),
    CompanyEmail			VARCHAR(100),
    CompanyPhoneNumber		VARCHAR(10)
)

-- Table for jobs --
CREATE TABLE Jobs (
    JobCode					INT PRIMARY KEY,
    JobName					VARCHAR(100),
    CompanyCode				INT,
    JobDescription			TEXT,
    JobStatus				VARCHAR(20),
    StartDate				DATE,
    EndDate					DATE
)

-- Table for job applications --
CREATE TABLE Applications (
    ApplicationCode			INT PRIMARY KEY,
    JobCode					INT,
    EmployeeCode			INT,
    ApplicationDate			DATETIME,
    ApplicationStatus		VARCHAR(20)
)

-- Table for interview schedules --
CREATE TABLE InterviewSchedules (
    InterviewCode			INT PRIMARY KEY,
    JobCode					INT,
    CompanyCode				INT,
    EmployeeCode			INT,
    InterviewDateTime		DATETIME,
    InterviewLocation		VARCHAR(255),
    EmployeeResponse		VARCHAR(20)
)

-- Table for feedback forms --
CREATE TABLE FeedbackForms (
    FeedbackCode			INT PRIMARY KEY,
    ApplicationCode			INT,
    CompanyCode				INT,
    EmployeeCode			INT,
    FeedbackContent			TEXT,
    FeedbackDate			DATETIME
)

-- Table for MBTI test results --
CREATE TABLE MBTITestResults (
    EmployeeCode INT PRIMARY KEY,
    MBTIType VARCHAR(4),
    PersonalityDescription TEXT,
    SuggestedCareers TEXT
)

-- Table for MBTI personalities --
CREATE TABLE MBTIPersonalities (
    MBTICode VARCHAR(4) PRIMARY KEY,
    PersonalityName VARCHAR(100),
    TypicalCharacteristics TEXT
)

-- Table for professions --
CREATE TABLE Professions (
    ProfessionCode INT PRIMARY KEY,
    ProfessionName VARCHAR(100)
)

-- Table for company fields --
CREATE TABLE CompanyFields (
    FieldCode INT PRIMARY KEY,
    FieldName VARCHAR(100)
)

------------------- Add constraints to the tables -------------------

-- Jobs table constraints
ALTER TABLE Jobs
ADD CONSTRAINT FK_CompanyCode FOREIGN KEY (CompanyCode)
REFERENCES Companies(CompanyCode)
ALTER TABLE Jobs
ADD CONSTRAINT CHK_JobStatus CHECK (JobStatus IN ('open','closed'))

-- Applications table constraints
ALTER TABLE Applications
ADD CONSTRAINT FK_JobCode FOREIGN KEY (JobCode)
REFERENCES Jobs(JobCode)
ALTER TABLE Applications
ADD CONSTRAINT FK_EmployeeCode FOREIGN KEY (EmployeeCode)
REFERENCES Employees(EmployeeCode);
ALTER TABLE Applications
ADD CONSTRAINT CHK_ApplicationStatus CHECK (ApplicationStatus IN ('considering', 'to-be-interviewed', 'interviewed', 'accepted', 'rejected'))

-- InterviewSchedules table constraints
ALTER TABLE InterviewSchedules
ADD CONSTRAINT FK_JobCodeInterview FOREIGN KEY (JobCode)
REFERENCES Jobs(JobCode);
ALTER TABLE InterviewSchedules
ADD CONSTRAINT FK_CompanyCodeInterview FOREIGN KEY (CompanyCode)
REFERENCES Companies(CompanyCode)
ALTER TABLE InterviewSchedules
ADD CONSTRAINT FK_EmployeeCodeInterview FOREIGN KEY (EmployeeCode)
REFERENCES Employees(EmployeeCode)
ALTER TABLE InterviewSchedules
ADD CONSTRAINT CHK_EmployeeResponse CHECK (EmployeeResponse IN ('accepted', 'rejected'))

-- FeedbackForms table constraints
ALTER TABLE FeedbackForms
ADD CONSTRAINT FK_ApplicationCodeFeedback FOREIGN KEY (ApplicationCode)
REFERENCES Applications(ApplicationCode);
ALTER TABLE FeedbackForms
ADD CONSTRAINT FK_CompanyCodeFeedback FOREIGN KEY (CompanyCode)
REFERENCES Companies(CompanyCode)
ALTER TABLE FeedbackForms
ADD CONSTRAINT FK_EmployeeCodeFeedback FOREIGN KEY (EmployeeCode)
REFERENCES Employees(EmployeeCode)

-- MBTITestResults table constraints
ALTER TABLE MBTITestResults
ADD CONSTRAINT FK_EmployeeCodeMBTI FOREIGN KEY (EmployeeCode)
REFERENCES Employees(EmployeeCode)

------------------- Insert sample data -------------------

-- Insert sample MBTI personalities --
INSERT INTO MBTIPersonalities (MBTICode, PersonalityName, TypicalCharacteristics)
VALUES
    ('ISTJ', 'The Inspector', 'Responsible, organized, and practical.'),
    ('ESTJ', 'The Supervisor', 'Dutiful, logical, and efficient.')
   

-- Insert sample professions --
INSERT INTO Professions (ProfessionCode, ProfessionName)
VALUES
    (1, 'Software Developer'),
    (2, 'Data Analyst'),
    (3, 'Sales Manager')

-- Insert sample company fields --
INSERT INTO CompanyFields (FieldCode, FieldName)
VALUES
    (1, 'Information Technology'),
    (2, 'Finance'),
    (3, 'Healthcare')

-- Insert sample employees --
INSERT INTO Employees (EmployeeCode, Name, DateOfBirth, Address, PhoneNumber, Email, CVLink)
VALUES
    (1, 'John Doe', '1990-05-15', '123 Main St', '5551234567', 'john.doe@email.com', 'cv_link_johndoe.pdf'),
    (2, 'Jane Smith', '1985-08-20', '456 Elm St', '5559876543', 'jane.smith@email.com', 'cv_link_janesmith.pdf')

-- Insert sample companies --
INSERT INTO Companies (CompanyCode, CompanyName, CompanyAddress, YearOfEstablishment, CompanyHead, CompanyFieldCode, CompanyScope, CompanyEmail, CompanyPhoneNumber)
VALUES
    (1, 'Tech Solutions Inc.', '789 Tech Blvd', 2005, 'CEO John Tech', 1, 'Software Development', 'info@techsolutions.com', '5557890123'),
    (2, 'Finance World Ltd.', '456 Finance Ave', 1998, 'CFO Sarah Finance', 2, 'Financial Services', 'info@financeworld.com', '5554567890')

-- Insert sample jobs --
INSERT INTO Jobs (JobCode, JobName, CompanyCode, JobDescription, JobStatus, StartDate, EndDate)
VALUES
    (1, 'Software Engineer', 1, 'Develop and maintain software applications.', 'open', '2023-11-01', '2023-11-15'),
    (2, 'Data Analyst', 1, 'Analyze and interpret data to drive business decisions.', 'open', '2023-11-05', '2023-11-20')

-- Insert sample job applications
INSERT INTO Applications (ApplicationCode, JobCode, EmployeeCode, ApplicationDate, ApplicationStatus)
VALUES
    (1, 1, 1, '2023-11-02 09:00:00', 'considering'),
    (2, 2, 2, '2023-11-06 14:30:00', 'to-be-interviewed')

-- Insert sample interview schedules --
INSERT INTO InterviewSchedules (InterviewCode, JobCode, CompanyCode, EmployeeCode, InterviewDateTime, InterviewLocation, EmployeeResponse)
VALUES
    (1, 1, 1, 1, '2023-11-10 10:00:00', 'Tech Solutions Office', 'accepted'),
    (2, 2, 1, 2, '2023-11-15 15:00:00', 'Tech Solutions Office', 'accepted')

-- Insert sample feedback forms --
INSERT INTO FeedbackForms (FeedbackCode, ApplicationCode, CompanyCode, EmployeeCode, FeedbackContent, FeedbackDate)
VALUES
    (1, 1, 1, 1, 'Great interview!', '2023-11-12 11:30:00'),
    (2, 2, 1, 2, 'Good candidate, but not the right fit.', '2023-11-17 16:45:00')

-- Insert sample MBTI test results --
INSERT INTO MBTITestResults (EmployeeCode, MBTIType, PersonalityDescription, SuggestedCareers)
VALUES
    (1, 'INTP', 'Innovative and logical problem solvers.', 'Software Developer, Data Scientist'),
    (2, 'ENFJ', 'Empathetic and outgoing leaders.', 'Sales Manager, HR Specialist')

------------------- See Database -------------------

SELECT * FROM Employees
SELECT * FROM Companies
SELECT * FROM Applications
SELECT * FROM InterviewSchedules
SELECT * FROM FeedbackForms
SELECT * FROM CompanyFields
SELECT * FROM Professions
SELECT * FROM Jobs
SELECT * FROM MBTIPersonalities
SELECT * FROM MBTITestResults