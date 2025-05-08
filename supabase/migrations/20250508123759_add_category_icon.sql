alter table "public"."categories" add column "icon" text not null default 'payments'::text;

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.fn_create_default_categories_for_household(p_household_id uuid, p_created_by_user_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
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
$function$
;


