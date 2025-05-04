# Personal Budget App - MVP Implementation Plan

**Version:** 1.0
**Date:** 2025-04-26

**Objective:** This document provides step-by-step instructions for AI developers to build the Minimum Viable Product (MVP) of the Personal Budget App. It focuses strictly on the "Must Have" features defined in the Product Requirements Document (`product-requirements-document.md`), adhering to the Tech Stack (`tech-stack.md`)

**Core Technologies:**

- **Frontend:** Quasar Framework v2 (with Vue 3 Composition API)
- **Backend:** Supabase (PostgreSQL, Auth, PostgREST API)
- **State Management:** Pinia

**Reminders for Developers:**

- **ALWAYS** consult `memory-bank/product-requirements-document.md` before implementing any feature.
- **ALWAYS** consult `memory-bank/architecture.md` (especially the database schema) before writing code that interacts with the database.
- **UPDATE** `memory-bank/architecture.md` after completing major features or milestones, particularly schema changes or significant component additions.
- **UPDATE** `memory-bank/progress.md` as features are implemented to track development progress.
- Prioritize **"Must Have"** features only for this MVP plan.

---

## Phase 1: Project Setup & Backend Initialization

**Goal:** Establish the foundational project structure, connect to the backend, and define the core database schema.

1.  **Initialize Quasar Project:**
    - **Instruction:** Use the Quasar CLI to create a new project. Select: Quasar v2, Vue 3, Composition API, Pinia, ESLint (with Prettier), Sass with SCSS syntax, Capacitor mode. Name the project appropriately (e.g., `personal-budget-app`).
    - **Test:** Run `quasar dev -m capacitor -T android` (or `-T ios`). Verify the default Quasar app launches successfully on an emulator or device without errors. Check that Pinia is configured.
2.  **Set Up Supabase Project:**
    - **Instruction:** Create a new project within your Supabase account. Choose a suitable region. Once created, navigate to Project Settings -> API and copy the Project URL and the `anon` (public) key.
    - **Test:** Confirm you can access the Supabase dashboard, including the Table Editor and SQL Editor for the new project.
3.  **Integrate Supabase Client:**
    - **Instruction:** Install the Supabase JavaScript client library: `yarn add @supabase/supabase-js`. Create a Quasar boot file (`src/boot/supabase.js`) to initialize the Supabase client using the copied URL and `anon` key. Ensure this boot file is registered in `quasar.config.js`. Export the initialized client instance for use throughout the app.
    - **Test:** Import the Supabase client instance into a sample Vue component (`src/pages/IndexPage.vue`). Attempt a simple, non-authenticated read operation (e.g., list tables, though this might require specific permissions later). Verify in the browser's developer console that no initialization errors occur and the client object is available.
4.  **Define Core Database Schema (SQL):**
    - **Instruction:** Use the Supabase SQL Editor (`Database` -> `SQL Editor` -> `New query`) to execute SQL statements creating the following tables:
      - `households`: `id` (UUID, PK, default `gen_random_uuid()`), `name` (TEXT, NOT NULL), `created_at` (TIMESTAMPTZ, default `now()`).
      - `household_members`: `household_id` (UUID, NOT NULL, FK to `households(id)`), `user_id` (UUID, NOT NULL, FK to `auth.users(id)`), `role` (TEXT, NOT NULL, DEFAULT 'member', CHECK (`role` IN ('owner', 'member'))), `joined_at` (TIMESTAMPTZ, default `now()`). Add a UNIQUE constraint on (`household_id`, `user_id`).
      - `account_types`: `id` (UUID, PK, default `gen_random_uuid()`), `name` (TEXT, NOT NULL, UNIQUE).
      - `accounts`: `id` (UUID, PK, default `gen_random_uuid()`), `household_id` (UUID, NOT NULL, FK to `households(id)`), `created_by_user_id` (UUID, NOT NULL, FK to `auth.users(id)`), `name` (TEXT, NOT NULL), `account_type_id` (UUID, NOT NULL, FK to `account_types(id)`), `initial_balance` (NUMERIC(10, 2), NOT NULL DEFAULT 0.00), `initial_balance_date` (TIMESTAMPTZ, NOT NULL, DEFAULT `now()`), `created_at` (TIMESTAMPTZ, default `now()`).
      - `categories`: `id` (UUID, PK, default `gen_random_uuid()`), `household_id` (UUID, NOT NULL, FK to `households(id)`), `created_by_user_id` (UUID, NOT NULL, FK to `auth.users(id)`), `name` (TEXT, NOT NULL), `type` (TEXT, NOT NULL CHECK (`type` IN ('income', 'expense'))), `created_at` (TIMESTAMPTZ, default `now()`). Add a UNIQUE constraint on (`household_id`, `name`, `type`).
      - `transactions`: `id` (UUID, PK, default `gen_random_uuid()`), `household_id` (UUID, NOT NULL, FK to `households(id)`), `created_by_user_id` (UUID, NOT NULL, FK to `auth.users(id)`), `account_id` (UUID, NOT NULL, FK to `accounts(id)`), `category_id` (UUID, NULL, FK to `categories(id)`), `amount` (NUMERIC(10, 2), NOT NULL), `description` (TEXT), `transaction_date` (TIMESTAMPTZ, NOT NULL, default `now()`), `status` (TEXT, NOT NULL, DEFAULT 'completed', CHECK (`status` IN ('pending', 'completed', 'canceled'))), `created_at` (TIMESTAMPTZ, default `now()`).
    - **Test:** Navigate to the Supabase Table Editor. Verify all six tables exist with the specified columns, data types, constraints (PK, FK, NOT NULL, CHECK, UNIQUE), and default values.
5.  **Populate `account_types` Table:**
    - **Instruction:** Use the Supabase SQL Editor or Table Editor to insert the required account types into the `account_types` table: ('Cash'), ('Credit Card'), ('Bank Deposit'), ('Loan').
    - **Test:** Query the `account_types` table (`SELECT * FROM account_types;`). Verify the four specified types exist with unique IDs.
6.  **Enable Row Level Security (RLS):**
    - **Instruction:** In the Supabase Dashboard under `Authentication` -> `Policies`, enable RLS for the `households`, `household_members`, `accounts`, `categories`, and `transactions` tables.
    - **Test:** Attempt to query one of the protected tables using the SQL Editor _without_ defining any policies yet. Verify the query returns zero rows, even if data exists, confirming RLS is active.
7.  **Implement Basic RLS Policies:**
    - **Instruction:** For each table, create appropriate policies:
      - `households`: Policies allowing users to view households they're members of.
      - `household_members`: Policies allowing users to view memberships they belong to, only owners can delete.
      - For `accounts`, `categories`, `transactions`: Create policies allowing users to select/insert/update/delete records belonging to households they are members of. For delete operations, check if the user is the owner of the household.
    - **Test:** Use the Supabase SQL Editor's "Run as authenticated user" feature to test policies. Verify a user can only access data related to households they are members of.
8.  **Create Database Functions:**
    - **Instruction:** Create the following PostgreSQL functions:
      - `fn_get_account_balance(account_id UUID)`: Calculates account balance as defined in the architecture.md document.
      - `fn_create_household_for_user(user_id UUID, household_name TEXT)`: Creates a household and adds the user as owner.
    - **Test:** Test each function by calling it with appropriate parameters and verifying the results.

## Phase 2: Authentication & Core UI Structure

**Goal:** Implement user sign-up/login, automatic household creation, and establish the main navigation and layout structure.

1.  **Create Authentication Pages:**
    - **Instruction:** Create two Vue components/pages: `LoginPage.vue` and `RegisterPage.vue`. Use Quasar components (`QPage`, `QForm`, `QInput`, `QBtn`, `QCard`) to build the forms for email/password input. Implement basic password validation (length > 8 characters).
    - **Test:** Create basic routes for `/login` and `/register` in `src/router/routes.js`. Run the app and navigate to these routes. Verify the forms render correctly without errors and password validation works.
2.  **Implement Registration Logic:**
    - **Instruction:** In `RegisterPage.vue`, add logic using the Supabase client's `supabase.auth.signUp()` method. Handle potential errors (e.g., user already exists, weak password) and provide user feedback (e.g., using Quasar's `Notify` plugin). On success, redirect to a confirmation/login page.
    - **Test:** Use the registration form to create a new user with a valid email and password. Check the Supabase `auth.users` table to confirm the user record was created. Verify appropriate feedback is shown on success or failure.
3.  **Implement Household Creation on Registration:**
    - **Instruction:** Create a Supabase database trigger or client-side logic that automatically creates a new household for each newly registered user. Use the `fn_create_household_for_user` function, naming the household "My Household" by default. This should be executed after successful registration.
    - **Test:** Register a new user. Verify a new household is created in the `households` table and the user is added as an owner in the `household_members` table.
4.  **Implement Login Logic:**
    - **Instruction:** In `LoginPage.vue`, add logic using `supabase.auth.signInWithPassword()`. Handle errors (e.g., invalid credentials) and provide feedback. On successful login, redirect the user to the main application dashboard/home page (e.g., `/`).
    - **Test:** Use the login form with the credentials created in the previous step. Verify successful login redirects to the main app page. Test with incorrect credentials and verify an appropriate error message is shown.
5.  **Set Up Pinia Auth Store:**
    - **Instruction:** Create a Pinia store (`src/stores/auth-store.js`). Define state properties for `user` (to hold user metadata) and `isAuthenticated` (boolean). Create actions for `login`, `register`, `logout`, and `checkAuth`. Use `supabase.auth.onAuthStateChange` to listen for auth events and update the store state.
    - **Test:** Log in. Verify the `authStore.isAuthenticated` state becomes true and `authStore.user` contains user data. Refresh the page; verify the state remains logged in.
6.  **Set Up Pinia Household Store:**
    - **Instruction:** Create a Pinia store (`src/stores/household-store.js`). Define state properties for `currentHousehold` and `members`. Create actions for fetching the user's household, fetching members, and inviting members.
    - **Test:** After login, verify the `householdStore.currentHousehold` is populated with the user's household data.
7.  **Create Main Application Layout:**
    - **Instruction:** Modify `src/layouts/MainLayout.vue`. Use `QLayout`, `QHeader`, `QToolbar`, `QToolbarTitle`, `QPageContainer`. Add a logout button in the header that calls the `logout` action from the Pinia store. Use `v-if="authStore.isAuthenticated"` to conditionally show the main layout content and logout button.
    - **Test:** Log in. Verify the main layout (header, etc.) is displayed. Verify the logout button is visible and functional, logging the user out and updating the UI (e.g., redirecting to login).
8.  **Implement Route Guards:**
    - **Instruction:** In `src/router/index.js`, use Vue Router's `beforeEach` navigation guard. Check the `authStore.isAuthenticated` state. If the target route requires authentication and the user is not authenticated, redirect them to `/login`. If the user is authenticated and tries to access `/login` or `/register`, redirect them to the main app page (`/`).
    - **Test:** Log out. Attempt to access the main app page directly via URL; verify redirection to `/login`. Log in. Attempt to access `/login` directly; verify redirection to `/`.

## Phase 3: Account Management ("Must Have" Features)

**Goal:** Implement functionality for users to view, add, edit, and delete financial accounts within their household.

1.  **Create Account List Component:**
    - **Instruction:** Create a component (`components/AccountList.vue`) or integrate directly into a page (`pages/AccountsPage.vue`). Use the household store to get the current household ID. Fetch accounts for that household from Supabase (`select *, account_types(name) from accounts where household_id = :householdId`) within the accountStore or component setup. Display the accounts using `QList` and `QItem`, showing the account name and its type name.
    - **Test:** Manually insert a test account for the user's household via the Supabase Table Editor. Navigate to the accounts page/view. Verify the test account is displayed with its name and type.
2.  **Create Add/Edit Account Dialog/Form:**
    - **Instruction:** Create a reusable component (`components/AccountForm.vue`) or use a `QDialog`. Include fields for Account Name (`QInput`), Account Type (`QSelect`), Initial Balance (`QInput` type number, use `step="0.01"`), and Initial Balance Date (`QDate`). Populate the `QSelect` options by fetching data from the `account_types` table. Implement logic to either `insert` a new account or `update` an existing one, ensuring `household_id` and `created_by_user_id` are set correctly.
    - **Test:** Trigger the 'Add Account' action. Fill in the form and submit. Verify the new account appears in the Account List component with the correct creator. Trigger the 'Edit Account' action for an existing account. Modify values and save. Verify the list updates with the new values.
3.  **Implement Account List View:**
    - **Instruction:** Integrate the `AccountList.vue` component into the main accounts page. Add a button ("Add Account") to trigger the display of the `AccountForm.vue` dialog/component in 'add' mode. Add an 'edit' icon/button to each item in the `QList` that triggers the same form but in 'edit' mode, pre-filled with the selected account's data.
    - **Test:** Navigate to the accounts page. Verify the list of accounts is displayed. Click "Add Account", fill, save; verify list updates. Click 'edit' on an account, change data, save; verify list updates.
4.  **Implement Account Deletion:**
    - **Instruction:** Add a 'delete' icon/button to each account item. On click, show a confirmation dialog (use Quasar's `Dialog` plugin). If confirmed, check if the user is the household owner, then call the Supabase client to `delete` the account record. If the user is not the owner, show a message indicating only the household owner can delete accounts.
    - **Test:** Log in as the household owner. Click the delete icon on an account. Verify the confirmation dialog appears. Confirm deletion and verify the account is removed. Log in as a regular member and verify the delete option is disabled or shows an appropriate message.
5.  **Display Account Balances (Using Database Function):**
    - **Instruction:** Modify the query that fetches accounts to include the calculated balance using the `fn_get_account_balance` function. For each account item, display this calculated balance, formatted as currency. Implement visual differentiation for negative balances using Quasar's `text-positive` class for positive/zero values and `text-negative` for negative values.
    - **Test:** Create accounts with various initial balances. Add transactions to these accounts (some with 'completed' status, some with 'pending'). Verify the displayed balances correctly reflect the initial balance plus only the 'completed' transactions and use the appropriate positive/negative styling.
6.  **Display Total Balance (Using Calculated Balances):**
    - **Instruction:** Add a summary section on the accounts page or in the main layout header. Calculate the sum of the calculated balances (from the previous step) and show it, formatted as currency, with Quasar's `text-positive`/`text-negative` classes for positive/negative totals.
    - **Test:** Verify the displayed total balance correctly sums the calculated balances shown in the list and applies appropriate formatting/styling for positive/negative totals.

## Phase 4: Transaction Management ("Must Have" Features)

**Goal:** Enable household members to add, view, and edit income and expense transactions linked to their accounts.

1.  **Create Category Management (Basic Add/View):**
    - **Instruction:** Create a simple settings page or section (`pages/CategoriesPage.vue`). Use the household store to get the current household ID. Fetch and display the household's existing categories (`select * from categories where household_id = :householdId`). Add a form (`QInput` for name, `QSelect` for type 'income'/'expense') and button to `insert` new categories, ensuring `household_id` and `created_by_user_id` are set correctly.
    - **Test:** Navigate to the categories page. Add new 'income' and 'expense' categories. Verify they appear in the list on the page and exist in the Supabase `categories` table linked to the correct household.
2.  **Create Add/Edit Transaction Dialog/Form:**
    - **Instruction:** Create a reusable component (`components/TransactionForm.vue`) or `QDialog`. Include fields for: Account (`QSelect` populated from household's accounts), Category (`QSelect` populated from household's categories), Amount (`QInput` type number), Description (`QInput` type textarea), Date (`QDate`), and Status (`QSelect` with options: 'pending', 'completed', 'canceled', defaulting to 'completed'). On submit, `insert` or `update` the `transactions` table, ensuring `household_id`, `created_by_user_id`, `account_id`, and `category_id` are set correctly. For expense transactions, ensure the amount is stored as negative in the database.
    - **Test:** Trigger the 'Add Transaction' action. Fill the form for an income transaction and save. Verify the record exists in the `transactions` table with correct foreign keys, status, and creator. Create an expense transaction; verify its amount is stored as negative. Trigger 'Edit', modify details, save. Verify the record is updated in Supabase.
3.  **Create Transaction List View (Per Account):**
    - **Instruction:** Create a view or component (`pages/AccountDetailPage.vue` or `components/TransactionList.vue`) that accepts an `account_id` as a prop or route parameter. Fetch transactions for that specific account (`select t.*, c.name as category_name, c.type as category_type, u.email as created_by from transactions t left join categories c on t.category_id = c.id left join auth.users u on t.created_by_user_id = u.id where t.account_id = :accountId order by t.transaction_date desc`). Display transactions using `QList`, showing Date, Category Name, Description, Status, Amount, and who created it.
    - **Test:** Navigate to the detail view for an account where transactions were added. Verify all transactions for _only_ that account are listed, ordered by date descending, and show the correct details (including who created each transaction).
4.  **Integrate Add/Edit Transaction Functionality:**
    - **Instruction:** On the `AccountDetailPage.vue` (or similar), add an "Add Transaction" button that opens the `TransactionForm.vue` in 'add' mode, pre-selecting the current account. Add an 'edit' icon/button to each transaction item in the list, opening the form in 'edit' mode, pre-filled with transaction data. Ensure the transaction list refreshes after adding/editing.
    - **Test:** From an account's detail view, add a new transaction; verify it appears in the list. Edit an existing transaction from the list; verify its details update in the list.
5.  **Apply Transaction Color Coding:**
    - **Instruction:** In the transaction list display, use Quasar's `text-positive` class for income transactions (positive amounts) and `text-negative` class for expense transactions (negative amounts) to apply color coding to the amount as per PRD.
    - **Test:** Add both income and expense transactions. Verify their amounts are displayed with the correct Quasar classes in the transaction list according to their sign.

## Phase 5: Budget Overview & Calculations ("Must Have" Features)

**Goal:** Calculate actual balances based on transactions and provide a basic monthly income/expense summary for the household.

1.  **Calculate Actual Account Balances (Using DB Function):**
    - **Instruction:** Use the PostgreSQL function `fn_get_account_balance(acc_id uuid)` created in Phase 1 to get the actual balance for each account. Modify the Supabase query used in the `AccountList.vue` component to include this calculated balance.
    - **Test:** Add several income and expense transactions to an account, with different status values. Navigate to the Account List view. Verify the displayed balance for that account accurately reflects the `initial_balance` adjusted by the sum of only the 'completed' transactions. Manually calculate to confirm.
2.  **Update Total Balance Calculation:**
    - **Instruction:** Modify the total balance calculation (from Phase 3, Step 6) to sum the calculated balances of all accounts from the database function.
    - **Test:** Add transactions with different status values affecting multiple accounts. Verify the total balance display updates correctly and reflects the sum of the individual actual account balances, excluding 'pending' or 'canceled' transactions.
3.  **Create Budget Overview Page:**
    - **Instruction:** Create a new page (`pages/OverviewPage.vue`). Add basic routing for it, making it the default landing page after login.
    - **Test:** Navigate to the new overview page. Verify it renders without errors.
4.  **Implement Time Period Selection:**
    - **Instruction:** Add controls (e.g., `QTabs`, `QBtnToggle`) to the `OverviewPage.vue` for selecting "Daily", "Weekly", "Monthly", "Yearly" views. Set "Monthly" as the default view. Store the selected view in a Pinia store (`uiStore`) to persist the selection across views.
    - **Test:** Verify the time period selection controls are visible on the Overview page with "Monthly" selected by default. Click each option and verify the selection updates in the UI and the store.
5.  **Implement Monthly Income vs. Expense Summary:**
    - **Instruction:** On the `OverviewPage.vue`, use the household store to get the current household ID. Fetch all 'completed' transactions for that household within the _current calendar month_. Calculate the sum of amounts for income transactions (positive amounts) and the sum for expense transactions (negative amounts) within that period. Display these two totals clearly labeled (e.g., "Monthly Income", "Monthly Expenses").
    - **Test:** Add several income and expense transactions with different status values dated within the current month. Add some transactions dated in previous/future months. Navigate to the Overview page. Verify the displayed totals _only_ include 'completed' transactions from the current month and match manually calculated sums.

## Phase 5b: Settings & Personalization

**Goal:** Provide users with a centralized settings page for app personalization and category management.

1.  **Create Settings Page:**
    - **Instruction:** Add a new page (`pages/SettingsPage.vue`) accessible from the main navigation. This page will serve as the hub for user preferences and personalization options.
    - **Test:** Navigate to the settings page from the app menu. Verify the page loads and displays user settings options.
2.  **Manage Categories from Settings:**
    - **Instruction:** Move category management UI to the settings page, allowing users to add, edit, and remove categories directly from settings.
    - **Test:** Add, edit, and remove categories from the settings page. Verify changes are reflected in the database and throughout the app.
3.  **Currency Symbol Selection:**
    - **Instruction:** Add a control for users to select their preferred currency symbol (e.g., $, €, £, etc.).
    - **Test:** Change the currency symbol in settings. Verify the new symbol appears throughout the app where amounts are displayed.
4.  **Symbol Position (before/after/none):**
    - **Instruction:** Allow users to choose whether the currency symbol appears before, after, or not at all with amounts.
    - **Test:** Change the symbol position in settings. Verify the position updates in all relevant UI.
5.  **Number Formatting (comma/plain):**
    - **Instruction:** Allow users to choose between comma-separated (17,000.50) or plain (170000) number formatting.
    - **Test:** Change the number formatting in settings. Verify the formatting updates throughout the app.

## Phase 6: Household Collaboration

**Goal:** Implement functionality for household owners to invite and manage members.

1.  **Create Household Members Page:**
    - **Instruction:** Create a new page (`pages/HouseholdMembersPage.vue`). Add it to the navigation menu in the main layout. Use the household store to fetch and display the current members of the user's household. Show each member's email and role (owner/member). If the logged-in user is the household owner, display controls for managing members.
    - **Test:** Navigate to the Household Members page. Verify the list shows all current members with their correct roles. Verify that management controls are only visible to the household owner.
2.  **Implement Member Invitation:**
    - **Instruction:** For household owners, add a form to the `HouseholdMembersPage.vue` with an input field for email address and an "Invite" button. When submitted, check if the email exists in the system. If it does, add the user to the `household_members` table with role 'member'. If not, implement a mechanism to send an invitation email (this can be simplified for MVP).
    - **Test:** Log in as the household owner. Enter an existing user's email and click "Invite". Verify the user is added to the household_members table. Try inviting a non-existent user and verify appropriate feedback is shown.
3.  **Implement Member Removal:**
    - **Instruction:** For household owners, add a "Remove" button next to each member in the list (except for the owner themselves). When clicked, show a confirmation dialog. If confirmed, delete the corresponding record from the `household_members` table.
    - **Test:** Log in as the household owner. Click "Remove" for a member. Confirm the removal and verify the member is removed from the list and the database. Verify that the owner cannot remove themselves.
4.  **Add Creator Information to UI:**
    - **Instruction:** Modify the account list, transaction list, and category list components to display who created each item (using the `created_by_user_id` field). This can be shown as a small avatar, initials, or simply the email address/name of the creator.
    - **Test:** Create accounts, transactions, and categories with different users. Verify that each item in the lists shows the correct creator information.
5.  **Implement Basic Activity Log:**
    - **Instruction:** Add a simple activity log section to the Household Members page showing recent actions (account/category/transaction creations, edits, deletions) by household members. Fetch this data from the various tables using the `created_at` and `created_by_user_id` fields.
    - **Test:** Perform various actions as different household members. Verify the activity log shows these actions with the correct user information and timestamps.

---

**Next Steps (Post-MVP):** Implement "Should Have" features (recurring transactions, delete transactions, custom account names), refine UI/UX based on mockups (e.g., progress indicators), add search, implement remaining time period views, enhance error handling, write tests, and prepare for deployment. Consider implementing real-time collaboration features using Supabase Realtime.
