CREATE INDEX idx_accounts_household_id_name ON public.accounts USING btree (household_id, name);

CREATE INDEX idx_categories_household_id_name ON public.categories USING btree (household_id, name);

CREATE INDEX idx_household_members_user_id ON public.household_members USING btree (user_id);

CREATE INDEX idx_transactions_account_id_status ON public.transactions USING btree (account_id, status);

CREATE INDEX idx_transactions_account_id_tx_date_desc ON public.transactions USING btree (account_id, transaction_date DESC);


