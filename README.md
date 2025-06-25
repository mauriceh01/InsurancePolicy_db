# EnterpriseInsuranceSystem

A comprehensive, enterprise-grade relational database system for managing the full lifecycle of insurance operations. Designed in MySQL, this schema includes over 40 interrelated tables to support everything from customer onboarding and policy management to claims processing, underwriting, reinsurance, CRM, taxation, geolocation tracking, and more.

---

## 📌 Project Overview

The **EnterpriseInsuranceSystem** simulates a real-world back-end infrastructure for a modern insurance company. It is built for scalability, modularity, and real-world business logic, designed to support internal operations, agent activity, customer interactions, and administrative workflows.

---

## 🔍 Features

- 🔐 **User & Role Management:** Support for Customers, Agents, Admins, and system-level logins.
- 📑 **Policy Lifecycle:** Issue, renew, endorse, and manage insurance policies.
- 💸 **Payments & Invoicing:** Track billing, payment methods, invoices, and premium history.
- 📄 **Claims & Underwriting:** Handle claims processing, claim documents, underwriting decisions, and disputes.
- 🚗 **Vehicle & Driver Support:** Manage auto-related data tied to policies.
- 🧾 **Tax & Legal Compliance:** Store 1099s, legal disputes, and document history.
- 📊 **Dashboards & Reporting:** Support for user dashboards and KPIs.
- 🌐 **Geolocation Services:** Track physical locations for users, agents, and offices; support risk zoning.
- 🧠 **CRM & Marketing:** Manage leads, campaigns, and customer interactions.
- 🤝 **3rd Party Vendors:** Integrate external vendors like adjusters, marketing, IT services, and reinsurance partners.
- 🔄 **Audit Logs & Tasks:** Track system activity, outstanding work, and security logs.
- 📤 **Email & Notification Systems:** Queue outbound messages and show login alerts.

---

## 🧱 Schema Structure

### Key Entities:
- `Customers`, `Agents`, `Users`, `Admins`, `Offices`
- `Policies`, `Claims`, `Payments`, `Invoices`, `PolicyRenewals`
- `Coverage`, `Beneficiaries`, `Underwriting`, `Drivers`, `Vehicles`
- `MarketingCampaigns`, `Leads`, `CampaignRecipients`
- `Geolocation`, `Tasks`, `Documents`, `ClaimDocuments`, `AuditLogs`
- `ThirdPartyVendors`, `Appointments`, `Dashboards`, `TaxRecords`
- `LoginAccounts`, `LoginAttempts`, `EmailQueue`, `APIKeys`

---

## 🛠 Tech Stack

- **Database:** MySQL (compatible with MySQL Workbench)
- **Language:** SQL
- **Focus:** Relational modeling, business logic, indexing, referential integrity

---
✅ Status
🟢 Schema Design Complete - As of June 25, 2025
📥 Data Seeding In Progress
📊 Reporting Features: Coming Soon

---
📬 Contact
Maurice Hazan
📧 mauriceh01@hotmail.com 
🔗 LinkedIn: https://www.linkedin.com/in/mohazan
📍San Francisco, CA
