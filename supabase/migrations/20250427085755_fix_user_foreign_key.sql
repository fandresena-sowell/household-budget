alter table "public"."transactions" add constraint "transactions_created_by_user_id_fkey1" FOREIGN KEY (created_by_user_id) REFERENCES users(id) not valid;
alter table "public"."transactions" validate constraint "transactions_created_by_user_id_fkey1";
