# Project Charter
## Enterprise FinTech Data Platform (EFTP)
### Building a Unified Digital Payments & Financial Transactions Analytics Platform

**Sprint 0 Deliverable** | Enterprise Data Engineering Capstone Project (UC12)
**Client / Business Owner:** ABC FinTech Solutions Ltd.

---

## 1. Project Purpose

ABC FinTech Solutions Ltd. operates UPI payments, digital wallets, merchant payment gateways, QR code transactions, online banking integrations, and bill payment services for millions of customers and merchants. Transaction data is generated independently across Mobile Banking, UPI, Payment Gateways, Digital Wallets, Merchant Portals, CRM, Fraud Detection, KYC, Settlement, and API Gateway Logs systems, with no unified view.

This creates business blind spots in:
- Monitoring transaction success/failure rates
- Detecting payment failures in real time
- Identifying fraudulent activity
- Reconciling settlements across systems
- Understanding customer transaction behavior
- Producing timely, trustworthy executive reporting

**The EFTP project exists to close these gaps** by building a governed, end-to-end data platform that ingests, cleans, stores, and exposes financial transaction data for analytics and decision-making.

---

## 2. Project Objectives

| # | Objective |
|---|---|
| 1 | Collect financial transaction data from 10 heterogeneous enterprise source systems |
| 2 | Clean, validate, and standardize payment and customer data |
| 3 | Store curated datasets in a governed PostgreSQL Data Warehouse (star schema) |
| 4 | Maintain metadata, audit logs, and end-to-end data lineage |
| 5 | Enable payment analytics, fraud monitoring, settlement reconciliation, and executive reporting |
| 6 | Manage all project artifacts through Git/GitHub under Agile Scrum |
| 7 | Produce enterprise-standard technical documentation and sprint deliverables |

---

## 3. Scope

### 3.1 In Scope
- Ingestion of the following source systems: UPI Transaction System, Digital Wallet Platform, Payment Gateway, Merchant Portal, CRM, KYC Verification System, Settlement Processing System, Mobile Banking Application, Fraud Detection System, API Gateway Logs
- Bronze (raw landing) → Silver (trusted/cleansed) → Gold (analytics-ready) data layering in PostgreSQL
- Data profiling, cleansing, and standardization using Python (Pandas)
- ETL/ELT pipeline development and orchestration using Pentaho Data Integration (Spoon)
- Star schema data warehouse design (fact and dimension tables)
- Data governance: metadata repository, lineage documentation, business glossary, audit/controls
- Executive and operational dashboards in Power BI (payment analytics, fraud/reconciliation, KPIs)
- Version control and release management via Git & GitHub
- Sprint-based documentation: BRD, Data Dictionary, Data Quality Report, Lineage Document, Project Report

### 3.2 Out of Scope
- Production deployment to live banking infrastructure
- Real-time streaming at true enterprise transaction volumes (batch/micro-batch simulation only)
- Integration with actual third-party banking/UPI networks
- Mobile or web application development (consumes existing app data only)
- Regulatory certification/compliance sign-off (design follows governance best practice, not formal audit)

---

## 4. Solution Architecture Summary

The platform follows a layered, governed architecture:

```
Source Systems → Bronze (Landing) → Silver (Trusted) → Gold (Analytics) → BI
                        ↑                  ↑                  ↑
                   Governance ──────→ Orchestration ──────→ (feeds BI)
                        ↓                  ↓
                Engineering Tooling    Deployment
```

**Layer descriptions:**

| Layer | Purpose | Key Components |
|---|---|---|
| **Source Systems** | 10 upstream systems (UPI, Wallet, Payment Gateway, Merchant Portal, CRM/KYC, Fraud, API Logs, etc.) | Raw CSV, JSON, XML, Excel, SQL feeds |
| **Bronze / Landing** | Raw, unmodified ingestion | Raw files, JSON/CSV/Excel staging, batch metadata |
| **Silver / Trusted** | Validated, cleansed, standardized data | Validation, cleansing, standardization, confirmed fields |
| **Gold / Analytics** | Curated, analytics-ready data | PostgreSQL Warehouse, data marts, SQL reporting layer |
| **Governance** (cross-cutting) | Trust and traceability across all layers | Metadata, lineage, business glossary, audit/controls |
| **Orchestration** (cross-cutting) | Reliable, repeatable pipeline execution | Pentaho Jobs, schedules, retries, exception handling |
| **BI** | Business consumption layer | Power BI — executive KPIs, payment analytics, fraud/reconciliation reporting |
| **Engineering Tooling** | Supports Governance | Python/SQL, Pentaho, Git/GitHub |
| **Deployment** | Supports Orchestration | Configuration management, environment separation, release tagging, README/docs |
| **Operational Controls** | Supports BI/production readiness | Ongoing monitoring and control of the live platform |

This architecture directly maps to the Sprint 1–3 roadmap: Sprint 1 builds Bronze; Sprint 2 builds Silver/Gold (profiling + warehouse); Sprint 3 adds Governance, Orchestration, and BI.

---

## 5. Technology Stack

| Category | Technology |
|---|---|
| ETL | Pentaho Data Integration (Spoon) |
| Database | PostgreSQL |
| Programming | Python (Pandas) |
| Version Control | Git & GitHub |
| Reporting | Power BI |
| Documentation | Markdown / MS Word |
| Project Management | Agile Scrum |

---

## 6. Stakeholders

| Stakeholder | Interest / Role |
|---|---|
| Business Sponsor (ABC FinTech Leadership) | Owns business outcomes: fraud reduction, reconciliation accuracy, executive visibility |
| Payments Operations Team | Consumes transaction success/failure and settlement reports |
| Fraud & Risk Team | Consumes fraud alert and monitoring analytics |
| Finance / Settlement Team | Relies on settlement reconciliation accuracy |
| Data Engineering Team (Project Team) | Designs and builds ingestion, warehouse, and governance layers |
| Data Governance / Compliance | Owns metadata, lineage, and glossary standards |
| Analytics / BI Consumers | Uses Power BI dashboards for decision-making |
| Project Mentor / Evaluator (L&T EduTech) | Reviews sprint deliverables and DA submissions |

---

## 7. High-Level Timeline (Sprint Roadmap)

| Sprint | Focus | Key Deliverables |
|---|---|---|
| **Sprint 0** | Project Initiation & Architecture | BRD, Solution Architecture, Git Repository, Sprint Backlog, Project Charter |
| **Sprint 1** | Data Discovery & Ingestion (Bronze) | Source Inventory, Data Dictionary, Pentaho ETL Pipelines, Staging Database, Git Commit History |
| **Sprint 2** | Data Profiling & Warehouse (Silver/Gold) | Data Profiling Report, Data Quality Report, Star Schema, PostgreSQL Data Warehouse, SQL Scripts |
| **Sprint 3** | Governance, Lineage & Analytics | Data Lineage Document, Metadata Repository, Pentaho Jobs, Validation Report, Power BI Dashboard, Final Git Release, Project Report, Sprint Presentation |

**Digital Assignment mapping:** DA1 = Sprint 0 & 1 | DA2 = Sprint 2 | DA3 = Sprint 3

---

## 8. Success Criteria

The project is considered successful when:
- All 10 source systems are ingested into Bronze staging with logging/exception handling in place
- Silver-layer data passes defined validation and standardization rules
- A working star schema warehouse (fact + dimension tables) is populated in PostgreSQL
- Data lineage from source-to-target is fully documented
- Power BI dashboards demonstrate payment trends, success/failure rates, merchant performance, customer behavior, and fraud/reconciliation insights
- All code and documentation are version-controlled in Git with a tagged final release
- Sprint deliverables (BRD, Data Dictionary, Data Quality Report, Lineage Document, Project Report) are complete and enterprise-standard

---

## 9. Assumptions & Constraints

- Real production data is not available; representative/simulated datasets will be used for the 10 source systems
- Development occurs in a non-production, sandbox environment
- Team follows Agile Scrum with sprint-based delivery (Sprint 0–3)
- Tooling is fixed per the technology stack above (Pentaho, PostgreSQL, Python, Power BI, Git/GitHub)

---

## 10. Risks

| Risk | Mitigation |
|---|---|
| No real source data available | Simulate realistic datasets per source system (Python/Faker) early in Sprint 1 |
| Schema/format inconsistency across 10 sources | Data Dictionary and profiling in Sprint 1–2 to standardize before warehouse load |
| Scope creep beyond 4-sprint timeline | Strict adherence to defined sprint deliverables; defer extras to backlog |
| Incomplete lineage/governance documentation | Track lineage incrementally each sprint rather than only in Sprint 3 |

---

## 11. Approval

| Role | Name | Sign-off Date |
|---|---|---|
| Project Sponsor | | |
| Data Engineering Lead | | |
| Project Mentor / Evaluator | | |
