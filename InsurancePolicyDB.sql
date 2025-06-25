-- ==========================================================================================================================================================================================================
-- The InsurancePolicy_db is a fully normalized, enterprise-grade relational database designed to support the full operational lifecycle of an insurance business. 
-- It serves as the central backend system for managing customers, policies, claims, agents, underwriting, payments, marketing, CRM, compliance, and analytics.
-- It’s scalable, audit-ready, and structured to support both customer-facing portals (for self-service and policy management) and internal operations (for agents, administrators, and underwriters).
--
-- ##################################### Key Capabilities ###################################################################################################################################################
-- * Policy Lifecycle Management: Creation, activation, modification, endorsement, and renewal of insurance policies.
-- * Customer Relationship Management (CRM): Tracks interactions, appointments, support requests, and campaign targeting.
-- * Claims Processing: Manages claim intake, documentation, adjustments, settlements, and disputes.
-- * Payment & Billing Infrastructure: Handles invoice generation, payments, and payment methods (including multiple credit cards).
-- * Underwriting & Risk Assessment: Evaluates risk with score tracking, notes, and historical decisions.
-- * Agent & Office Administration: Manages agent onboarding, supervision, appointments, tasks, and office locations.
-- * Document & Evidence Storage: Upload and track policy documents, claim files, and tax documents.
-- * Geolocation Intelligence: Supports risk zoning, catastrophe mapping, and territory-based analysis by tracking agent, user, and office coordinates.
-- * Regulatory & Audit Readiness: Captures user activity via audit logs and supports compliance with tax records and dispute tracking.
-- * Marketing & Lead Management: Tracks campaign execution, lead capture, and conversion metrics.
-- * Security & Authentication: Includes login tracking, multi-role access control, and API key support.
-- * Dashboards & Reporting: Custom user dashboards display KPIs, charts, and tables for real-time monitoring.
-- 
-- ##################################### Database Overview – Tables by Domain ###############################################################################################################################
-- 1. Core Business Entities           - Customers (Personal, contact, and payment data) Policies, (Main insurance policy contract data), PolicyTypes, (Metadata defining policy categories),
--                                       Beneficiaries (Linked to life and other policies).
-- 2. Policy Coverage & Vehicles       - Coverage, Policy_Coverage [Custom coverages (limits, deductibles, premiums)], Vehicles, Driver (Auto insurance-specific data).
-- 3. Claims & Underwriting            - Claims, ClaimDocuments (Claim info, type, status, documents), Adjusters (Staff handling claims), 
--                                       Underwriting (Risk analysis, notes, decisions), Disputes (Appeals against claim or UW decisions). 
-- 4. Payments & Billing               - Payments (Payment transaction history), Invoices (Billing formalities and due dates), 
--                                       PremiumHistory (Track rate changes over time), PaymentMethods (Multiple credit card profiles).
-- 5. Sales & Agents                   - Agents, Offices (Internal representatives and branches), Policies_Agents (Which agent sold which policy), Appointments, (Tasks	Scheduled meetings, work tracking)
-- 6. Users, Authentication & Portals  - Users [Abstracts any user (agent, admin, customer)], LoginAccounts	(Portal login data), LoginAttempts, APIKeys	(Security & system access tracking).
-- 7. Marketing & Outreach			   - MarketingCampaigns	(Email/phone/mail campaigns), CampaignRecipients (Who was targeted, status), Leads (Cold prospects and follow-up tracking),
--                                       EmailQueue	(Automation & outbound messaging).
-- 8. Communication & Documentation    - Documents (Uploads tied to claims or policies), CustomerInteractions (Support tickets, notes, calls), Notifications (Login alerts and system messages),
--                                       Dashboards	(Custom widgets per user for analytics).
-- 9. Risk, Location & Compliance      - Geolocation (Latitude/longitude tracking of users, agents, offices — includes risk level, zip, country), AuditLogs	(Tracks all data changes for compliance),
--                                       TaxRecords	(Stores annual IRS or other filings per customer and policy), ReinsurancePartners (Track vendor agreements behind-the-scenes), 
--                                       ThirdPartyVendors (Legal, medical, or technical vendors).
-- 
-- ##################################### Notable Technical Features #######################################################################################################################################
-- Geospatial Risk: Geolocation includes precise latitude/longitude + ZIP, city, state, country, and risk tiering.
-- Many-to-Many Structures: For example, Policy_Coverage, CampaignRecipients, and Policies_Agents.
-- Extensibility: Easily supports API access, dashboards, automation, and new modules like mobile apps or reporting engines.
-- Security-First Design: User/agent/admin roles are isolated, and access can be tightly controlled via login, role, or audit tracking.
-- 
-- ##################################### FINAL SUMMARY ####################################################################################################################################################
-- With over 40 normalized tables, this database models the operations of a full-service insurance company, providing a foundation for real-time portals, CRM systems, 
-- analytics dashboards, and compliance-driven workflows. It is well-suited for deployment behind web or mobile applications, third-party integrations, or internal admin tools.

-- ========================================================================================================================================================================================================

CREATE DATABASE InsurancePolicy_db;

USE InsurancePolicy_db;

-- ===================================================
-- ============== Customers Table ====================
-- ===================================================

CREATE TABLE Customers (
    CustomerID 				INT PRIMARY KEY AUTO_INCREMENT,
    FirstName 				VARCHAR(50),
    LastName 				VARCHAR(50),
    DateOfBirth 			DATE,
	Address 				VARCHAR(200),
    City 					VARCHAR(20),
    State 					VARCHAR(2),
    ZipCode 				VARCHAR(5),
    PhoneNumber 			VARCHAR(20),
    Email 					VARCHAR(100),
    CreditCardNum		    VARCHAR(16),
    CardExpDate 			DATE

);


-- ===================================================
-- ============== Policies Table =====================
-- ===================================================

CREATE TABLE Policies (
	PolicyNum 				INT PRIMARY KEY AUTO_INCREMENT,
    Customer_ID 			INT,
    Policy_Type 			VARCHAR(15),
    Effective_Date 			DATE,
    Expiration_Date 		DATE,
    Premium_Amt 			DECIMAL,
    Coverage_Detail 		TEXT,
    Beneficiary 			VARCHAR(40),
    Status  				ENUM('Active','Cancelled','New'),
    FOREIGN KEY (Customer_ID) REFERENCES Customers(CustomerID)
    );

-- ===================================================
-- ============== Claims Table =======================
-- ===================================================

CREATE TABLE Claims (
	ClaimID 				INT PRIMARY KEY AUTO_INCREMENT,
    PolicyNum 				INT,
    Claim_Date 				DATE,
    Claim_Type 				VARCHAR(10),
    Claim_Status 			VARCHAR(25),
    Claim_Desc 				TEXT(50),
    Claim_Amt 				DECIMAL,
    Settlement_Amt 			DECIMAL,
    Settlement_Date 		DATE
    );

-- ===================================================
-- ============== Vechicles Table ====================
-- ===================================================

CREATE TABLE Vehicles (
    VehicleID      			INT PRIMARY KEY AUTO_INCREMENT,
    PolicyNum      			VARCHAR(10),
    Vehicle_Make  			VARCHAR(15),
    Vehicle_Model  			VARCHAR(15),
    Vehicle_Year   			DECIMAL(4, 0),
    VIN            			VARCHAR(17),
    License_Plate  			VARCHAR(10),
    Vehicle_Color  			VARCHAR(10),
    Vehicle_Type   			VARCHAR(10),
    Current_Val    			DECIMAL(10, 2),
    CONSTRAINT fk_policy
	FOREIGN KEY (PolicyNum) REFERENCES Policies(PolicyNum)
);

-- ===================================================
-- ============== Agents Table =======================
-- ===================================================

CREATE TABLE  Agents (
	AgentID 				INT PRIMARY KEY, 
    OfficeID				INT,
    FirstName 				VARCHAR(20),
    LastName  				VARCHAR(20),
    Email	  				VARCHAR(50),
    PhoneNum  				VARCHAR(15),
    AgentAddress 			VARCHAR(200),
    AgentArea 				VARCHAR(3),
    SupervisedBy 			VARCHAR(50),
    FOREIGN KEY (OfficeID) REFERENCES Offices(OfficeID)
    );

-- ===================================================
-- ============== Policies_Agents Table  =============
-- ===================================================

CREATE TABLE Policies_Agents (
    PolicyNum 				INT,
    AgentID 				INT,
    PRIMARY KEY (PolicyNum, AgentID),
    FOREIGN KEY (PolicyNum) REFERENCES Policies(PolicyNum),
    FOREIGN KEY (AgentID) REFERENCES Agents(AgentID)			
);

-- ===================================================
-- ============== Payments Table =====================
-- ===================================================

CREATE TABLE Payments (
    PaymentID 				INT PRIMARY KEY AUTO_INCREMENT,
    PolicyNum 				INT,
    PaymentDate 			DATE,
    AmountPaid 				DECIMAL(10, 2),
    PaymentMethod 			VARCHAR(20),
    PaymentStatus 			VARCHAR(20),
    FOREIGN KEY (PolicyNum) REFERENCES Policies(PolicyNum)
);

-- ===================================================
-- ============== PolicyTypes ========================
-- =================================================== 
 
 CREATE TABLE PolicyTypes (
    PolicyTypeID 			INT PRIMARY KEY AUTO_INCREMENT,
    TypeName 				VARCHAR(30),
    Description 			TEXT
);
 
-- ===================================================
-- ============== Beneficiaries Table ================
-- =================================================== 
 
CREATE TABLE Beneficiaries (
    BeneficiaryID 			INT PRIMARY KEY AUTO_INCREMENT,
    PolicyNum 				INT,
    FirstName 				VARCHAR(50),
    LastName 				VARCHAR(50),
    Relationship 			VARCHAR(30),
    SharePercentage 		DECIMAL(5,2),
    FOREIGN KEY (PolicyNum) REFERENCES Policies(PolicyNum)
);

-- ===================================================
-- ============== Adjusters Table ====================
-- ===================================================

CREATE TABLE Adjusters (
    AdjusterID 				INT PRIMARY KEY AUTO_INCREMENT,
    FirstName 				VARCHAR(50),
    LastName 				VARCHAR(50),
    Email 					VARCHAR(100),
    PhoneNumber 			VARCHAR(20)
);

-- ===================================================
-- ============== Underwriting Table =================
-- ===================================================

CREATE TABLE Underwriting (
    UWID 					INT PRIMARY KEY AUTO_INCREMENT,
    PolicyNum 				INT,
    RiskScore 				DECIMAL(4,1),
    Decision 				VARCHAR(20),
    UWDate 					DATE,
    Notes 					TEXT,
    FOREIGN KEY (PolicyNum) REFERENCES Policies(PolicyNum)
);

-- ===================================================
-- ============== Driver Table =======================
-- ===================================================

CREATE TABLE Driver (
    DriverID 				INT PRIMARY KEY,
    PolicyNum 				INT,
    FirstName 				VARCHAR(255),
    LastName 				VARCHAR(255),
    DateOfBirth				DATE,
    DriverLicenseNumber 	VARCHAR(50),
    FOREIGN KEY (PolicyNum) REFERENCES Policies(PolicyNum)
);

-- ===================================================
-- ============== Coverage Table =====================
-- ===================================================

CREATE TABLE Coverage (
    CoverageID				INT PRIMARY KEY,
    CoverageName 			VARCHAR(255),
    CoverageGroup 			VARCHAR(255)
);

-- ===================================================
-- ============== Policy_coverage Table ==============
-- ===================================================

-- Creating the Policy_Coverage table (Many-to-Many relationship between Policies and Coverage)

CREATE TABLE Policy_Coverage (
    PolicyNum 				INT,
    CoverageID 				INT,
    PolicyLimit				DECIMAL(10, 2),
    Deductible 				DECIMAL(10, 2),
    Premium 				DECIMAL(10, 2),
    PRIMARY KEY (PolicyNum, CoverageID),
    FOREIGN KEY (PolicyNum) REFERENCES Policies(PolicyNum),
    FOREIGN KEY (CoverageID) REFERENCES Coverage(CoverageID)
);

-- ===================================================
-- ============== LoginAccounts Table ================
-- ===================================================

-- LoginAccounts (for customer and agent portals)
-- To support authentication for web access:

CREATE TABLE LoginAccounts (
    AccountID 				INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID 				INT,
    AgentID 				INT,
    Username 				VARCHAR(50) UNIQUE,
    PasswordHash 			VARCHAR(255),
    Role 					ENUM('Customer', 'Agent', 'Admin'),
    LastLogin 				DATETIME,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (AgentID) 	REFERENCES Agents(AgentID)
);

-- ===================================================
-- ============== Documents Table ====================
-- ===================================================

-- To store policy documents, IDs, claims evidence, etc.:

CREATE TABLE Documents (
    DocumentID 				INT PRIMARY KEY AUTO_INCREMENT,
    PolicyNum 				INT,
    ClaimID 				INT,
    UploadDate 				DATETIME,
    FileName 				VARCHAR(255),
    FileType 				VARCHAR(50),
    FilePath 				VARCHAR(500), -- Or BLOB if storing in DB
    FOREIGN KEY (PolicyNum) REFERENCES Policies(PolicyNum),
    FOREIGN KEY (ClaimID) 	REFERENCES Claims(ClaimID)
);

-- ===================================================
-- ============== CustomerInteractions Table =========
-- ===================================================

-- Track calls/emails/meetings for CRM or support history:

CREATE TABLE CustomerInteractions (
    InteractionID 			INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID 				INT,
    AgentID 				INT,
    InteractionDate 		DATETIME,
    InteractionType 		VARCHAR(50),
    Notes 					TEXT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (AgentID) 	REFERENCES Agents(AgentID)
);

-- ===================================================
-- ============== Offices Table ======================
-- ===================================================

-- If your agents work out of regional offices:

CREATE TABLE Offices (
    OfficeID 				INT PRIMARY KEY AUTO_INCREMENT,
    OfficeName 				VARCHAR(100),
    Address 				VARCHAR(255),
    City 					VARCHAR(50),
    State 					VARCHAR(2),
    ZipCode 				VARCHAR(10),
    PhoneNumber 			VARCHAR(20)
);

-- ===================================================
-- ============== AuditLogs Table ====================
-- ===================================================

-- This logs system-level events like data changes, logins, and administrative actions.

CREATE TABLE AuditLogs (
    LogID 					INT PRIMARY KEY AUTO_INCREMENT,
    UserType 				ENUM('Customer', 'Agent', 'Admin'),
    UserID 					INT,
    ActionType 				VARCHAR(50), -- e.g. 'UPDATE_POLICY', 'LOGIN', 'DELETE_CLAIM'
    TableAffected 			VARCHAR(50),
    RecordID 				INT, -- e.g., affected PolicyNum, ClaimID, etc.
    ActionDetails 			TEXT,
    ActionTimestamp 		DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) 	REFERENCES Users(UserID)
);

-- ===================================================
-- ============== Invoices Table =====================
-- ===================================================

-- To track formal billing (vs. just payment records):

CREATE TABLE Invoices (
    InvoiceID 				INT PRIMARY KEY AUTO_INCREMENT,
    PolicyNum 				INT,
    InvoiceDate 			DATE,
    DueDate 				DATE,
    TotalAmount 			DECIMAL(10,2),
    Status 					ENUM('Unpaid', 'Paid', 'Overdue'),
    FOREIGN KEY (PolicyNum) REFERENCES Policies(PolicyNum)
);

-- ===================================================
-- ============== PolicyEndorsements Table ===========
-- ===================================================

-- Track mid-policy changes (common in real insurance):

CREATE TABLE PolicyEndorsements (
    EndorsementID 			INT PRIMARY KEY AUTO_INCREMENT,
    PolicyNum 				INT,
    EndorsementDate 		DATE,
    ChangeDescription 		TEXT,
    EffectiveDate 			DATE,
    FOREIGN KEY (PolicyNum) REFERENCES Policies(PolicyNum)
);

-- ===================================================
-- ============== Disputes Table =====================
-- ===================================================

-- If a claim or underwriting decision is disputed:

CREATE TABLE Disputes (
    DisputeID 				INT PRIMARY KEY AUTO_INCREMENT,
    ClaimID 				INT,
    CustomerID 				INT,
    SubmittedDate 			DATE,
    DisputeReason 			TEXT,
    ResolutionStatus 		VARCHAR(50),
    ResolutionNotes 		TEXT,
    FOREIGN KEY (ClaimID) 	 REFERENCES Claims(ClaimID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- ===================================================
-- ============== MarketingCampaigns Table ===========
-- ===================================================

-- Used to track email, phone, or digital outreach efforts.

CREATE TABLE MarketingCampaigns (
    CampaignID 				INT PRIMARY KEY AUTO_INCREMENT,
    CampaignName 			VARCHAR(100),
    Channel 				ENUM('Email', 'Phone', 'Mail', 'Social Media', 'Event'),
    StartDate 				DATE,
    EndDate 				DATE,
    TargetAudience 			VARCHAR(100), -- e.g. 'New Leads', 'Expired Policies'
    Budget 					DECIMAL(10, 2),
    Notes 					TEXT
);

-- ===================================================
-- ============== CampaignRecipients Table ===========
-- ===================================================

-- Track which customers were targeted in which campaign: (Many-to-Many)

CREATE TABLE CampaignRecipients (
    CampaignID 				INT,
    CustomerID 				INT,
    ContactDate 			DATE,
    ResponseStatus 			ENUM('Not Contacted', 'Contacted', 'Interested', 'Not Interested', 'Unsubscribed'),
    PRIMARY KEY (CampaignID, CustomerID),
    FOREIGN KEY (CampaignID) REFERENCES MarketingCampaigns(CampaignID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- ===================================================
-- ============== Users Table ========================
-- ===================================================

-- This table provides a single user identity for authentication, authorization, and auditing:

CREATE TABLE Users (
    UserID 					INT PRIMARY KEY AUTO_INCREMENT,
    Role 					ENUM('Customer', 'Agent', 'Admin') NOT NULL,
    ReferenceID 			INT NOT NULL, -- links to CustomerID or AgentID depending on Role
    Username 				VARCHAR(50) UNIQUE NOT NULL,
    PasswordHash 			VARCHAR(255) NOT NULL,
    Email 					VARCHAR(100),
    LastLogin 				DATETIME,
    Status 					ENUM('Active', 'Suspended', 'Deactivated') DEFAULT 'Active'
);

-- ===================================================
-- ============== Admins Table =======================
-- ===================================================

-- Admins to have full profile fields (like name, phone):

CREATE TABLE Admins (
    AdminID 				INT PRIMARY KEY AUTO_INCREMENT,
    FirstName 				VARCHAR(50),
    LastName 				VARCHAR(50),
    Email 					VARCHAR(100),
    Phone 					VARCHAR(20)
);

-- ===================================================
-- ============== Appointments Table =================
-- ===================================================

-- Track scheduled meetings between customers and agents or adjusters.

CREATE TABLE Appointments (
    AppointmentID 			INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID 				INT,
    AgentID 				INT,
    AdjusterID 				INT,
    AppointmentDate 		DATETIME,
    MeetingType 			ENUM('Consultation', 'Policy Review', 'Claim Discussion', 'Other'),
    Notes 					TEXT,
    FOREIGN KEY (CustomerID) 	REFERENCES Customers(CustomerID),
    FOREIGN KEY (AgentID) 		REFERENCES Agents(AgentID),
    FOREIGN KEY (AdjusterID) 	REFERENCES Adjusters(AdjusterID)
);

-- ===================================================
-- ============== Leads Table ========================
-- ===================================================

-- Track potential customers, useful for prospecting and cold marketing.

CREATE TABLE Leads (
    LeadID 					INT PRIMARY KEY AUTO_INCREMENT,
    FirstName 				VARCHAR(50),
    LastName 				VARCHAR(50),
    ContactDate 			DATE,
    Source 					VARCHAR(50), -- e.g. 'Web Form', 'Referral'
    Phone 					VARCHAR(20),
    Email 					VARCHAR(100),
    Status 					ENUM('New', 'Contacted', 'Qualified', 'Converted', 'Rejected'),
    AssignedAgentID 		INT,
    FOREIGN KEY (AssignedAgentID) REFERENCES Agents(AgentID)
);

-- ===================================================
-- ============== Notifications Table ================
-- ===================================================

-- Store alerts/messages to be shown to users on login (like premium due, claims update).

CREATE TABLE Notifications (
    NotificationID 			INT PRIMARY KEY AUTO_INCREMENT,
    UserID 					INT,
    Message 				TEXT,
    NotificationType 		ENUM('Info', 'Warning', 'ActionRequired'),
    CreatedAt 				DATETIME DEFAULT CURRENT_TIMESTAMP,
    IsRead 					BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (UserID) 	REFERENCES Users(UserID)
);

-- ===================================================
-- ============== LoginAttempts Table ================
-- ===================================================

-- Track login history, failed logins, and IPs for auditing and security.

CREATE TABLE LoginAttempts (
    AttemptID 				INT PRIMARY KEY AUTO_INCREMENT,
    Username 				VARCHAR(50),
    AttemptTime 			DATETIME DEFAULT CURRENT_TIMESTAMP,
    Success 				BOOLEAN,
    IPAddress 				VARCHAR(45),
    UserAgent 				TEXT
);

-- ===================================================
-- ============== Tasks Table ========================
-- ===================================================

-- Helps agents or admins track outstanding work.

CREATE TABLE Tasks (
    TaskID 					INT PRIMARY KEY AUTO_INCREMENT,
    AssignedToAgentID 		INT,
    RelatedPolicyNum 		INT,
    TaskDescription 		TEXT,
    TaskStatus 				ENUM('Open', 'In Progress', 'Completed'),
    DueDate 				DATE,
    FOREIGN KEY (AssignedToAgentID) REFERENCES Agents(AgentID),
    FOREIGN KEY (RelatedPolicyNum) REFERENCES Policies(PolicyNum)
);

-- ===================================================
-- ============== ClaimDocuments Table ===============
-- ===================================================

-- If you expect many documents per claim, this separates them cleanly:

CREATE TABLE ClaimDocuments (
    DocID 					INT PRIMARY KEY AUTO_INCREMENT,
    ClaimID 				INT,
    FileName 				VARCHAR(255),
    FilePath 				VARCHAR(500),
    UploadDate 				DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ClaimID) 	REFERENCES Claims(ClaimID)
);

-- ===================================================
-- ============== PremiumHistory Table ===============
-- ===================================================

-- Keeps track of past premium amounts even when a policy is renewed or updated.

CREATE TABLE PremiumHistory (
    EntryID 				INT PRIMARY KEY AUTO_INCREMENT,
    PolicyNum 				INT,
    ChangeDate 				DATE,
    PreviousPremium 		DECIMAL(10,2),
    NewPremium 				DECIMAL(10,2),
    Reason 					TEXT,
    FOREIGN KEY (PolicyNum) REFERENCES Policies(PolicyNum)
);

-- ===================================================
-- ============== ReinsurancePartners Table ==========
-- ===================================================

-- Simulates back-end reinsurance (used by insurance carriers):

CREATE TABLE ReinsurancePartners (
    PartnerID 				INT PRIMARY KEY AUTO_INCREMENT,
    Name 					VARCHAR(100),
    ContactEmail 			VARCHAR(100),
    CoverageLimit 			DECIMAL(12,2),
    Notes 					TEXT
);

-- ===================================================
-- ============== PolicyRenewals Table ===============
-- ===================================================

-- Track auto/manual renewals with history and dates.

CREATE TABLE PolicyRenewals (
    RenewalID 				INT PRIMARY KEY AUTO_INCREMENT,
    PolicyNum 				INT,
    RenewalDate 			DATE,
    NewExpirationDate 		DATE,
    Premium 				DECIMAL(10,2),
    RenewedByAgentID 		INT,
    FOREIGN KEY (PolicyNum) 		REFERENCES Policies(PolicyNum),
    FOREIGN KEY (RenewedByAgentID)  REFERENCES Agents(AgentID)
);

-- ===================================================
-- ============== EmailQueue Table ===================
-- ===================================================

-- For building outbound messaging systems or automation.

CREATE TABLE EmailQueue (
    EmailID 				INT PRIMARY KEY AUTO_INCREMENT,
    UserID 					INT,
    Subemailqueueject 		VARCHAR(255),
    Body 					TEXT,
    ScheduledSend 			DATETIME,
    Sent 					BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (UserID) 	REFERENCES Users(UserID)
);

-- ===================================================
-- ============== PaymentMethods Table ===============
-- ===================================================

-- Let users store multiple credit cards or payment options securely.

CREATE TABLE PaymentMethods (
    PaymentMethodID 		INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID 				INT,
    CardType 				VARCHAR(20), -- e.g. Visa, MasterCard
    Last4Digits 			VARCHAR(4),
    ExpirationDate 			DATE,
    IsDefault 				BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- ===================================================
-- ============== APIKeys Table ======================
-- ===================================================

-- This database can power an app or external service:

CREATE TABLE APIKeys (
    KeyID 					INT PRIMARY KEY AUTO_INCREMENT,
    UserID 					INT,
    APIKeyHash 				VARCHAR(255),
    CreatedAt 				DATETIME DEFAULT CURRENT_TIMESTAMP,
    ExpiresAt 				DATETIME,
    IsActive 				BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (UserID) 	REFERENCES Users(UserID)
);

-- ===================================================
-- ============== Dashboards Table ===================
-- ===================================================

-- Custom user dashboards for metrics and insights

CREATE TABLE Dashboards (
    DashboardID 			INT PRIMARY KEY AUTO_INCREMENT,
    UserID 					INT,
    WidgetName 				VARCHAR(100),
    WidgetType 				ENUM('Chart', 'Table', 'KPI', 'Text'),
    DataSource				VARCHAR(100),
    DisplayOrder 			INT,
    RefreshInterval 		INT, -- in minutes
    LastUpdated 			DATETIME,
    FOREIGN KEY (UserID) 	REFERENCES Users(UserID)
);

-- ===================================================
-- ============== TaxRecords Table ===================
-- ===================================================

-- Store 1099s, policy-related tax entries, etc.

CREATE TABLE TaxRecords (
    TaxRecordID 			INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID 				INT,
    PolicyNum 				INT,
    TaxYear 				YEAR,
    TaxDocumentType 		ENUM('1099-MISC', '1095-B', 'Other'),
    DocumentPath 			VARCHAR(500),
    GeneratedDate 			DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (PolicyNum)  REFERENCES Policies(PolicyNum)
);

-- ===================================================
-- ============== ThirdPartyVendors Table ============
-- ===================================================

-- Track repair shops, legal advisors, medical evaluators

CREATE TABLE ThirdPartyVendors (
    VendorID 				INT PRIMARY KEY AUTO_INCREMENT,
    VendorName 				VARCHAR(100),
    ServiceType 			ENUM('Medical Exam', 'Background Check', 'Document Delivery', 'Marketing', 'Reinsurance', 'IT Services', 'Other'),
    ContactName 			VARCHAR(50),
    Phone 					VARCHAR(20),
    Email 					VARCHAR(100),
    Address 				VARCHAR(255),
    Status 					ENUM('Active', 'Inactive', 'Blacklisted') DEFAULT 'Active',
    Notes 					TEXT
);

-- ===================================================
-- ============== Geolocation Table ==================
-- ===================================================

-- Support risk zoning, local premiums, catastrophe mapping

CREATE TABLE Geolocation (
    GeoID 					INT PRIMARY KEY AUTO_INCREMENT,
    UserID 					INT,
    AgentID					INT,
    OfficeID				INT,
    GeoType 				ENUM('User', 'Agent', 'Office') NOT NULL,
    Latitude 				DECIMAL(9,6) NOT NULL,
    Longitude 				DECIMAL(9,6) NOT NULL,
    GeoTimestamp 			DATETIME DEFAULT CURRENT_TIMESTAMP,
    ZipCode 				VARCHAR(10),
    RiskZone 				VARCHAR(50), -- e.g., 'Flood Zone A', 'Earthquake Zone 3'
    State 					VARCHAR(2),
    City 					VARCHAR(50),
    Country 				VARCHAR(50), 
    RiskLevel 				ENUM('Low', 'Medium', 'High', 'Extreme'),
    LastEvaluated 			DATE,
    FOREIGN KEY (UserID)    REFERENCES Users(UserID),
    FOREIGN KEY (AgentID)   REFERENCES Agents(AgentID),
    FOREIGN KEY (OfficeID)  REFERENCES Offices(OfficeID)
    );


-- Index to quickly filter by the type of geolocation (User, Agent, Office)
CREATE INDEX idx_geotype ON Geolocation(GeoType);

-- Index to improve performance on filtering or reporting by risk level
CREATE INDEX idx_risklevel ON Geolocation(RiskLevel);

-- Index to speed up lookups by ZIP code
CREATE INDEX idx_zipcode ON Geolocation(ZipCode);

-- Indexes on foreign keys (useful for joins)
CREATE INDEX idx_userid ON Geolocation(UserID);
CREATE INDEX idx_agentid ON Geolocation(AgentID);
CREATE INDEX idx_officeid ON Geolocation(OfficeID);	

-- Analytics or filtering by country
CREATE INDEX idx_country ON Geolocation(Country);




