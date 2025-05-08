# Personal Budget App - Architecture Documentation

## Database Schema

### Core Tables

#### households

| Column          | Type        | Constraints                                                                        | Description                                               |
| --------------- | ----------- | ---------------------------------------------------------------------------------- | --------------------------------------------------------- |
| id              | UUID        | PK, default gen_random_uuid()                                                      | Unique identifier                                         |
| name            | TEXT        | NOT NULL                                                                           | Household name                                            |
| created_at      | TIMESTAMPTZ | DEFAULT now()                                                                      | Creation timestamp                                        |
| currency_symbol | TEXT        | NOT NULL, DEFAULT '$'                                                              | Preferred currency symbol                                 |
| symbol_position | TEXT        | NOT NULL, DEFAULT 'before', CHECK (symbol_position IN ('before', 'after', 'none')) | Where to display the symbol (before/after/none)           |
| number_format   | TEXT        | NOT NULL, DEFAULT 'comma', CHECK (number_format IN ('comma', 'plain'))             | Number formatting style (comma: 17,000.50, plain: 170000) |

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
| icon               | TEXT        | NOT NULL, DEFAULT 'payments'                    | Google Material icon name      |
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

#### fn_get_account_balance(p_account_id UUID)

Returns the current balance of an account by adding the initial balance to the sum of all transaction amounts for that account.

```sql
CREATE OR REPLACE FUNCTION public.fn_get_account_balance(p_account_id uuid)
 RETURNS numeric
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
  v_initial_balance NUMERIC;
  v_transactions_sum NUMERIC;
BEGIN
  -- Get initial balance
  SELECT a.initial_balance INTO v_initial_balance
  FROM accounts a
  WHERE a.id = p_account_id;

  -- Get sum of transactions
  SELECT COALESCE(SUM(t.amount), 0) INTO v_transactions_sum
  FROM public.transactions t
  WHERE t.account_id = p_account_id
  AND t.status = 'completed';

  -- Return the sum
  RETURN v_initial_balance + v_transactions_sum;
END;
$function$;
```

#### fn_create_household_for_user(user_id UUID, household_name TEXT)

Creates a new household and adds the user as an owner member.

```sql
CREATE OR REPLACE FUNCTION public.fn_create_household_for_user(user_id uuid, household_name text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
  new_household_id UUID;
BEGIN
  -- Create a new household
  INSERT INTO public.households (name)
  VALUES (household_name)
  RETURNING id INTO new_household_id;

  -- Add the user as an owner
  INSERT INTO public.household_members (household_id, user_id, role)
  VALUES (new_household_id, user_id, 'owner');

  RETURN new_household_id;
END;
$function$;
```

#### fn_ensure_user_in_household(user_id UUID, user_first_name TEXT, target_household_id UUID DEFAULT NULL::uuid)

Ensures a user is part of a household by following these rules:

1. If the user is already in a household, returns that household ID.
2. If a `target_household_id` is provided and exists, adds the user to that household as a member.
3. If no household exists or target doesn't exist, creates a new household with the user as the owner.

This implements a flexible household joining mechanism, defaulting to a new household if no specific target is given.

```sql
CREATE OR REPLACE FUNCTION public.fn_ensure_user_in_household(user_id uuid, user_first_name text, target_household_id uuid DEFAULT NULL::uuid)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
  existing_household_id UUID;
  new_household_id UUID;
  user_household_count INT;
  target_household_exists BOOLEAN;
BEGIN
  -- Check if the user is already in a household
  SELECT COUNT(*) INTO user_household_count
  FROM public.household_members
  WHERE household_members.user_id = fn_ensure_user_in_household.user_id;

  -- If user is already in a household, return that household id
  IF user_household_count > 0 THEN
    SELECT household_id INTO existing_household_id
    FROM public.household_members
    WHERE household_members.user_id = fn_ensure_user_in_household.user_id
    LIMIT 1;
    RETURN existing_household_id;
  END IF;

  -- If a target household ID is provided
  IF target_household_id IS NOT NULL THEN
    -- Check if the target household exists
    SELECT EXISTS (
      SELECT 1 FROM public.households
      WHERE id = target_household_id
    ) INTO target_household_exists;

    IF target_household_exists THEN
      -- Add user as member to existing household
      INSERT INTO public.household_members (household_id, user_id, role)
      VALUES (target_household_id, fn_ensure_user_in_household.user_id, 'member');
      RETURN target_household_id;
    END IF;
  END IF;

  -- Create new household with user as owner
  INSERT INTO public.households (name)
  VALUES (COALESCE(user_first_name, 'My') || '''s Household')
  RETURNING id INTO new_household_id;

  INSERT INTO public.household_members (household_id, user_id, role)
  VALUES (new_household_id, fn_ensure_user_in_household.user_id, 'owner');

  RETURN new_household_id;
END;
$function$;
```

#### fn_check_household_exists(household_id UUID)

Checks if a household with the given ID exists.

```sql
CREATE OR REPLACE FUNCTION public.fn_check_household_exists(household_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.households WHERE id = household_id
  );
END;
$function$;
```

#### fn_create_default_categories_for_household(p_household_id UUID, p_created_by_user_id UUID)

Creates a set of default income and expense categories for a new household.

```sql
CREATE OR REPLACE FUNCTION public.fn_create_default_categories_for_household(p_household_id uuid, p_created_by_user_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  -- Create default income categories
  INSERT INTO public.categories (household_id, created_by_user_id, name, type)
  VALUES
    (p_household_id, p_created_by_user_id, 'Salary', 'income'),
    (p_household_id, p_created_by_user_id, 'Freelance', 'income'),
    (p_household_id, p_created_by_user_id, 'Dividends', 'income'),
    (p_household_id, p_created_by_user_id, 'Gifts', 'income');

  -- Create default expense categories
  INSERT INTO public.categories (household_id, created_by_user_id, name, type)
  VALUES
    (p_household_id, p_created_by_user_id, 'Groceries', 'expense'),
    (p_household_id, p_created_by_user_id, 'Dining', 'expense'),
    (p_household_id, p_created_by_user_id, 'Transportation', 'expense'),
    (p_household_id, p_created_by_user_id, 'Housing', 'expense'),
    (p_household_id, p_created_by_user_id, 'Entertainment', 'expense'),
    (p_household_id, p_created_by_user_id, 'Utilities', 'expense');
END;
$function$;
```

#### fn_ensure_household_has_categories()

Loops through all households and ensures each has default categories, creating them if missing.

```sql
CREATE OR REPLACE FUNCTION public.fn_ensure_household_has_categories()
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
  household_rec RECORD;
  category_count INTEGER;
  owner_id UUID;
BEGIN
  -- Loop through all households
  FOR household_rec IN SELECT id FROM public.households LOOP
    -- Check if the household has categories
    SELECT COUNT(*) INTO category_count
    FROM public.categories
    WHERE household_id = household_rec.id;

    -- If no categories, create them using the household owner's ID
    IF category_count = 0 THEN
      -- Find the owner of the household
      SELECT user_id INTO owner_id
      FROM public.household_members
      WHERE household_id = household_rec.id AND role = 'owner'
      LIMIT 1;

      -- If no owner found, use any member
      IF owner_id IS NULL THEN
        SELECT user_id INTO owner_id
        FROM public.household_members
        WHERE household_id = household_rec.id
        LIMIT 1;
      END IF;

      -- Create default categories if we found a user
      IF owner_id IS NOT NULL THEN
        PERFORM public.fn_create_default_categories_for_household(household_rec.id, owner_id);
      END IF;
    END IF;
  END LOOP;
END;
$function$;
```

#### is_household_member(household_uuid UUID)

Checks if the currently authenticated user is a member of the specified household.

```sql
CREATE OR REPLACE FUNCTION public.is_household_member(household_uuid uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM public.household_members
    WHERE household_id = household_uuid
    AND user_id = auth.uid()
  );
END;
$function$;
```

#### is_household_owner(household_uuid UUID)

Checks if the currently authenticated user is an owner of the specified household.

```sql
CREATE OR REPLACE FUNCTION public.is_household_owner(household_uuid uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  RETURN EXISTS (
    SELECT 1
    FROM public.household_members
    WHERE household_id = household_uuid
    AND user_id = auth.uid()
    AND role = 'owner'
  );
END;
$function$;
```

## Implementation Notes

### Phase 1 Implementation Details

The database schema has been fully implemented in Supabase, including:

1. All tables created with appropriate constraints and relationships
2. Default account types added (Cash, Credit Card, Bank Deposit, Loan)
3. Database functions implemented for account balance calculations and household creation/management
4. Row Level Security (RLS) enabled on all tables with appropriate policies to ensure data security and privacy
5. Unique constraints and foreign key relationships established for data integrity

### MVV Simplification: Single-Household Approach

For the MVP implementation, we've simplified the application to use a single-household approach:

1. There is only ever ONE household that all users will be part of
2. The first user to register becomes the owner of the household
3. All subsequent users will automatically become members of the existing household
4. This eliminates the need for household switching, while still allowing users to collaborate

This is a temporary design choice to simplify the MVP implementation. Future versions will add support for multiple households per user.

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
   - SettingsPage - User preferences and app settings (now includes: manage categories, currency symbol, symbol position, number formatting)
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
