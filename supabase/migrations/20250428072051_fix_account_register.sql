set check_function_bodies = off;
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
CREATE OR REPLACE FUNCTION public.handle_new_household_member()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
  category_count INTEGER;
  first_member BOOLEAN;
BEGIN
  -- Check if categories already exist for this household
  SELECT COUNT(*) INTO category_count 
  FROM public.categories 
  WHERE household_id = NEW.household_id;
  
  -- Only create default categories if none exist yet
  IF category_count = 0 THEN
    -- We'll create categories if either:
    -- 1. The new member is an owner (new household case)
    -- 2. This is the first member of an existing household with no categories
    
    -- Check if this is the first member of the household
    SELECT COUNT(*) = 1 INTO first_member
    FROM public.household_members
    WHERE household_id = NEW.household_id;
    
    IF NEW.role = 'owner' OR first_member THEN
      PERFORM public.fn_create_default_categories_for_household(NEW.household_id, NEW.user_id);
    END IF;
  END IF;
  
  RETURN NEW;
END;
$function$;
CREATE OR REPLACE FUNCTION public.fn_create_household_for_user(user_id uuid, household_name text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$DECLARE
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
END;$function$;
CREATE OR REPLACE FUNCTION public.fn_ensure_user_in_household(user_id uuid, user_first_name text)
 RETURNS uuid
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$DECLARE
  existing_household_id UUID;
  new_household_id UUID;
  user_household_count INT;
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
  
  -- Check if any household exists
  SELECT id INTO existing_household_id
  FROM public.households
  LIMIT 1;
  
  -- If a household exists, add the user as a member
  IF existing_household_id IS NOT NULL THEN
    INSERT INTO public.household_members (household_id, user_id, role)
    VALUES (existing_household_id, fn_ensure_user_in_household.user_id, 'member');
    RETURN existing_household_id;
  END IF;
  
  -- No household exists, create a new one with the user as owner
  INSERT INTO public.households (name)
  VALUES (COALESCE(user_first_name, 'My') || '''s Household')
  RETURNING id INTO new_household_id;
  
  -- Add the user as an owner
  INSERT INTO public.household_members (household_id, user_id, role)
  VALUES (new_household_id, fn_ensure_user_in_household.user_id, 'owner');
  
  RETURN new_household_id;
END;$function$;
CREATE OR REPLACE FUNCTION public.fn_get_account_balance(p_account_id uuid)
 RETURNS numeric
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$DECLARE
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
END;$function$;
CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
  household_id UUID;
  first_name TEXT;
BEGIN
  -- Extract first name from metadata
  first_name := (NEW.raw_user_meta_data->>'first_name')::text;
  
  -- Create user record
  INSERT INTO public.users (
    id, 
    email, 
    first_name, 
    last_name
  )
  VALUES (
    NEW.id, 
    NEW.email, 
    first_name, 
    (NEW.raw_user_meta_data->>'last_name')::text
  );
  
  -- Ensure user is in a household - now with full schema reference
  SELECT public.fn_ensure_user_in_household(NEW.id, first_name) INTO household_id;
  
  RETURN NEW;
END;
$function$;
CREATE OR REPLACE TRIGGER trigger_create_default_categories AFTER INSERT ON public.household_members FOR EACH ROW EXECUTE FUNCTION handle_new_household_member();
