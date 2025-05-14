create table "public"."budget_allocations" (
    "id" uuid not null default uuid_generate_v4(),
    "household_id" uuid not null,
    "created_by_user_id" uuid not null,
    "category_id" uuid not null,
    "month" date not null,
    "allocated_amount" numeric(10,2) not null default 0,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
);


alter table "public"."budget_allocations" enable row level security;

CREATE UNIQUE INDEX budget_allocations_household_id_category_id_month_key ON public.budget_allocations USING btree (household_id, category_id, month);

CREATE UNIQUE INDEX budget_allocations_pkey ON public.budget_allocations USING btree (id);

CREATE INDEX idx_budget_allocations_category_id ON public.budget_allocations USING btree (category_id);

CREATE INDEX idx_budget_allocations_household_id_month ON public.budget_allocations USING btree (household_id, month);

alter table "public"."budget_allocations" add constraint "budget_allocations_pkey" PRIMARY KEY using index "budget_allocations_pkey";

alter table "public"."budget_allocations" add constraint "budget_allocations_category_id_fkey" FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE not valid;

alter table "public"."budget_allocations" validate constraint "budget_allocations_category_id_fkey";

alter table "public"."budget_allocations" add constraint "budget_allocations_created_by_user_id_fkey" FOREIGN KEY (created_by_user_id) REFERENCES users(id) not valid;

alter table "public"."budget_allocations" validate constraint "budget_allocations_created_by_user_id_fkey";

alter table "public"."budget_allocations" add constraint "budget_allocations_household_id_category_id_month_key" UNIQUE using index "budget_allocations_household_id_category_id_month_key";

alter table "public"."budget_allocations" add constraint "budget_allocations_household_id_fkey" FOREIGN KEY (household_id) REFERENCES households(id) ON DELETE CASCADE not valid;

alter table "public"."budget_allocations" validate constraint "budget_allocations_household_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.fn_get_available_to_budget(p_household_id uuid, p_month date)
 RETURNS numeric
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
  v_total_balance NUMERIC;
  v_total_allocated NUMERIC;
  v_available NUMERIC;
BEGIN
  -- Get total balance across all accounts
  SELECT COALESCE(SUM(fn_get_account_balance(id)), 0) INTO v_total_balance
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
$function$
;

CREATE OR REPLACE FUNCTION public.fn_get_category_available(p_household_id uuid, p_category_id uuid, p_month date)
 RETURNS numeric
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
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
$function$
;

CREATE OR REPLACE FUNCTION public.handle_budget_allocation_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$function$
;

grant delete on table "public"."budget_allocations" to "anon";

grant insert on table "public"."budget_allocations" to "anon";

grant references on table "public"."budget_allocations" to "anon";

grant select on table "public"."budget_allocations" to "anon";

grant trigger on table "public"."budget_allocations" to "anon";

grant truncate on table "public"."budget_allocations" to "anon";

grant update on table "public"."budget_allocations" to "anon";

grant delete on table "public"."budget_allocations" to "authenticated";

grant insert on table "public"."budget_allocations" to "authenticated";

grant references on table "public"."budget_allocations" to "authenticated";

grant select on table "public"."budget_allocations" to "authenticated";

grant trigger on table "public"."budget_allocations" to "authenticated";

grant truncate on table "public"."budget_allocations" to "authenticated";

grant update on table "public"."budget_allocations" to "authenticated";

grant delete on table "public"."budget_allocations" to "service_role";

grant insert on table "public"."budget_allocations" to "service_role";

grant references on table "public"."budget_allocations" to "service_role";

grant select on table "public"."budget_allocations" to "service_role";

grant trigger on table "public"."budget_allocations" to "service_role";

grant truncate on table "public"."budget_allocations" to "service_role";

grant update on table "public"."budget_allocations" to "service_role";

create policy "Allow household members to create and update budget allocations"
on "public"."budget_allocations"
as permissive
for insert
to public
with check (is_household_member(household_id));


create policy "Allow household members to read budget allocations"
on "public"."budget_allocations"
as permissive
for select
to public
using (is_household_member(household_id));


create policy "Allow household members to update budget allocations"
on "public"."budget_allocations"
as permissive
for update
to public
using (is_household_member(household_id));


create policy "Allow household owners to delete budget allocations"
on "public"."budget_allocations"
as permissive
for delete
to public
using (is_household_owner(household_id));


CREATE TRIGGER set_budget_allocations_updated_at BEFORE UPDATE ON public.budget_allocations FOR EACH ROW EXECUTE FUNCTION handle_budget_allocation_updated_at();


