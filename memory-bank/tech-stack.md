# **Personal Budget App \- Tech Stack**

This document outlines the chosen technology stack for the Personal Budget App project, based on the Product Requirements Document (PRD) and subsequent analysis.

## **1\. Frontend**

- **Framework:** **Quasar Framework (v2)**
  - **Underlying Library:** Vue.js (v3)
  - **Rationale:**
    - Explicitly required by the project constraints.
    - Enables building Mobile (via Capacitor/Cordova), Web (SPA, PWA, SSR), and Desktop applications from a single codebase, aligning with the "mobile-first" approach and potential future web access.
    - Provides a rich set of pre-built UI components suitable for the required interface elements.
    - Strong community support and good documentation.

## **2\. Backend (BaaS \- Backend-as-a-Service)**

- **Platform:** **Supabase**
  - **Rationale:**
    - Provides a comprehensive suite of backend services (Database, Auth, API, Functions, Storage) in a managed cloud environment, fulfilling the cloud-based requirement.
    - Accelerates development significantly compared to building a custom backend from scratch.
    - Offers a good balance of features, ease of use, scalability, and predictable pricing for the MVP and future growth.
    - Built on open-source foundations, reducing vendor lock-in concerns compared to some alternatives.

## **3\. Database**

- **Type:** **PostgreSQL** (Managed by Supabase)
  - **Rationale:**
    - SQL (Relational) database structure is well-suited for the inherently relational nature of financial data (accounts, transactions, categories, users).
    - Ensures data integrity through schemas and constraints.
    - Supports powerful SQL queries required for financial summaries, filtering, and future reporting/analytics features.
    - Supabase provides excellent integration with PostgreSQL, including Row Level Security.

## **4\. API Layer**

- **Primary:** **Auto-generated REST (PostgREST) & GraphQL (pg_graphql) APIs** (Provided by Supabase)
  - **Rationale:**
    - Automatically creates API endpoints based on the PostgreSQL schema, drastically reducing the need for boilerplate backend code for standard CRUD (Create, Read, Update, Delete) operations.
    - Provides immediate, documented API access for the Quasar frontend.
- **Secondary (for custom logic):** **Supabase Edge Functions** (Deno/TypeScript runtime)
  - **Rationale:**
    - Allows writing custom server-side logic for operations that go beyond simple CRUD (e.g., complex calculations, third-party integrations, specific business rules).
    - Serverless execution model, scales automatically.

## **5\. Authentication**

- **Service:** **Supabase Auth**
  - **Rationale:**
    - Provides secure user management (signup, login, password recovery, social logins).
    - Integrates seamlessly with Supabase's database and Row Level Security features for data protection.
    - Uses industry-standard JWTs (JSON Web Tokens).
    - Open-source core (GoTrue).

## **6\. Real-time Capabilities**

- **Service:** **Supabase Realtime Subscriptions**
  - **Rationale:**
    - Leverages PostgreSQL's logical replication to enable real-time updates in the application.
    - Essential for the planned future feature of cloud synchronization across multiple devices.

## **7\. Deployment**

- **Frontend (Quasar App):**
  - **Build Target:** SPA (Single Page App) or PWA (Progressive Web App) for web; Capacitor build for native mobile apps (iOS/Android).
  - **Hosting (Web):** Static web hosting providers like Netlify, Vercel, AWS S3/CloudFront, Firebase Hosting, or Cloudflare Pages.
  - **Hosting (Mobile):** Apple App Store, Google Play Store.
- **Backend (Supabase):**
  - **Hosting:** Fully managed by Supabase cloud infrastructure. No direct server management required.
