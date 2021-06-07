BEGIN TRANSACTION;
CREATE TABLE "Account" (
	id INTEGER NOT NULL, 
	"Name" VARCHAR(255), 
	"AccountNumber" VARCHAR(255),
	"Site" VARCHAR(255),
	"Type" VARCHAR(255),
	"Industry" VARCHAR(255),
	"AnnualRevenue" VARCHAR(255),
	"Rating" VARCHAR(255),
	"Phone" VARCHAR(255),
	"Fax" VARCHAR(255),
	"Website" VARCHAR(255),
	"Ownership" VARCHAR(255),
	"Sic" VARCHAR(255),
	"TickerSymbol" VARCHAR(255),
	"BillingStreet" VARCHAR(255),
	"BillingCity" VARCHAR(255),
	"BillingState" VARCHAR(255),
	"BillingPostalCode" VARCHAR(255),
	"BillingCountry" VARCHAR(255),
	"ShippingStreet" VARCHAR(255),
	"ShippingCity" VARCHAR(255),
	"ShippingState" VARCHAR(255),
	"ShippingPostalCode" VARCHAR(255),
	"ShippingCountry" VARCHAR(255),
	"Description" VARCHAR(255),
	PRIMARY KEY (id)
);
INSERT INTO "Account" VALUES(1,'Sample Account for Entitlements','','','','','','','','','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(2,'Grantwood City Council','','','Customer - Direct','Government','','','970-555-9633','','','','','','445 North Peak Road','Grantwood','Colorado','80522','United States','','','','','','');
INSERT INTO "Account" VALUES(3,'Takagawa Institute','','','Customer - Direct','Not For Profit','','','602-555-3542','','','','','','9833 Plateau Street','Phoenix','Arizona','85310','United States','','','','','','');
INSERT INTO "Account" VALUES(4,'Outbound Funds Portal: Self-Registered','','','','','','','','','','','','','','','','','','','','','','','Account initially assigned to self-registered users for the Outbound Funds Portal Experiences Site');
INSERT INTO "Account" VALUES(5,'Hillside Elementary','','','Customer - Direct','Education','','','719-555-9914','','','','','','713 S. 8th Street','Englewood','Colorado','80110','United States','','','','','','');
INSERT INTO "Account" VALUES(6,'STEPS','','','Customer - Direct','Not For Profit','','','303-555-7541','','','','','','2920 Juniper Drive','Denver','Colorado','80230','United States','','','','','','');
CREATE TABLE "Contact" (
	id INTEGER NOT NULL,
	"Salutation" VARCHAR(255),
	"FirstName" VARCHAR(255),
	"LastName" VARCHAR(255),
	"Title" VARCHAR(255),
	"Email" VARCHAR(255),
	"Department" VARCHAR(255),
	"Birthdate" VARCHAR(255),
	"LeadSource" VARCHAR(255),
	"Phone" VARCHAR(255),
	"HomePhone" VARCHAR(255),
	"OtherPhone" VARCHAR(255),
	"Fax" VARCHAR(255),
	"AssistantName" VARCHAR(255),
	"AssistantPhone" VARCHAR(255),
	"MailingStreet" VARCHAR(255),
	"MailingCity" VARCHAR(255),
	"MailingState" VARCHAR(255),
	"MailingPostalCode" VARCHAR(255),
	"MailingCountry" VARCHAR(255),
	"OtherStreet" VARCHAR(255),
	"OtherCity" VARCHAR(255),
	"OtherState" VARCHAR(255),
	"OtherPostalCode" VARCHAR(255),
	"OtherCountry" VARCHAR(255),
	"Description" VARCHAR(255),
	account_id VARCHAR(255),
	reports_to_id VARCHAR(255),
	PRIMARY KEY (id)
);
INSERT INTO "Contact" VALUES(1,'Mr.','Dillon','Whitaker','Assistant City Manager','dillon.whitaker@gwcity.example.com','','','','719-555-2417','','','','','','445 North Peak Road','Grantwood','Colorado','80522','United States','','','','','','','2','');
INSERT INTO "Contact" VALUES(2,'Ms.','Adriana','Atterberry','Grants Manager','adriana.atterberry@takagawa-institute.example.com','','','','602-555-3543','','','','','','9834 Plateau Street','Phoenix','Arizona','85310','United States','','','','','','','3','3');
INSERT INTO "Contact" VALUES(3,'Dr.','Meiko','Takagawa','Executive Director','meiko.takagawa@takagawa-institute.example.com','','','','602-555-3542','','','','','','9833 Plateau Street','Phoenix','Arizona','85310','United States','','','','','','','3','');
INSERT INTO "Contact" VALUES(4,'Mr.','Devon','Berger','Literacy Coach','devon.berger@hillside-elementary.example.com','','','','719-555-9914','','','','','','713 S. 8th Street','Englewood','Colorado','80110','United States','','','','','','','5','');
INSERT INTO "Contact" VALUES(5,'Ms.','Ellen','Perez','Program Coordinator','ellen.perez@steps.example.com','','','','303-555-7541','','','','','','2920 Juniper Drive','Denver','Colorado','80230','United States','','','','','','','6','6');
INSERT INTO "Contact" VALUES(6,'Ms.','Grace','Walker','Development Director','grace.walker@steps.example.com','','','','303-555-7540','','','','','','2920 Juniper Drive','Denver','Colorado','80230','United States','','','','','','','6','');
INSERT INTO "Contact" VALUES(7,'Mr.','Jermaine','Harmon','Intern','jermaine.harmon@steps.example.com','','','','303-555-7540','','','','','','2920 Juniper Drive','Denver','Colorado','80230','United States','','','','','','','6','');
CREATE TABLE "Disbursement__c" (
	id INTEGER NOT NULL,
	"Amount__c" VARCHAR(255),
	"Disbursement_Date__c" VARCHAR(255),
	"Disbursement_Method__c" VARCHAR(255),
	"Scheduled_Date__c" VARCHAR(255),
	"Status__c" VARCHAR(255),
	"Type__c" VARCHAR(255),
	Funding_Request__c VARCHAR(255),
	PRIMARY KEY (id)
);
INSERT INTO "Disbursement__c" VALUES(1,'40000.0','2019-05-14','EFT','2019-05-14','Paid','Final','5');
INSERT INTO "Disbursement__c" VALUES(2,'10000.0','2020-03-28','EFT','2020-03-28','Paid','Initial','2');
INSERT INTO "Disbursement__c" VALUES(3,'5000.0','2019-07-09','EFT','2019-07-09','Paid','Initial','3');
INSERT INTO "Disbursement__c" VALUES(4,'5000.0','2020-07-09','','2020-07-09','Paid','Interim','3');
INSERT INTO "Disbursement__c" VALUES(5,'5000.0','','EFT','2021-07-09','Scheduled','Final','3');
CREATE TABLE "Funding_Program__c" (
	id INTEGER NOT NULL,
	"Name" VARCHAR(255),
	"Description__c" VARCHAR(255),
	"End_Date__c" VARCHAR(255),
	"Start_Date__c" VARCHAR(255),
	"Status__c" VARCHAR(255),
	"Top_Level__c" VARCHAR(255),
	"Total_Program_Amount__c" VARCHAR(255),
	"Parent_Funding_Program__c" VARCHAR(255),
	PRIMARY KEY (id)
);
INSERT INTO "Funding_Program__c" VALUES(1,'Kumar Endowment Scholarship','The Kumar family graciously sponsors the Kumar Endowment Scholarship Fund for high school students who have made a positive impact in their local community. This fund awards $2,000 scholarships every 4 years to ten students seeking higher education. Eligible expenses include tuition, room and board, fees, and books during the academic year.','2020-07-30','2020-01-14','In progress','False','200000.0','3');
INSERT INTO "Funding_Program__c" VALUES(2,'Successful Scholars Grant','The Successful Scholars Grant provides funding to select non-profits and education institutes to enable students to excel in their academics. Past initiatives created by previous grantees include after-school tutoring, early literacy programs, and college preparation courses.','2020-08-13','2019-08-14','In progress','False','250000.0','3');
INSERT INTO "Funding_Program__c" VALUES(3,'Education','','','','In progress','True','','');
INSERT INTO "Funding_Program__c" VALUES(4,'Community Impact','','','','In progress','True','','');
INSERT INTO "Funding_Program__c" VALUES(5,'Relief and Reinvestment Grant','The Relief and Reinvestment Grant provides financial assistance in the form of grants to small businesses experiencing temporary revenue loss due to unforeseen circumstances, such as a natural disaster or economic crisis. Grants of up to $10,000 are awarded to select small businesses to help offset lost revenue. This fund can be used for:
        * Rent and utilities
        * Payroll
        * Outstanding debt
        * Technology upgrades
        * Immediate operation costs','2021-01-30','2020-01-31','In progress','False','300000.0','4');
INSERT INTO "Funding_Program__c" VALUES(6,'Strategic Nonprofit Development','','','','Planned','True','','');
CREATE TABLE "Funding_Request_Role__c" (
	id INTEGER NOT NULL,
	"Role__c" VARCHAR(255),
	"Status__c" VARCHAR(255),
	"Contact__c" VARCHAR(255),
	"Funding_Request__c" VARCHAR(255),
	PRIMARY KEY (id)
);
INSERT INTO "Funding_Request_Role__c" VALUES(1,'Applicant','Current','3','2');
INSERT INTO "Funding_Request_Role__c" VALUES(2,'Applicant','Former','7','5');
INSERT INTO "Funding_Request_Role__c" VALUES(3,'Grant Manager','Current','2','2');
CREATE TABLE "Funding_Request__c" (
	id INTEGER NOT NULL,
	"Name" VARCHAR(255),
	"Application_Date__c" VARCHAR(255),
	"Awarded_Amount__c" VARCHAR(255),
	"Awarded_Date__c" VARCHAR(255),
	"Close_Date__c" VARCHAR(255),
	"Closed_reason__c" VARCHAR(255),
	"Geographical_Area_Served__c" VARCHAR(255),
	"Population_Served__c" VARCHAR(255),
	"Recommended_Amount__c" VARCHAR(255),
	"Requested_Amount__c" VARCHAR(255),
	"Requested_For__c" VARCHAR(255),
	"Status__c" VARCHAR(255),
	"Term_End_Date__c" VARCHAR(255),
	"Term_Start_Date__c" VARCHAR(255),
	"Terms__c" VARCHAR(255),
	"Applying_Contact__c" VARCHAR(255),
	"Applying_Organization__c" VARCHAR(255),
	"FundingProgram__c" VARCHAR(255),
	PRIMARY KEY (id)
);
INSERT INTO "Funding_Request__c" VALUES(1,'Grantwood City Food Bank','','','','','','City','Below Poverty level;Economically Disadvantaged People;Homeless','','100000.0','Grantwood City Food Bank','In progress','','','','','2','4');
INSERT INTO "Funding_Request__c" VALUES(2,'Takagawa Institute: Relief and Reinvestment Grant','2020-03-11','10000.0','2020-03-28','2020-03-28','Fully awarded.','Country','Immigrants and Refugees','10000.0','10000.0','','Fully Disbursed','2021-03-27','2020-03-28','One time payment with one year follow up','3','3','5');
INSERT INTO "Funding_Request__c" VALUES(3,'Eager Beavers Read!','2019-04-25','15000.0','2019-07-09','','','City','Children and Youth','15000.0','15000.0','Eager Beavers Read! is an after school program that helps foster a love of reading in our 1st - 5th grade classes and also provides a safe place for students to go between 3:00 pm and 4:30 pm. Younger children will be paired up with an older student to help expand their early literacy skills, while older students work to develop mentoring skills and confidence.','Awarded','2022-08-13','2019-08-14','3 years','4','5','2');
INSERT INTO "Funding_Request__c" VALUES(4,'STEPS to Leadership','2020-02-16','28000.0','','','','Region','Adults;Women','28000.0','28000.0','STEPS to Leadership is a proposed program that came from requests for additional leadership training for our graduates from Skills for Success, a successful program we currently offer to at-risk women in the community. After completing Skills for Success, graduates can learn leadership skills through various trainings, seminars, and one-on-one mentoring that will help prepare these future female leaders.','Submitted','','','','5','6','4');
INSERT INTO "Funding_Request__c" VALUES(5,'Skills for Success','2019-03-21','40000.0','2019-05-14','','','Region','Adults;Women','40000.0','40000.0','Skills for Success addresses an existing gap for at-risk women seeking to learn technical and soft skills to help them find gainful employment in the community. Participants of the program receive:

* Vouchers for free community college courses on select topics, such as bookkeeping, computer literacy, and communication skills.
* Help developing a resume and interview preparation.
* One-on-one mentoring with a female business owner in the community.
* Ongoing support from the STEPS staff.','Awarded','2020-05-30','2019-05-31','1 year','6','6','4');
INSERT INTO "Funding_Request__c" VALUES(6,'Skills for Success','2020-05-31','','','','','Region','Adults;Women','','46000.0','Skills for Success addresses an existing gap for at-risk women seeking to learn technical and soft skills to help them find gainful employment in the community. Participants of the program receive:

* Vouchers for free community college courses on select topics, such as bookkeeping, computer literacy, and communication skills.
* Help developing a resume and interview preparation.
* One-on-one mentoring with a female business owner in the community.
* Ongoing support from the STEPS staff.','In progress','','','1 year','6','6','4');
CREATE TABLE "Requirement__c" (
	id INTEGER NOT NULL,
	"Name" VARCHAR(255),
	"Completed_Date__c" VARCHAR(255),
	"Due_Date__c" VARCHAR(255),
	"Requirements__c" VARCHAR(255),
	"Status__c" VARCHAR(255),
	"Type__c" VARCHAR(255),
	"Disbursement__c" VARCHAR(255),
	"Funding_Request__c" VARCHAR(255),
	"Primary_Contact__c" VARCHAR(255),
	PRIMARY KEY (id)
);
INSERT INTO "Requirement__c" VALUES(1,'Application','2019-03-21','2019-12-30','<p><span style="font-family: Arial; font-size: 10pt; color: rgb(0, 0, 0);">Application</span></p>','Accepted','Final Application','','5','6');
INSERT INTO "Requirement__c" VALUES(2,'Outcome Report','','2020-12-30','<p>Outcome Report</p>','Open','Outcome','','5','6');
INSERT INTO "Requirement__c" VALUES(3,'Proposed Budget','2019-03-21','2019-12-30','<p>Proposed budget</p>','Accepted','Report','','5','6');
INSERT INTO "Requirement__c" VALUES(4,'Budget Report','2020-02-11','2020-12-30','<p>Budget Report</p>','Complete','Report','','5','6');
INSERT INTO "Requirement__c" VALUES(5,'Letter of Intent','2019-03-21','2019-12-30','<p><span style="font-family: Arial; font-size: 10pt; color: rgb(0, 0, 0);">Cover letter</span></p>','Accepted','Letter of Intent','','5','6');
INSERT INTO "Requirement__c" VALUES(6,'Budget Report','','2020-09-14','<p>Budget Report</p>','Open','Report','','2','3');
INSERT INTO "Requirement__c" VALUES(7,'Outcome Report','','2021-03-31','<p>Outcome Report</p>','Open','Outcome','','2','3');
INSERT INTO "Requirement__c" VALUES(8,'Application','2020-03-11','2020-12-30','<p>Application</p>','Accepted','Final Application','','2','3');
INSERT INTO "Requirement__c" VALUES(9,'Letter of Intent','2019-04-25','2019-12-30','<p><span style="font-family: Arial; font-size: 10pt; color: rgb(0, 0, 0);">Cover letter</span></p>','Accepted','Letter of Intent','','3','4');
INSERT INTO "Requirement__c" VALUES(10,'Application','2019-04-25','2019-12-30','<p><span style="font-family: Arial; font-size: 10pt; color: rgb(0, 0, 0);">Application</span></p>','Accepted','Final Application','','3','4');
INSERT INTO "Requirement__c" VALUES(11,'Outcome Report','','2022-12-30','<p>Outcome Report</p>','Open','Outcome','','3','4');
INSERT INTO "Requirement__c" VALUES(12,'Budget Report','','2021-12-30','<p><span style="color: rgb(0, 0, 0); font-size: 10pt; font-family: Arial;">Budget Report</span></p>','Open','Report','','3','4');
CREATE TABLE "Review__c" (
	id INTEGER NOT NULL,
	"Name" VARCHAR(255),
	"Comments__c" VARCHAR(255),
	"DueDate__c" VARCHAR(255),
	"Status__c" VARCHAR(255),
	"SubmittedDate__c" VARCHAR(255),
	"FundingRequest__c" VARCHAR(255),
	PRIMARY KEY (id)
);
INSERT INTO "Review__c" VALUES(1,'Scholarship 2021-22 - Sarah Amin','<p>Need more documentation!</p>','2021-07-17','In Progress','','1');
INSERT INTO "Review__c" VALUES(2,'Review - External','','2021-04-29','Submitted','2021-04-28','2');
INSERT INTO "Review__c" VALUES(3,'Review of Application - Shari Reily - Scholarship 2021','','2021-07-30','Not Started','','3');
INSERT INTO "Review__c" VALUES(4,'Review - Program Officer','<p>Looks great!</p>','2021-04-27','Submitted','2021-04-28','2');
COMMIT;
