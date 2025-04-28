drop function if exists "public"."fn_ensure_user_in_household"(user_id uuid, user_first_name text);

set check_function_bodies = off;

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
$function$
;

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
$function$
;

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
  household_id UUID;
  first_name TEXT;
  target_household_id UUID;
BEGIN
  -- Extract first name from metadata
  first_name := (NEW.raw_user_meta_data->>'first_name')::text;
  
  -- Extract target household ID from metadata if provided
  target_household_id := (NEW.raw_user_meta_data->>'target_household_id')::uuid;
  
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
  
  -- Ensure user is in a household with optional target household ID
  SELECT public.fn_ensure_user_in_household(NEW.id, first_name, target_household_id) INTO household_id;
  
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION handle_new_user();



