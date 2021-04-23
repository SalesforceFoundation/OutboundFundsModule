BEGIN TRANSACTION;
CREATE TABLE "Account" (
	id INTEGER NOT NULL, 
	"Name" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Account" VALUES(1,'Nonprofit B');
INSERT INTO "Account" VALUES(2,'salesforce.com');
INSERT INTO "Account" VALUES(3,'Nonprofit A');
INSERT INTO "Account" VALUES(4,'Nonprofit C');
INSERT INTO "Account" VALUES(5,'Bob Test');
INSERT INTO "Account" VALUES(6,'Ken Test');
INSERT INTO "Account" VALUES(7,'Lisa Test');
INSERT INTO "Account" VALUES(8,'Nancy Carlson');
INSERT INTO "Account" VALUES(9,'Operation Change the World');
INSERT INTO "Account" VALUES(10,'Shelbyville College');
INSERT INTO "Account" VALUES(11,'Wig Household');
INSERT INTO "Account" VALUES(12,'Simpson Household');
INSERT INTO "Account" VALUES(13,'Moe’s Tavern');
INSERT INTO "Account" VALUES(14,'Springfield heights institute of technology');
INSERT INTO "Account" VALUES(15,'Burns Co');
INSERT INTO "Account" VALUES(16,'Shelbyville Elementary School');
INSERT INTO "Account" VALUES(17,'Simpson Household');
INSERT INTO "Account" VALUES(18,'Reily Household');
INSERT INTO "Account" VALUES(19,'Flanders Family Foundation');
INSERT INTO "Account" VALUES(20,'Flanders Household');
INSERT INTO "Account" VALUES(21,'Large Manufacturing Corporation');
INSERT INTO "Account" VALUES(22,'Duff Brewery');
INSERT INTO "Account" VALUES(23,'Springfield Police Academy');
INSERT INTO "Account" VALUES(24,'Lindberg Household');
INSERT INTO "Account" VALUES(25,'Corkill Household');
INSERT INTO "Account" VALUES(26,'Amin Household');
INSERT INTO "Account" VALUES(27,'Contact Household');
INSERT INTO "Account" VALUES(28,'Sample Organization');
INSERT INTO "Account" VALUES(29,'Sprinfield Elementary');
INSERT INTO "Account" VALUES(30,'Wiggum Household');
INSERT INTO "Account" VALUES(31,'Global Media');
INSERT INTO "Account" VALUES(32,'Acme');
CREATE TABLE "Contact" (
	id INTEGER NOT NULL, 
	"Salutation" VARCHAR(255), 
	"FirstName" VARCHAR(255), 
	"LastName" VARCHAR(255), 
	"Email" VARCHAR(255), 
	"Phone" VARCHAR(255), 
	"Title" VARCHAR(255), 
	"AccountId" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Contact" VALUES(1,'','Jon','Amos','info@salesforce.com','(905) 555-1212','Sales Manager','31');
INSERT INTO "Contact" VALUES(2,'','Edward','Stamos','info@salesforce.com','(212) 555-5555','President and CEO','32');
INSERT INTO "Contact" VALUES(3,'','Howard','Jones','info@salesforce.com','(212) 555-5555','Buyer','32');
INSERT INTO "Contact" VALUES(4,'','Leanne','Tomlin','info@salesforce.com','(212) 555-5555','VP Customer Support','32');
INSERT INTO "Contact" VALUES(5,'','Sally','Jones','','','','4');
INSERT INTO "Contact" VALUES(6,'','Bob','Test','','','','5');
INSERT INTO "Contact" VALUES(7,'','Ken','Test','','','','6');
INSERT INTO "Contact" VALUES(8,'','Lisa','Test','shari_reily@redpathcg.com','','','7');
INSERT INTO "Contact" VALUES(9,'','Nancy','Carlson','','','','8');
INSERT INTO "Contact" VALUES(10,'','Sally','Walker','','','','9');
INSERT INTO "Contact" VALUES(11,'','Erin','Test','shari_reily@redpathcg.com','','','1');
INSERT INTO "Contact" VALUES(12,'Mr.','Big','Wig','','','CEO','11');
INSERT INTO "Contact" VALUES(13,'Mr.','Bart','Simpson','','','Child','12');
INSERT INTO "Contact" VALUES(14,'Ms.','Lisa','Simpson','','','','12');
INSERT INTO "Contact" VALUES(15,'Mrs.','Marge','Simpson','','','','12');
INSERT INTO "Contact" VALUES(16,'Mr.','Moe','Szyslak','','','Owner','13');
INSERT INTO "Contact" VALUES(17,'Prof.','John','Frink','','','Professor','14');
INSERT INTO "Contact" VALUES(18,'Mr.','Montgomery','Burns','','','','15');
INSERT INTO "Contact" VALUES(19,'','Carol','Shelby','','','','16');
INSERT INTO "Contact" VALUES(20,'','Homer','Simpson','','','','17');
INSERT INTO "Contact" VALUES(21,'','Shari','Reily','','','','18');
INSERT INTO "Contact" VALUES(22,'Mr.','Marc','Benioff','info@salesforce.com','(415) 901-7000','Executive Officer','2');
INSERT INTO "Contact" VALUES(23,'Mr.','Ned','Flanders','test@test.com','','','20');
INSERT INTO "Contact" VALUES(24,'Mr.','Todd','Flanders','','','','20');
INSERT INTO "Contact" VALUES(25,'Mr.','Rod','Flanders','','','','20');
INSERT INTO "Contact" VALUES(26,'Mr.','Duff','Man','','','The King Of Beers','22');
INSERT INTO "Contact" VALUES(27,'Mr.','Clerance','Wiggum','chief@spinfieldpd.fake','911','Police Chief','23');
INSERT INTO "Contact" VALUES(28,'','Nick','Lindberg','','','','24');
INSERT INTO "Contact" VALUES(29,'','Bill','Corkill','','','','25');
INSERT INTO "Contact" VALUES(30,'Ms.','Sarah','Amin','','','','26');
INSERT INTO "Contact" VALUES(31,'','Sample','Contact','sample.contact@email.com','(202) 555-9654','CEO','27');
INSERT INTO "Contact" VALUES(32,'','Seymour','Skinner','','','','29');
INSERT INTO "Contact" VALUES(33,'Mr.','Ralph','Wiggum','','','','30');
INSERT INTO "Contact" VALUES(34,'','Geoff','Minor','info@salesforce.com','(415) 555-1212','President','31');
INSERT INTO "Contact" VALUES(35,'','Carole','White','info@salesforce.com','(415) 555-1212','VP Sales','31');
CREATE TABLE "Disbursement__c" (
	id INTEGER NOT NULL, 
	"Amount__c" VARCHAR(255), 
	"Disbursement_Date__c" VARCHAR(255), 
	"Disbursement_Method__c" VARCHAR(255), 
	"Scheduled_Date__c" VARCHAR(255), 
	"Status__c" VARCHAR(255), 
	"Type__c" VARCHAR(255), 
	"Funding_Request__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Disbursement__c" VALUES(1,'6000.0','2020-07-15','Cash','2020-06-01','Paid','Initial','1');
INSERT INTO "Disbursement__c" VALUES(2,'4000.0','','Cash','2020-10-11','Scheduled','Interim','1');
INSERT INTO "Disbursement__c" VALUES(3,'2546.0','','Cash','2021-02-15','Scheduled','Final','1');
INSERT INTO "Disbursement__c" VALUES(4,'7000.0','2018-06-06','Cash','2018-06-06','Paid','Final','6');
INSERT INTO "Disbursement__c" VALUES(5,'15000.0','2017-08-01','Check','2017-08-01','Paid','Initial','8');
INSERT INTO "Disbursement__c" VALUES(6,'5000.0','','EFT','2020-08-01','Scheduled','Initial','9');
INSERT INTO "Disbursement__c" VALUES(7,'20000.0','','Check','2020-10-01','Scheduled','Interim','9');
INSERT INTO "Disbursement__c" VALUES(8,'10000.0','','Check','2020-12-01','Scheduled','Interim','9');
INSERT INTO "Disbursement__c" VALUES(9,'10000.0','','Check','2021-01-01','Scheduled','Interim','9');
INSERT INTO "Disbursement__c" VALUES(10,'10000.0','','Check','2021-03-01','Scheduled','Interim','9');
INSERT INTO "Disbursement__c" VALUES(11,'50000.0','','Check','2019-05-01','Scheduled','Final','9');
INSERT INTO "Disbursement__c" VALUES(12,'25000.0','2018-07-13','Check','2020-07-15','Paid','Initial','13');
INSERT INTO "Disbursement__c" VALUES(13,'10000.0','','Check','2020-11-15','Scheduled','Interim','13');
INSERT INTO "Disbursement__c" VALUES(14,'15000.0','','Check','2021-02-15','Scheduled','Interim','13');
INSERT INTO "Disbursement__c" VALUES(15,'50000.0','','EFT','2020-12-15','Approved','Initial','15');
INSERT INTO "Disbursement__c" VALUES(16,'10000.0','','EFT','2021-01-01','Scheduled','Interim','15');
INSERT INTO "Disbursement__c" VALUES(17,'10000.0','','EFT','2021-02-01','Scheduled','Interim','15');
INSERT INTO "Disbursement__c" VALUES(18,'10000.0','','EFT','2021-03-01','Scheduled','Interim','15');
INSERT INTO "Disbursement__c" VALUES(19,'10000.0','','EFT','2021-04-01','Scheduled','Interim','15');
INSERT INTO "Disbursement__c" VALUES(20,'10000.0','','EFT','2021-05-01','Scheduled','Final','15');
INSERT INTO "Disbursement__c" VALUES(21,'2000.0','','Check','2021-01-01','Paid','Initial','4');
INSERT INTO "Disbursement__c" VALUES(22,'1000.0','','Check','2021-02-01','Scheduled','Interim','4');
INSERT INTO "Disbursement__c" VALUES(23,'2000.0','','Check','2021-04-01','Scheduled','Final','4');
INSERT INTO "Disbursement__c" VALUES(24,'5000.0','','EFT','2021-01-01','Scheduled','Initial','11');
INSERT INTO "Disbursement__c" VALUES(25,'50000.0','','EFT','2021-02-01','Scheduled','Interim','11');
INSERT INTO "Disbursement__c" VALUES(26,'50000.0','','EFT','2021-03-01','Scheduled','Final','11');
INSERT INTO "Disbursement__c" VALUES(27,'20000.0','','EFT','2021-07-31','Pending Approval','Initial','5');
INSERT INTO "Disbursement__c" VALUES(28,'20000.0','','EFT','2021-12-01','Scheduled','Final','5');
INSERT INTO "Disbursement__c" VALUES(29,'1000.0','','','2021-04-01','Pending Approval','Final','17');
INSERT INTO "Disbursement__c" VALUES(30,'1000.0','2018-05-31','EFT','2018-06-01','Approved','Initial','17');
INSERT INTO "Disbursement__c" VALUES(31,'1000.0','2018-05-31','EFT','2021-01-01','Scheduled','Interim','17');
INSERT INTO "Disbursement__c" VALUES(32,'1000.0','2018-05-31','EFT','2021-03-01','Scheduled','Interim','17');
INSERT INTO "Disbursement__c" VALUES(33,'10000.0','','EFT','2018-09-01','Paid','Final','7');
INSERT INTO "Disbursement__c" VALUES(34,'5000.0','2018-05-14','EFT','2018-05-11','Paid','Initial','7');
INSERT INTO "Disbursement__c" VALUES(35,'833.34','','','2021-05-01','Scheduled','','19');
INSERT INTO "Disbursement__c" VALUES(36,'833.34','','','2021-05-22','Scheduled','','19');
INSERT INTO "Disbursement__c" VALUES(37,'833.34','','','2021-06-12','Scheduled','','19');
INSERT INTO "Disbursement__c" VALUES(38,'833.34','','','2021-07-03','Scheduled','','19');
INSERT INTO "Disbursement__c" VALUES(39,'833.33','','','2021-07-24','Scheduled','','19');
INSERT INTO "Disbursement__c" VALUES(40,'833.33','','','2021-08-14','Scheduled','','19');
INSERT INTO "Disbursement__c" VALUES(41,'833.33','','','2021-09-04','Scheduled','','19');
INSERT INTO "Disbursement__c" VALUES(42,'833.33','','','2021-09-25','Scheduled','','19');
INSERT INTO "Disbursement__c" VALUES(43,'833.33','','','2021-10-16','Scheduled','','19');
INSERT INTO "Disbursement__c" VALUES(44,'833.33','','','2021-11-06','Scheduled','','19');
INSERT INTO "Disbursement__c" VALUES(45,'833.33','','','2021-11-27','Scheduled','','19');
INSERT INTO "Disbursement__c" VALUES(46,'833.33','','','2021-12-18','Scheduled','','19');
INSERT INTO "Disbursement__c" VALUES(47,'1000.0','','','2021-04-20','Scheduled','','20');
INSERT INTO "Disbursement__c" VALUES(48,'1000.0','','','2021-05-20','Scheduled','','20');
INSERT INTO "Disbursement__c" VALUES(49,'1000.0','','','2021-06-20','Scheduled','','20');
INSERT INTO "Disbursement__c" VALUES(50,'1000.0','','','2021-07-20','Scheduled','','20');
INSERT INTO "Disbursement__c" VALUES(51,'1000.0','','','2021-08-20','Scheduled','','20');
INSERT INTO "Disbursement__c" VALUES(52,'1000.0','','','2021-09-20','Scheduled','','20');
INSERT INTO "Disbursement__c" VALUES(53,'1000.0','','','2021-10-20','Scheduled','','20');
INSERT INTO "Disbursement__c" VALUES(54,'1000.0','','','2021-11-19','Scheduled','','20');
INSERT INTO "Disbursement__c" VALUES(55,'1000.0','','','2021-12-19','Scheduled','','20');
INSERT INTO "Disbursement__c" VALUES(56,'1000.0','','','2022-01-19','Scheduled','','20');
CREATE TABLE "Funding_Program__c" (
	id INTEGER NOT NULL, 
	"Name" VARCHAR(255), 
	"Description__c" VARCHAR(255), 
	"End_Date__c" VARCHAR(255), 
	"Start_Date__c" VARCHAR(255), 
	"Status__c" VARCHAR(255), 
	"Total_Program_Amount__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Funding_Program__c" VALUES(1,'Research Scholarship','','','','In progress','');
INSERT INTO "Funding_Program__c" VALUES(2,'2017-2018 Research Scholarships','','2018-07-31','2017-08-01','In progress','500000.0');
INSERT INTO "Funding_Program__c" VALUES(3,'2018-2019 Research Scholarship','','2019-07-31','2018-08-01','Planned','600000.0');
INSERT INTO "Funding_Program__c" VALUES(4,'Community Support','Main Community Support program','','2018-01-01','In progress','');
INSERT INTO "Funding_Program__c" VALUES(5,'2021 Community Support','2021 Community Support','2021-12-31','2022-01-01','Planned','100000.0');
INSERT INTO "Funding_Program__c" VALUES(6,'Individual Fellowship','','','2018-01-01','In progress','');
INSERT INTO "Funding_Program__c" VALUES(7,'2018 Individual Fellowship','','','2018-01-01','In progress','1000000.0');
INSERT INTO "Funding_Program__c" VALUES(8,'2018-2019 STEAM Education','','2019-06-01','2018-08-01','In progress','50000.0');
INSERT INTO "Funding_Program__c" VALUES(9,'College Scholarships','','','1994-01-01','In progress','1000000.0');
INSERT INTO "Funding_Program__c" VALUES(10,'2018-2019 College Scholarships','','2018-08-31','2018-03-01','In progress','250000.0');
INSERT INTO "Funding_Program__c" VALUES(11,'2018 Scholarships','','2018-08-01','2018-04-01','In progress','50000.0');
INSERT INTO "Funding_Program__c" VALUES(12,'STEAM Education','','','2010-06-01','In progress','');
INSERT INTO "Funding_Program__c" VALUES(13,'Environment','','','1987-04-19','In progress','100000000.0');
INSERT INTO "Funding_Program__c" VALUES(14,'Lake Springfield Cleanup','','','2018-01-01','In progress','500000.0');
INSERT INTO "Funding_Program__c" VALUES(15,'2021-2022 College Scholarships','','2022-05-31','2021-04-20','In progress','250000.0');
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
INSERT INTO "Funding_Request__c" VALUES(1,'Test Funding Request','2018-04-02','12546.0','2018-04-10','2018-04-10','','State','Caregivers;Economically Disadvantaged People','15034.0','16408.0','','Awarded','2019-05-01','2018-05-01','','','','1');
INSERT INTO "Funding_Request__c" VALUES(2,'Test Request','2018-09-19','','','','','','','','','','Submitted','','','','','','5');
INSERT INTO "Funding_Request__c" VALUES(3,'Shelbyville Robotics','2018-03-01','','','','','City','Children and Youth','15000.0','20000.0','Shelbyville Robotics','Submitted','2019-05-31','2018-09-01','','','16','8');
INSERT INTO "Funding_Request__c" VALUES(4,'2021 Nonprofit A 12345','2021-05-06','5000.0','2022-05-06','','','City','Children and Youth','9000.0','10000.0','Community Support for Youth','Awarded','2022-06-01','2021-06-01','Terms of the funded request','','3','5');
INSERT INTO "Funding_Request__c" VALUES(5,'Shari Reily 2018-2019 Scholarship','2018-03-01','40000.0','','','','','','4000.0','3000.0','SFDO Academy - SalesForce Admin','In Review','','','','21','','10');
INSERT INTO "Funding_Request__c" VALUES(6,'Sarah Amin - Scholarship 2018-19','2018-04-03','7000.0','2018-06-06','','','','','5000.0','7000.0','UCLA - Arts & Crafts','Fully Disbursed','','','','30','','10');
INSERT INTO "Funding_Request__c" VALUES(7,'Springfield Robotics Team 2018','2018-01-01','15000.0','2018-05-30','','','City','Children and Youth','15000.0','10000.0','Robotics program','Awarded','2019-05-31','2018-09-01','For the 2018-19 School year to be used to support the robotics team.','32','29','8');
INSERT INTO "Funding_Request__c" VALUES(8,'Sally Jones','2017-04-28','50000.0','2017-07-26','','','','','55000.0','50000.0','','Awarded','2018-07-31','2017-08-01','','5','','2');
INSERT INTO "Funding_Request__c" VALUES(9,'2018 Bob Test 98765','2018-04-22','105000.0','2018-05-07','','','State','Homeless','100000.0','100000.0','','Awarded','2019-05-31','2018-06-01','','6','','7');
INSERT INTO "Funding_Request__c" VALUES(10,'2018 Ken Test 34567','2018-04-29','','','','','Region','Economically Disadvantaged People','','100000.0','Information about request','Submitted','','','','7','','7');
INSERT INTO "Funding_Request__c" VALUES(11,'2018 Lisa Test 67897','2018-04-08','105000.0','2018-05-07','','','State','Adults','100000.0','100000.0','','Submitted','2019-05-31','2018-06-01','','8','','7');
INSERT INTO "Funding_Request__c" VALUES(12,'2018 Nancy Carlson 23456','2018-03-06','','','','','City','Children and Youth','','100000.0','Serve children and youth','Submitted','','','','9','','7');
INSERT INTO "Funding_Request__c" VALUES(13,'2018 Operation Change the World 45678','2018-05-25','50000.0','2018-06-15','2018-06-15','','State','Families;Homeless;People with Disabilities','50000.0','75000.0','','Awarded','2018-06-30','2018-07-01','terms of the grant','10','9','5');
INSERT INTO "Funding_Request__c" VALUES(14,'Lisa Simpson Camp Scholarship','2018-04-17','','','','','','Children and Youth','','','','Submitted','','','','14','17','11');
INSERT INTO "Funding_Request__c" VALUES(15,'Remove 3 Eyed Fish','2018-06-07','100000.0','','','','City','Children and Youth','100000.0','100000.0','Remove contaminated fish from the lake','Awarded','','','','17','14','14');
INSERT INTO "Funding_Request__c" VALUES(16,'DUFF Robots','2018-05-01','0.0','','2018-05-30','This is a for profit company, does not benefit children.','Country','Adults','0.0','30000.0','Building a robot army.','Rejected','','','','26','22','8');
INSERT INTO "Funding_Request__c" VALUES(17,'Nick Lindberg - Scholarship 2018-19','2018-04-18','8000.0','2018-05-22','','','','','5000.0','3000.0','NYU - Dance & Computer Science','Submitted','2019-05-31','2018-08-15','Need a transcript and confirmation from NYU on acceptance','28','','10');
INSERT INTO "Funding_Request__c" VALUES(18,'Bill Corkill Scholarship 2018-19','2018-04-02','','','','','','','5000.0','10000.0','WMU  - Computers','Submitted','','','','29','','10');
INSERT INTO "Funding_Request__c" VALUES(19,'Shari Reily - Scholarship 2021-22','2021-04-30','10000.0','2021-04-20','','','','','10000.0','15000.0','SFDO Academy - SalesForce Admin','Awarded','','','','21','','15');
INSERT INTO "Funding_Request__c" VALUES(20,'Sarah Amin - Scholarship 2021-22','2021-04-20','10000.0','2021-04-21','','','','','','10000.0','SFDO Academy - SalesForce Admin','Awarded','','','','30','','15');
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
INSERT INTO "Requirement__c" VALUES(1,'Review Completed','2018-05-01','2018-05-15','','Complete','Review','','13','');
INSERT INTO "Requirement__c" VALUES(2,'Application Submitted','2018-04-12','2018-04-30','','Complete','Final Application','','13','');
INSERT INTO "Requirement__c" VALUES(3,'Final Report','','2019-07-31','','Open','Report','','13','10');
INSERT INTO "Requirement__c" VALUES(4,'LOI Required','2018-02-21','2018-02-13','','Accepted','Letter of Intent','','3','19');
INSERT INTO "Requirement__c" VALUES(5,'Application','2018-05-16','2018-05-01','','In Progress','Preliminary Application','','3','19');
INSERT INTO "Requirement__c" VALUES(6,'Budget Req.','','2018-07-02','','In Progress','Final Application','','3','19');
INSERT INTO "Requirement__c" VALUES(7,'Final Report','','2019-05-01','','Open','Report','','3','19');
INSERT INTO "Requirement__c" VALUES(8,'Proposal Required','2018-05-28','2018-05-25','<p>Proposal must be submitted. Was not adequate and did not meet criteria for grant program.</p>','Rejected','Preliminary Application','','16','26');
INSERT INTO "Requirement__c" VALUES(9,'Test Requirement','','','','','','','17','23');
INSERT INTO "Requirement__c" VALUES(10,'Acceptance Notice','2018-05-30','2018-08-01','','Complete','Final Application','29','17','28');
INSERT INTO "Requirement__c" VALUES(11,'Transcript Required','','2018-06-30','','In Progress','Final Application','29','17','28');
INSERT INTO "Requirement__c" VALUES(12,'Need Transcript','','2018-07-31','<p>Need Final Transcript before payment can be made</p>','Open','Final Application','4','5','21');
INSERT INTO "Requirement__c" VALUES(13,'Budget Required','2018-06-07','2018-06-15','<p>Need budget from Ned before initial payment can be made.</p>','Complete','Preliminary Application','22','15','23');
INSERT INTO "Requirement__c" VALUES(14,'Budget Required for 2nd (final) payment','','2018-08-01','','Open','Report','27','7','32');
INSERT INTO "Requirement__c" VALUES(15,'Interim Report','','2018-11-30','','Open','Report','13','13','10');
INSERT INTO "Requirement__c" VALUES(16,'Completion of Semester 1 and re-enrollment in Semseter 2','','2019-01-07','','Open','Final Application','14','17','28');
COMMIT;
