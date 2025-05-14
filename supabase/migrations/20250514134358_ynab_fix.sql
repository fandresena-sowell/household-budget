set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.fn_get_account_balance_as_of(p_account_id uuid, p_date date)
 RETURNS numeric
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$DECLARE
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
END;$function$
;

CREATE OR REPLACE FUNCTION public.fn_get_available_to_budget(p_household_id uuid, p_month date)
 RETURNS numeric
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
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
$function$
;


