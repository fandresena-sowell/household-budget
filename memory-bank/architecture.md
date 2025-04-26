# Personal Budget App - Architecture Documentation

## Database Schema

### Core Tables

#### households

| Column     | Type        | Constraints                   | Description        |
| ---------- | ----------- | ----------------------------- | ------------------ |
| id         | UUID        | PK, default gen_random_uuid() | Unique identifier  |
| name       | TEXT        | NOT NULL                      | Household name     |
| created_at | TIMESTAMPTZ | DEFAULT now()                 | Creation timestamp |

#### household_members

| Column       | Type        | Constraints                                                     | Description                   |
| ------------ | ----------- | --------------------------------------------------------------- | ----------------------------- |
| household_id | UUID        | NOT NULL, FK to households(id)                                  | Associated household          |
| user_id      | UUID        | NOT NULL, FK to auth.users(id)                                  | Member user                   |
| role         | TEXT        | NOT NULL, DEFAULT 'member', CHECK (role IN ('owner', 'member')) | Permission level              |
| joined_at    | TIMESTAMPTZ | DEFAULT now()                                                   | When user joined              |
| UNIQUE       |             | (household_id, user_id)                                         | Prevents duplicate membership |

#### account_types

| Column | Type | Constraints                   | Description                                       |
| ------ | ---- | ----------------------------- | ------------------------------------------------- |
| id     | UUID | PK, default gen_random_uuid() | Unique identifier                                 |
| name   | TEXT | NOT NULL, UNIQUE              | Type name (Cash, Credit Card, Bank Deposit, Loan) |

#### accounts

| Column               | Type           | Constraints                       | Description                   |
| -------------------- | -------------- | --------------------------------- | ----------------------------- |
| id                   | UUID           | PK, default gen_random_uuid()     | Unique identifier             |
| household_id         | UUID           | NOT NULL, FK to households(id)    | Household owning this account |
| created_by_user_id   | UUID           | NOT NULL, FK to auth.users(id)    | User who created the account  |
| name                 | TEXT           | NOT NULL                          | Account name                  |
| account_type_id      | UUID           | NOT NULL, FK to account_types(id) | Type of account               |
| initial_balance      | NUMERIC(10, 2) | NOT NULL, DEFAULT 0.00            | Starting balance              |
| initial_balance_date | TIMESTAMPTZ    | NOT NULL, DEFAULT now()           | Date of the initial balance   |
| created_at           | TIMESTAMPTZ    | DEFAULT now()                     | Account creation timestamp    |

#### categories

| Column             | Type        | Constraints                                     | Description                    |
| ------------------ | ----------- | ----------------------------------------------- | ------------------------------ |
| id                 | UUID        | PK, default gen_random_uuid()                   | Unique identifier              |
| household_id       | UUID        | NOT NULL, FK to households(id)                  | Household owning this category |
| created_by_user_id | UUID        | NOT NULL, FK to auth.users(id)                  | User who created the category  |
| name               | TEXT        | NOT NULL                                        | Category name                  |
| type               | TEXT        | NOT NULL, CHECK (type IN ('income', 'expense')) | Category type                  |
| created_at         | TIMESTAMPTZ | DEFAULT now()                                   | Category creation timestamp    |
| UNIQUE             |             | (household_id, name, type)                      | Prevents duplicate categories  |

#### transactions

| Column             | Type           | Constraints                                                                           | Description                                |
| ------------------ | -------------- | ------------------------------------------------------------------------------------- | ------------------------------------------ |
| id                 | UUID           | PK, default gen_random_uuid()                                                         | Unique identifier                          |
| household_id       | UUID           | NOT NULL, FK to households(id)                                                        | Household owning this transaction          |
| created_by_user_id | UUID           | NOT NULL, FK to auth.users(id)                                                        | User who created the transaction           |
| account_id         | UUID           | NOT NULL, FK to accounts(id)                                                          | Associated account                         |
| category_id        | UUID           | NULL, FK to categories(id)                                                            | Associated category (optional)             |
| amount             | NUMERIC(10, 2) | NOT NULL                                                                              | Transaction amount (negative for expenses) |
| description        | TEXT           |                                                                                       | Optional description                       |
| transaction_date   | TIMESTAMPTZ    | NOT NULL, DEFAULT now()                                                               | When the transaction occurred              |
| status             | TEXT           | NOT NULL, DEFAULT 'completed', CHECK (status IN ('pending', 'completed', 'canceled')) | Transaction status                         |
| created_at         | TIMESTAMPTZ    | DEFAULT now()                                                                         | Transaction creation timestamp             |

### Database Functions

#### fn_get_account_balance(account_id UUID)

Returns the current balance of an account by adding the initial balance to the sum of all transaction amounts for that account.

```sql
CREATE OR REPLACE FUNCTION fn_get_account_balance(account_id UUID)
RETURNS NUMERIC AS $$
DECLARE
  initial_balance NUMERIC;
  transactions_sum NUMERIC;
BEGIN
  -- Get initial balance
  SELECT a.initial_balance INTO initial_balance
  FROM accounts a
  WHERE a.id = account_id;

  -- Get sum of transactions
  SELECT COALESCE(SUM(t.amount), 0) INTO transactions_sum
  FROM transactions t
  WHERE t.account_id = account_id
  AND t.status = 'completed';

  -- Return the sum
  RETURN initial_balance + transactions_sum;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

#### fn_create_household_for_user(user_id UUID, household_name TEXT)

Creates a new household and adds the user as an owner member.

```sql
CREATE OR REPLACE FUNCTION fn_create_household_for_user(user_id UUID, household_name TEXT)
RETURNS UUID AS $$
DECLARE
  new_household_id UUID;
BEGIN
  -- Create a new household
  INSERT INTO households (name)
  VALUES (household_name)
  RETURNING id INTO new_household_id;

  -- Add the user as an owner
  INSERT INTO household_members (household_id, user_id, role)
  VALUES (new_household_id, user_id, 'owner');

  RETURN new_household_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

### Row Level Security (RLS) Policies

All user data tables (`accounts`, `categories`, `transactions`) have RLS enabled with the following policies:

1. Users can `SELECT` only their own records
2. Users can `INSERT` records only with their own user_id
3. Users can `UPDATE` only their own records
4. Users can `DELETE` only their own records

## Frontend Architecture

The application follows a standard Quasar/Vue 3 architecture with Composition API and Pinia for state management:

### Core Components

1. **Layouts**

   - MainLayout - Base layout for authenticated users
   - AuthLayout - Simplified layout for login/register pages

2. **Pages**

   - HomePage - Dashboard/overview page
   - AccountsPage - List of all accounts
   - AccountDetailPage - Single account with transactions
   - CategoriesPage - Category management
   - LoginPage - User login
   - RegisterPage - User registration
   - SettingsPage - User preferences and app settings
   - HouseholdMembersPage - Manage household members

3. **Components**
   - AccountList - Displays user accounts with balances
   - AccountForm - Add/edit account form
   - TransactionList - Displays transactions for an account
   - TransactionForm - Add/edit transaction form
   - CategoryList - Displays user categories
   - CategoryForm - Add/edit category form
   - BalanceSummary - Shows total balance across accounts
   - MemberList - Shows household members
   - MemberInviteForm - Form to invite new members

### Pinia Stores

1. **authStore** - Manages authentication state and user details
2. **householdStore** - Manages household data and member operations
3. **accountStore** - Manages account data and operations
4. **transactionStore** - Manages transaction data and operations
5. **categoryStore** - Manages category data and operations
6. **uiStore** - Manages UI state like selected time period

### API Integration

Uses Supabase client for:

- Authentication (signup, login, password reset)
- Data operations through PostgREST/GraphQL
- Realtime updates (future enhancement)
