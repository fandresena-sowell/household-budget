CREATE OR REPLACE FUNCTION "public"."fn_check_household_exists"("household_id" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.households WHERE id = household_id
  );
END;
$$;
ALTER FUNCTION "public"."fn_check_household_exists"("household_id" "uuid") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."fn_create_default_categories_for_household"("p_household_id" "uuid", "p_created_by_user_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  -- Create default income categories
  INSERT INTO public.categories (household_id, created_by_user_id, name, type, icon)
  VALUES
    (p_household_id, p_created_by_user_id, 'Salary', 'income', 'payments'),
    (p_household_id, p_created_by_user_id, 'Freelance', 'income', 'work'),
    (p_household_id, p_created_by_user_id, 'Dividends', 'income', 'trending_up'),
    (p_household_id, p_created_by_user_id, 'Gifts', 'income', 'redeem');

  -- Create default expense categories
  INSERT INTO public.categories (household_id, created_by_user_id, name, type, icon)
  VALUES
    (p_household_id, p_created_by_user_id, 'Groceries', 'expense', 'shopping_cart'),
    (p_household_id, p_created_by_user_id, 'Dining', 'expense', 'restaurant'),
    (p_household_id, p_created_by_user_id, 'Transportation', 'expense', 'directions_car'),
    (p_household_id, p_created_by_user_id, 'Housing', 'expense', 'home'),
    (p_household_id, p_created_by_user_id, 'Entertainment', 'expense', 'videogame_asset'),
    (p_household_id, p_created_by_user_id, 'Utilities', 'expense', 'bolt');
END;
$$;
ALTER FUNCTION "public"."fn_create_default_categories_for_household"("p_household_id" "uuid", "p_created_by_user_id" "uuid") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."fn_create_household_for_user"("user_id" "uuid", "household_name" "text") RETURNS "uuid"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$DECLARE
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
END;$$;
ALTER FUNCTION "public"."fn_create_household_for_user"("user_id" "uuid", "household_name" "text") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."fn_ensure_household_has_categories"() RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
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
$$;
ALTER FUNCTION "public"."fn_ensure_household_has_categories"() OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."fn_ensure_user_in_household"("user_id" "uuid", "user_first_name" "text", "target_household_id" "uuid" DEFAULT NULL::"uuid") RETURNS "uuid"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
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
$$;
ALTER FUNCTION "public"."fn_ensure_user_in_household"("user_id" "uuid", "user_first_name" "text", "target_household_id" "uuid") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."fn_get_account_balance"("p_account_id" "uuid") RETURNS numeric
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$DECLARE
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
END;$$;
ALTER FUNCTION "public"."fn_get_account_balance"("p_account_id" "uuid") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."fn_get_account_balance_as_of"("p_account_id" "uuid", "p_date" "date") RETURNS numeric
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$DECLARE
  v_account_record RECORD;
  v_initial_balance NUMERIC;
  v_transactions_sum NUMERIC;
BEGIN
  -- Get account details including initial balance and initial_balance_date
  SELECT a.initial_balance, a.initial_balance_date INTO v_account_record
  FROM accounts a
  WHERE a.id = p_account_id;
  
  -- If account not found, return 0
  IF v_account_record IS NULL THEN
    RETURN 0;
  END IF;
  
  -- Check if account existed on the specified date
  IF v_account_record.initial_balance_date::date > p_date THEN
    -- Account didn't exist yet, return 0
    RETURN 0;
  END IF;
  
  -- Account existed, use its initial balance
  v_initial_balance := v_account_record.initial_balance;

  -- Only include transactions up to the given date
  SELECT COALESCE(SUM(t.amount), 0) INTO v_transactions_sum
  FROM public.transactions t
  WHERE t.account_id = p_account_id
  AND t.status = 'completed'
  AND t.transaction_date::date <= p_date;

  -- Return the sum
  RETURN v_initial_balance + v_transactions_sum;
END;$$;
ALTER FUNCTION "public"."fn_get_account_balance_as_of"("p_account_id" "uuid", "p_date" "date") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."handle_new_household_member"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
  household_category_count INT;
BEGIN
  -- Check if the household already has categories
  SELECT COUNT(*) 
  INTO household_category_count 
  FROM public.categories 
  WHERE household_id = NEW.household_id;

  -- If no categories exist for this household, create them
  IF household_category_count = 0 THEN
    PERFORM public.fn_create_default_categories_for_household(NEW.household_id, NEW.user_id);
  END IF;

  RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."handle_new_household_member"() OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
  user_household_id UUID;
  user_first_name TEXT;
BEGIN
  -- Get user's first name from meta data if available
  user_first_name := NEW.raw_user_meta_data ->> 'first_name';

  -- Ensure user is in a household
  SELECT public.fn_ensure_user_in_household(NEW.id, user_first_name)
  INTO user_household_id;

  -- Create default categories for the user's household (if they don't exist)
  PERFORM public.fn_ensure_household_has_categories();
  
  -- Insert user details into public.users table
  INSERT INTO public.users (id, first_name, last_name)
  VALUES (NEW.id, user_first_name, NEW.raw_user_meta_data ->> 'last_name');
  
  RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."handle_new_user"() OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."is_household_member"("household_uuid" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
  member_count INT;
BEGIN
  SELECT COUNT(*) INTO member_count
  FROM public.household_members
  WHERE household_members.household_id = household_uuid
    AND household_members.user_id = auth.uid();
  RETURN member_count > 0;
END;
$$;
ALTER FUNCTION "public"."is_household_member"("household_uuid" "uuid") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."is_household_owner"("household_uuid" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
  owner_count INT;
BEGIN
  SELECT COUNT(*) INTO owner_count
  FROM public.household_members
  WHERE household_members.household_id = household_uuid
    AND household_members.user_id = auth.uid()
    AND household_members.role = 'owner';
  RETURN owner_count > 0;
END;
$$;
ALTER FUNCTION "public"."is_household_owner"("household_uuid" "uuid") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."fn_get_category_available"("p_household_id" "uuid", "p_category_id" "uuid", "p_month" "date") RETURNS numeric
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
  v_allocated NUMERIC;
  v_spent NUMERIC;
  v_available NUMERIC;
BEGIN
  -- Get allocated amount
  SELECT COALESCE(allocated_amount, 0) INTO v_allocated
  FROM public.budget_allocations
  WHERE household_id = p_household_id
    AND category_id = p_category_id
    AND month = DATE_TRUNC('month', p_month);
  
  -- Get spent amount (only expenses, which are negative)
  SELECT COALESCE(SUM(amount), 0) INTO v_spent
  FROM public.transactions
  WHERE household_id = p_household_id
    AND category_id = p_category_id
    AND status = 'completed'
    AND amount < 0 -- Only count expenses
    AND transaction_date >= DATE_TRUNC('month', p_month)
    AND transaction_date < DATE_TRUNC('month', p_month) + INTERVAL '1 month';
  
  -- Available = Allocated + Spent (since spent is negative)
  v_available := v_allocated + v_spent;
  
  RETURN v_available;
END;
$$;
ALTER FUNCTION "public"."fn_get_category_available"("p_household_id" "uuid", "p_category_id" "uuid", "p_month" "date") OWNER TO "postgres";

CREATE OR REPLACE FUNCTION "public"."fn_get_available_to_budget"("p_household_id" "uuid", "p_month" "date") RETURNS numeric
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
  v_total_balance NUMERIC;
  v_total_allocated NUMERIC;
  v_available NUMERIC;
  v_end_of_month DATE;
BEGIN
  -- Calculate end of the selected month
  v_end_of_month := (DATE_TRUNC('month', p_month) + INTERVAL '1 month' - INTERVAL '1 day')::date;
  
  -- Get total balance across all accounts AS OF THE END OF THE SELECTED MONTH
  SELECT COALESCE(SUM(fn_get_account_balance_as_of(id, v_end_of_month)), 0) INTO v_total_balance
  FROM public.accounts
  WHERE household_id = p_household_id;
  
  -- Get total allocated across all categories for this month and previous months
  SELECT COALESCE(SUM(allocated_amount), 0) INTO v_total_allocated
  FROM public.budget_allocations
  WHERE household_id = p_household_id
    AND month <= DATE_TRUNC('month', p_month);
  
  -- Available to budget = Total balance - Total allocated
  v_available := v_total_balance - v_total_allocated;
  
  RETURN v_available;
END;
$$;
ALTER FUNCTION "public"."fn_get_available_to_budget"("p_household_id" "uuid", "p_month" "date") OWNER TO "postgres"; 