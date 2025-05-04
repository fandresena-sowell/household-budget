drop policy "Enable read access for all users" on "public"."account_types";

drop policy "accounts_delete_policy" on "public"."accounts";

drop policy "accounts_insert_policy" on "public"."accounts";

drop policy "accounts_select_policy" on "public"."accounts";

drop policy "accounts_update_policy" on "public"."accounts";

drop policy "categories_delete_policy" on "public"."categories";

drop policy "categories_insert_policy" on "public"."categories";

drop policy "categories_select_policy" on "public"."categories";

drop policy "categories_update_policy" on "public"."categories";

drop policy "household_members_delete_policy" on "public"."household_members";

drop policy "household_members_insert_policy" on "public"."household_members";

drop policy "household_members_select_policy" on "public"."household_members";

drop policy "households_select_policy" on "public"."households";

drop policy "Enable read access for all users" on "public"."todos";

drop policy "transactions_delete_policy" on "public"."transactions";

drop policy "transactions_insert_policy" on "public"."transactions";

drop policy "transactions_select_policy" on "public"."transactions";

drop policy "transactions_update_policy" on "public"."transactions";

drop policy "Users can insert their own user data" on "public"."users";

drop policy "Users can update their own user data" on "public"."users";

drop policy "Users can view their own user data" on "public"."users";

revoke delete on table "public"."todos" from "anon";

revoke insert on table "public"."todos" from "anon";

revoke references on table "public"."todos" from "anon";

revoke select on table "public"."todos" from "anon";

revoke trigger on table "public"."todos" from "anon";

revoke truncate on table "public"."todos" from "anon";

revoke update on table "public"."todos" from "anon";

revoke delete on table "public"."todos" from "authenticated";

revoke insert on table "public"."todos" from "authenticated";

revoke references on table "public"."todos" from "authenticated";

revoke select on table "public"."todos" from "authenticated";

revoke trigger on table "public"."todos" from "authenticated";

revoke truncate on table "public"."todos" from "authenticated";

revoke update on table "public"."todos" from "authenticated";

revoke delete on table "public"."todos" from "service_role";

revoke insert on table "public"."todos" from "service_role";

revoke references on table "public"."todos" from "service_role";

revoke select on table "public"."todos" from "service_role";

revoke trigger on table "public"."todos" from "service_role";

revoke truncate on table "public"."todos" from "service_role";

revoke update on table "public"."todos" from "service_role";

alter table "public"."household_members" drop constraint "household_members_household_id_user_id_key";

alter table "public"."transactions" drop constraint "transactions_created_by_user_id_fkey1";

alter table "public"."accounts" drop constraint "accounts_household_id_fkey";

alter table "public"."categories" drop constraint "categories_household_id_fkey";

alter table "public"."household_members" drop constraint "household_members_household_id_fkey";

alter table "public"."household_members" drop constraint "household_members_user_id_fkey";

alter table "public"."transactions" drop constraint "transactions_account_id_fkey";

alter table "public"."transactions" drop constraint "transactions_category_id_fkey";

alter table "public"."transactions" drop constraint "transactions_created_by_user_id_fkey";

alter table "public"."transactions" drop constraint "transactions_household_id_fkey";

alter table "public"."todos" drop constraint "todos_pkey";

drop index if exists "public"."household_members_household_id_user_id_key";

drop index if exists "public"."todos_pkey";

drop table "public"."todos";

alter table "public"."account_types" alter column "id" set default uuid_generate_v4();

alter table "public"."accounts" alter column "id" set default uuid_generate_v4();

alter table "public"."categories" alter column "id" set default uuid_generate_v4();

alter table "public"."households" add column "currency_symbol" text not null default '$'::text;

alter table "public"."households" add column "number_format" text not null default 'comma'::text;

alter table "public"."households" add column "symbol_position" text not null default 'before'::text;

alter table "public"."households" alter column "id" set default uuid_generate_v4();

alter table "public"."transactions" alter column "id" set default uuid_generate_v4();

alter table "public"."households" add constraint "households_number_format_check" CHECK ((number_format = ANY (ARRAY['comma'::text, 'plain'::text]))) not valid;

alter table "public"."households" validate constraint "households_number_format_check";

alter table "public"."households" add constraint "households_symbol_position_check" CHECK ((symbol_position = ANY (ARRAY['before'::text, 'after'::text, 'none'::text]))) not valid;

alter table "public"."households" validate constraint "households_symbol_position_check";

alter table "public"."accounts" add constraint "accounts_household_id_fkey" FOREIGN KEY (household_id) REFERENCES households(id) ON DELETE CASCADE not valid;

alter table "public"."accounts" validate constraint "accounts_household_id_fkey";

alter table "public"."categories" add constraint "categories_household_id_fkey" FOREIGN KEY (household_id) REFERENCES households(id) ON DELETE CASCADE not valid;

alter table "public"."categories" validate constraint "categories_household_id_fkey";

alter table "public"."household_members" add constraint "household_members_household_id_fkey" FOREIGN KEY (household_id) REFERENCES households(id) ON DELETE CASCADE not valid;

alter table "public"."household_members" validate constraint "household_members_household_id_fkey";

alter table "public"."household_members" add constraint "household_members_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."household_members" validate constraint "household_members_user_id_fkey";

alter table "public"."transactions" add constraint "transactions_account_id_fkey" FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE not valid;

alter table "public"."transactions" validate constraint "transactions_account_id_fkey";

alter table "public"."transactions" add constraint "transactions_category_id_fkey" FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL not valid;

alter table "public"."transactions" validate constraint "transactions_category_id_fkey";

alter table "public"."transactions" add constraint "transactions_created_by_user_id_fkey" FOREIGN KEY (created_by_user_id) REFERENCES users(id) not valid;

alter table "public"."transactions" validate constraint "transactions_created_by_user_id_fkey";

alter table "public"."transactions" add constraint "transactions_household_id_fkey" FOREIGN KEY (household_id) REFERENCES households(id) ON DELETE CASCADE not valid;

alter table "public"."transactions" validate constraint "transactions_household_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.handle_new_household_member()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
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
$function$
;

CREATE OR REPLACE FUNCTION public.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
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
$function$
;

CREATE OR REPLACE FUNCTION public.is_household_member(household_uuid uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
  member_count INT;
BEGIN
  SELECT COUNT(*) INTO member_count
  FROM public.household_members
  WHERE household_members.household_id = household_uuid
    AND household_members.user_id = auth.uid();
  RETURN member_count > 0;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.is_household_owner(household_uuid uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
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
$function$
;

create policy "Allow read access to all users"
on "public"."account_types"
as permissive
for select
to public
using (true);


create policy "Allow household members to manage accounts"
on "public"."accounts"
as permissive
for all
to public
using (is_household_member(household_id));


create policy "Allow household members to read accounts"
on "public"."accounts"
as permissive
for select
to public
using (is_household_member(household_id));


create policy "Allow household members to manage categories"
on "public"."categories"
as permissive
for all
to public
using (is_household_member(household_id));


create policy "Allow household members to read categories"
on "public"."categories"
as permissive
for select
to public
using (is_household_member(household_id));


create policy "Allow member to read household members"
on "public"."household_members"
as permissive
for select
to public
using (is_household_member(household_id));


create policy "Allow owner to manage household members"
on "public"."household_members"
as permissive
for all
to public
using (is_household_owner(household_id))
with check (is_household_owner(household_id));


create policy "Allow member to read households"
on "public"."households"
as permissive
for select
to public
using (is_household_member(id));


create policy "Allow owner to manage households"
on "public"."households"
as permissive
for all
to public
using (is_household_owner(id));


create policy "Allow household members to manage transactions"
on "public"."transactions"
as permissive
for all
to public
using (is_household_member(household_id));


create policy "Allow household members to read transactions"
on "public"."transactions"
as permissive
for select
to public
using (is_household_member(household_id));


create policy "Allow all users to read user info"
on "public"."users"
as permissive
for select
to public
using (true);


create policy "Users can insert their own profile."
on "public"."users"
as permissive
for insert
to public
with check ((auth.uid() = id));


create policy "Users can update own profile."
on "public"."users"
as permissive
for update
to public
using ((auth.uid() = id));



