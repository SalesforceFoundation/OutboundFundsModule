BEGIN TRANSACTION;
CREATE TABLE "Account" (
	id INTEGER NOT NULL, 
	Name VARCHAR(255), 
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
	account_id VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Contact" VALUES(1,'','Lisa','Test','shari_reily@redpathcg.com','','','7');
INSERT INTO "Contact" VALUES(2,'Mr.','Bart','Simpson','','','Child','12');
INSERT INTO "Contact" VALUES(3,'Ms.','Lisa','Simpson','','','','12');
INSERT INTO "Contact" VALUES(4,'Mrs.','Marge','Simpson','','','','12');
INSERT INTO "Contact" VALUES(5,'','Nancy','Carlson','','','','8');
INSERT INTO "Contact" VALUES(6,'','Ken','Test','','','','6');
INSERT INTO "Contact" VALUES(7,'','Sally','Walker','','','','9');
INSERT INTO "Contact" VALUES(8,'Mr.','Moe','Szyslak','','','Owner','13');
INSERT INTO "Contact" VALUES(9,'Prof.','John','Frink','','','Professor','14');
INSERT INTO "Contact" VALUES(10,'Mr.','Montgomery','Burns','','','','15');
INSERT INTO "Contact" VALUES(11,'','Carol','Shelby','','','','16');
INSERT INTO "Contact" VALUES(12,'','Homer','Simpson','','','','17');
INSERT INTO "Contact" VALUES(13,'','Shari','Reily','','','','18');
INSERT INTO "Contact" VALUES(14,'Mr.','Ned','Flanders','test@test.com','','','20');
INSERT INTO "Contact" VALUES(15,'Mr.','Duff','Man','','','The King Of Beers','22');
INSERT INTO "Contact" VALUES(16,'Mr.','Clerance','Wiggum','chief@spinfieldpd.fake','911','Police Chief','23');
INSERT INTO "Contact" VALUES(17,'Mr.','Todd','Flanders','','','','20');
INSERT INTO "Contact" VALUES(18,'','Nick','Lindberg','','','','24');
INSERT INTO "Contact" VALUES(19,'','Seymour','Skinner','','','','29');
INSERT INTO "Contact" VALUES(20,'Mr.','Ralph','Wiggum','','','','30');
INSERT INTO "Contact" VALUES(21,'','Bill','Corkill','','','','25');
INSERT INTO "Contact" VALUES(22,'Mr.','Rod','Flanders','','','','20');
INSERT INTO "Contact" VALUES(23,'Ms.','Sarah','Amin','','','','26');
INSERT INTO "Contact" VALUES(24,'','Geoff','Minor','info@salesforce.com','(415) 555-1212','President','31');
INSERT INTO "Contact" VALUES(25,'','Carole','White','info@salesforce.com','(415) 555-1212','VP Sales','31');
INSERT INTO "Contact" VALUES(26,'','Jon','Amos','info@salesforce.com','(905) 555-1212','Sales Manager','31');
INSERT INTO "Contact" VALUES(27,'','Edward','Stamos','info@salesforce.com','(212) 555-5555','President and CEO','32');
INSERT INTO "Contact" VALUES(28,'Mr.','Big','Wig','','','CEO','11');
INSERT INTO "Contact" VALUES(29,'','Howard','Jones','info@salesforce.com','(212) 555-5555','Buyer','32');
INSERT INTO "Contact" VALUES(30,'','Sample','Contact','sample.contact@email.com','(202) 555-9654','CEO','27');
INSERT INTO "Contact" VALUES(31,'','Leanne','Tomlin','info@salesforce.com','(212) 555-5555','VP Customer Support','32');
INSERT INTO "Contact" VALUES(32,'Mr.','Marc','Benioff','info@salesforce.com','(415) 901-7000','Executive Officer','2');
INSERT INTO "Contact" VALUES(33,'','Erin','Test','shari_reily@redpathcg.com','','','1');
INSERT INTO "Contact" VALUES(34,'','Sally','Jones','','','','4');
INSERT INTO "Contact" VALUES(35,'','Bob','Test','','','','5');
CREATE TABLE "Disbursement__c" (
	id INTEGER NOT NULL, 
	"Amount__c" VARCHAR(255), 
	"Disbursement_Date__c" VARCHAR(255), 
	"Disbursement_Method__c" VARCHAR(255), 
	"Scheduled_Date__c" VARCHAR(255), 
	"Status__c" VARCHAR(255), 
	"Type__c" VARCHAR(255), 
	funding_request__c VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Disbursement__c" VALUES(1,'50000.0','','EFT','2018-06-15','Approved','Initial','6');
INSERT INTO "Disbursement__c" VALUES(2,'50000.0','','EFT','2018-09-01','Scheduled','Final','6');
INSERT INTO "Disbursement__c" VALUES(3,'7000.0','2018-06-06','Cash','2018-06-06','Paid','Final','17');
INSERT INTO "Disbursement__c" VALUES(4,'4000.0','','','2018-11-01','Pending Approval','Final','14');
INSERT INTO "Disbursement__c" VALUES(5,'4000.0','2018-05-31','EFT','2018-06-01','Approved','Initial','14');
INSERT INTO "Disbursement__c" VALUES(6,'10000.0','','EFT','2018-09-01','Paid','Final','7');
INSERT INTO "Disbursement__c" VALUES(7,'5000.0','2018-05-14','EFT','2018-05-11','Paid','Initial','7');
INSERT INTO "Disbursement__c" VALUES(8,'20000.0','','EFT','2018-07-31','Pending Approval','Initial','5');
INSERT INTO "Disbursement__c" VALUES(9,'20000.0','','EFT','2018-12-01','Scheduled','Final','5');
INSERT INTO "Disbursement__c" VALUES(10,'5000.0','','EFT','2018-06-01','Scheduled','Initial','9');
INSERT INTO "Disbursement__c" VALUES(11,'50000.0','','Check','2018-12-01','Scheduled','Interim','9');
INSERT INTO "Disbursement__c" VALUES(12,'50000.0','','Check','2019-05-01','Scheduled','Final','9');
INSERT INTO "Disbursement__c" VALUES(13,'5000.0','','EFT','2018-06-01','Scheduled','Initial','10');
INSERT INTO "Disbursement__c" VALUES(14,'50000.0','','EFT','2018-12-01','Scheduled','Interim','10');
INSERT INTO "Disbursement__c" VALUES(15,'50000.0','','EFT','2019-05-01','Scheduled','Final','10');
INSERT INTO "Disbursement__c" VALUES(16,'2500.0','','Check','2018-06-01','Scheduled','Initial','3');
INSERT INTO "Disbursement__c" VALUES(17,'2500.0','','Check','2018-12-01','Scheduled','Final','3');
INSERT INTO "Disbursement__c" VALUES(18,'25000.0','2018-07-13','Check','2018-07-15','Paid','Initial','13');
INSERT INTO "Disbursement__c" VALUES(19,'25000.0','','Check','2018-12-15','Scheduled','Interim','13');
INSERT INTO "Disbursement__c" VALUES(20,'15000.0','2017-08-01','Check','2017-08-01','Paid','Initial','8');
INSERT INTO "Disbursement__c" VALUES(21,'124.0','2018-04-12','Cash','2018-04-11','Paid','Initial','1');
INSERT INTO "Disbursement__c" VALUES(22,'125345.0','','Cash','2018-05-11','Scheduled','Interim','1');
INSERT INTO "Disbursement__c" VALUES(23,'65667.0','','Cash','2018-02-15','Scheduled','Amendment','1');
CREATE TABLE "Funding_Program__c" (
	id INTEGER NOT NULL, 
	Name VARCHAR(255), 
	"Description__c" VARCHAR(255), 
	"End_Date__c" VARCHAR(255), 
	"Start_Date__c" VARCHAR(255), 
	"Status__c" VARCHAR(255), 
	"Total_Program_Amount__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Funding_Program__c" VALUES(1,'Lake Springfield Cleanup','','','2018-01-01','In progress','500000.0');
INSERT INTO "Funding_Program__c" VALUES(2,'Research Scholarship','','','','In progress','');
INSERT INTO "Funding_Program__c" VALUES(3,'2017-2018 Research Scholarships','','2018-07-31','2017-08-01','In progress','500000.0');
INSERT INTO "Funding_Program__c" VALUES(4,'2018-2019 Research Scholarship','','2019-07-31','2018-08-01','Planned','600000.0');
INSERT INTO "Funding_Program__c" VALUES(5,'Community Support','Main Community Support program','','2018-01-01','In progress','');
INSERT INTO "Funding_Program__c" VALUES(6,'2018 Community Support','2018 Community Support','2018-12-31','2018-01-01','Planned','100000.0');
INSERT INTO "Funding_Program__c" VALUES(7,'Individual Fellowship','','','2018-01-01','In progress','');
INSERT INTO "Funding_Program__c" VALUES(8,'2018 Individual Fellowship','','','2018-01-01','In progress','1000000.0');
INSERT INTO "Funding_Program__c" VALUES(9,'2018-2019 STEAM Education','','2019-06-01','2018-08-01','In progress','50000.0');
INSERT INTO "Funding_Program__c" VALUES(10,'College Scholarships','','','1994-01-01','In progress','1000000.0');
INSERT INTO "Funding_Program__c" VALUES(11,'2018-2019 College Scholarships','','2018-08-31','2018-03-01','In progress','250000.0');
INSERT INTO "Funding_Program__c" VALUES(12,'2018 Scholarships','','2018-08-01','2018-04-01','In progress','50000.0');
INSERT INTO "Funding_Program__c" VALUES(13,'STEAM Education','','','2010-06-01','In progress','');
INSERT INTO "Funding_Program__c" VALUES(14,'Environment','','','1987-04-19','In progress','1.0E8');
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
	applying_contact__c VARCHAR(255), 
	applying_organization__c VARCHAR(255), 
	funding_program__c VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Funding_Request__c" VALUES(1,'Test Funding Request','2018-04-02','12546.0','2018-04-10','2018-04-10','','State','Caregivers;Economically Disadvantaged People','15034.0','16408.0','','Awarded','2019-05-01','2018-05-01','','','','2');
INSERT INTO "Funding_Request__c" VALUES(2,'Test Request','2018-09-19','','','','','','','','','','Submitted','','','','','','6');
INSERT INTO "Funding_Request__c" VALUES(3,'2018 Nonprofit A 12345','2018-05-06','5000.0','2018-05-06','','','City','Children and Youth','9000.0','10000.0','Community Support for Youth','Awarded','2019-06-01','2018-06-01','Terms of the funded request','','3','6');
INSERT INTO "Funding_Request__c" VALUES(4,'Shelbyville Robotics','2018-03-01','','','','','City','Children and Youth','15000.0','20000.0','Shelbyville Robotics','Submitted','2019-05-31','2018-09-01','','','16','9');
INSERT INTO "Funding_Request__c" VALUES(5,'Shari Reily 2018-2019 Scholarship','2018-03-01','40000.0','','','','','','4000.0','3000.0','SFDO Academy - SalesForce Admin','In Review','','','','13','','11');
INSERT INTO "Funding_Request__c" VALUES(6,'Remove 3 Eyed Fish','2018-06-07','100000.0','','','','City','Children and Youth','100000.0','100000.0','Remove contaminated fish from the lake','Awarded','','','','9','14','1');
INSERT INTO "Funding_Request__c" VALUES(7,'Springfield Robotics Team 2018','2018-01-01','15000.0','2018-05-30','','','City','Children and Youth','15000.0','10000.0','Robotics program','Awarded','2019-05-31','2018-09-01','For the 2018-19 School year to be used to support the robotics team.','19','29','9');
INSERT INTO "Funding_Request__c" VALUES(8,'Sally Jones','2017-04-28','50000.0','2017-07-26','','','','','55000.0','50000.0','','Awarded','2018-07-31','2017-08-01','','34','','3');
INSERT INTO "Funding_Request__c" VALUES(9,'2018 Bob Test 98765','2018-04-22','105000.0','2018-05-07','','','State','Homeless','100000.0','100000.0','','Awarded','2019-05-31','2018-06-01','','35','','8');
INSERT INTO "Funding_Request__c" VALUES(10,'2018 Lisa Test 67897','2018-04-08','105000.0','2018-05-07','','','State','Adults','100000.0','100000.0','','Submitted','2019-05-31','2018-06-01','','1','','8');
INSERT INTO "Funding_Request__c" VALUES(11,'2018 Nancy Carlson 23456','2018-03-06','','','','','City','Children and Youth','','100000.0','Serve children and youth','Submitted','','','','5','','8');
INSERT INTO "Funding_Request__c" VALUES(12,'2018 Ken Test 34567','2018-04-29','','','','','Region','Economically Disadvantaged People','','100000.0','Information about request','Submitted','','','','6','','8');
INSERT INTO "Funding_Request__c" VALUES(13,'2018 Operation Change the World 45678','2018-05-25','50000.0','2018-06-15','2018-06-15','','State','Families;Homeless;People with Disabilities','50000.0','75000.0','','Awarded','2018-06-30','2018-07-01','terms of the grant','7','9','6');
INSERT INTO "Funding_Request__c" VALUES(14,'Nick Lindberg - Scholarship 2018-19','2018-04-18','8000.0','2018-05-22','','','','','5000.0','3000.0','NYU - Dance & Computer Science','Submitted','2019-05-31','2018-08-15','Need a transcript and confirmation from NYU on acceptance','18','','11');
INSERT INTO "Funding_Request__c" VALUES(15,'Lisa Simpson Camp Scholarship','2018-04-17','','','','','','Children and Youth','','','','Submitted','','','','3','17','12');
INSERT INTO "Funding_Request__c" VALUES(16,'Bill Corkill Scholarship 2018-19','2018-04-02','','','','','','','5000.0','10000.0','WMU  - Computers','Submitted','','','','21','','11');
INSERT INTO "Funding_Request__c" VALUES(17,'Sarah Amin - Scholarship 2018-19','2018-04-03','','2018-06-06','','','','','5000.0','7000.0','UCLA - Arts & Crafts','Fully Disbursed','','','','23','','11');
INSERT INTO "Funding_Request__c" VALUES(18,'DUFF Robots','2018-05-01','0.0','','2018-05-30','This is a for profit company, does not benefit children.','Country','Adults','0.0','30000.0','Building a robot army.','Rejected','','','','15','22','9');
CREATE TABLE "Requirement__c" (
	id INTEGER NOT NULL, 
	"Name" VARCHAR(255), 
	"Completed_Date__c" VARCHAR(255), 
	"Due_Date__c" VARCHAR(255), 
	"Requirements__c" VARCHAR(255), 
	"Status__c" VARCHAR(255), 
	"Type__c" VARCHAR(255), 
	disbursement__c VARCHAR(255), 
	funding_request__c VARCHAR(255), 
	primary_contact__c VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Requirement__c" VALUES(1,'Proposal Required','2018-05-28','2018-05-25','<p>Proposal must be submitted. Was not adequate and did not meet criteria for grant program.</p>','Rejected','Preliminary Application','','18','15');
INSERT INTO "Requirement__c" VALUES(2,'Test Requirement','','','','','','','14','14');
INSERT INTO "Requirement__c" VALUES(3,'LOI Required','2018-02-21','2018-02-13','','Accepted','Letter of Intent','','4','11');
INSERT INTO "Requirement__c" VALUES(4,'Application','2018-05-16','2018-05-01','','In Progress','Preliminary Application','','4','11');
INSERT INTO "Requirement__c" VALUES(5,'Budget Req.','','2018-07-02','','In Progress','Final Application','','4','11');
INSERT INTO "Requirement__c" VALUES(6,'Final Report','','2019-05-01','','Open','Report','','4','11');
INSERT INTO "Requirement__c" VALUES(7,'Review Completed','2018-05-01','2018-05-15','','Complete','Review','','13','');
INSERT INTO "Requirement__c" VALUES(8,'Application Submitted','2018-04-12','2018-04-30','','Complete','Final Application','','13','');
INSERT INTO "Requirement__c" VALUES(9,'Final Report','','2019-07-31','','Open','Report','','13','7');
INSERT INTO "Requirement__c" VALUES(10,'Interim Report','','2018-11-30','','Open','Report','19','13','7');
INSERT INTO "Requirement__c" VALUES(11,'Budget Required','2018-06-07','2018-06-15','<p>Need budget from Ned before initial payment can be made.</p>','Complete','Preliminary Application','1','6','14');
INSERT INTO "Requirement__c" VALUES(12,'Completion of Semester 1 and re-enrollment in Semseter 2','','2019-01-07','','Open','Final Application','4','14','18');
INSERT INTO "Requirement__c" VALUES(13,'Acceptance Notice','2018-05-30','2018-08-01','','Complete','Final Application','5','14','18');
INSERT INTO "Requirement__c" VALUES(14,'Transcript Required','','2018-06-30','','In Progress','Final Application','5','14','18');
INSERT INTO "Requirement__c" VALUES(15,'Budget Required for 2nd (final) payment','','2018-08-01','','Open','Report','6','7','19');
INSERT INTO "Requirement__c" VALUES(16,'Need Transcript','','2018-07-31','<p>Need Final Transcript before payment can be made</p>','Open','Final Application','8','5','13');
COMMIT;
