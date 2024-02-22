---------- STUDENT NAME: TO NU QUYNH NHU ----------
-------------- STUDENT ID: 210117 -----------------

-- Question 1: Write a trigger that when added, updated or deleted an Application, print: "Application has been successfully updated." --

CREATE TRIGGER ApplicationUpdate
ON JobConnect..Applications
AFTER INSERT, UPDATE, DELETE
AS
	BEGIN 
		PRINT ('Application has been successfully updated')
	END


-- Question 2: Insert row <3, 'X Studio', '105 Ton Dat Tien', 2019, 'CEO Mark Zuckerberg', 3, 'Account', 'info@xstudio.com', '5558889990'> into Companies table. --

CREATE PROCEDURE InsertCompany
    @company_code	INT,
	@company_name	VARCHAR(100),
	@companyaddress	VARCHAR(100),
	@year			SMALLINT,
	@company_head	VARCHAR(100),
	@companyfield	INT,
	@companyscope	VARCHAR(100),
	@companyemail	VARCHAR(100),
	@companyphone	VARCHAR(10)
AS
BEGIN
    DECLARE @company_code_count INT
	DECLARE @company_field_count INT
    -- Check constraints before insertion

	-- Check if company code already exists --
	SELECT @company_code_count = COUNT(*) FROM JobConnect..Companies WHERE CompanyCode = @company_code
	IF @company_code_count <> 0
		BEGIN
			PRINT('Company Code already existed.')
			RETURN
		END

	-- Check if company's establishment year is in the past --
    IF @year >= YEAR(GETDATE())
		BEGIN
			PRINT('Establishment year must be in the past')
			RETURN
		END

	-- Check if company field code exists --
	SELECT @company_field_count = COUNT(*) FROM JobConnect..CompanyFields WHERE FieldCode = @companyfield
	IF @company_field_count = 0
		BEGIN
			PRINT('Company Field does not exist')
			RETURN
		END

	-- Check if company's email is valid --
	IF @companyemail NOT LIKE '%@%.com%'
		BEGIN
			PRINT('Company email is not valid')
			RETURN
		END

    -- Constraints are satisfied, proceed with insertion
    INSERT INTO JobConnect..Companies (CompanyCode, CompanyName, CompanyAddress, YearOfEstablishment, CompanyHead, 
										CompanyFieldCode, CompanyScope, CompanyEmail, CompanyPhoneNumber)
    VALUES (@company_code, @company_name, @companyaddress, @year, @company_head, @companyfield, @companyscope, @companyemail, @companyphone)

    PRINT('Company inserted successfully')
END

EXECUTE InsertCompany 3, 'X Studio', '105 Ton Dat Tien', 2019, 'CEO Mark Zuckerberg', 3, 'Account', 'info@xstudio.com', '5558889990'


-- Question 3: Update Jobs table, setting all rows where CompanyCode is 1 and JobStatus = ‘open’ to 'close' --

CREATE PROCEDURE UpdateJobsStatus
	@targetcompany	INT,
    @newstatus		VARCHAR(20)
AS
BEGIN
    DECLARE @targetcompany_count INT

	-- Check if the target company exists and has ever posted a job --
    SELECT @targetcompany_count = COUNT(*) FROM JobConnect..Jobs WHERE CompanyCode = @targetcompany
    IF @targetcompany_count = 0
		BEGIN
			PRINT('Company does not exist or has not posted any jobs')
			RETURN
		END

    UPDATE JobConnect..Jobs
    SET JobStatus = @newstatus
    WHERE CompanyCode = @targetcompany

    PRINT('Job status updated successfully')
END

EXECUTE UpdateJobsStatus 1, 'closed'


-- Question 4: Delete employee from Employees table where EmployeeCode = 2. --

CREATE PROCEDURE DeleteEmployee
    @EmployeeCode INT
AS
BEGIN
    DECLARE @employee_check INT

	-- Check if Employee exists --
    SELECT @employee_check = EmployeeCode FROM JobConnect..Employees WHERE EmployeeCode = @EmployeeCode
    IF @employee_check IS NULL
		BEGIN
			PRINT('Employee does not exist.')
			RETURN
		END
	ELSE
		BEGIN

		-- Delete from FeedbackForms table first --
		    DELETE FROM FeedbackForms WHERE EmployeeCode = @EmployeeCode

		-- Delete from Applications table --
			DELETE FROM Applications WHERE EmployeeCode = @EmployeeCode
			
		-- Delete from InterviewSchedules table --
			DELETE FROM InterviewSchedules WHERE EmployeeCode = @EmployeeCode

		-- Delete from MBTITestResults table --
			DELETE FROM MBTITestResults WHERE EmployeeCode = @EmployeeCode;

		-- Delete the employee
			DELETE FROM Employees WHERE EmployeeCode = @EmployeeCode;
		END

    PRINT 'Employee has been deleted successfully.'
END

EXECUTE DeleteEmployee 2




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