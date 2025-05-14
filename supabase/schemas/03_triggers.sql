CREATE OR REPLACE TRIGGER "trigger_create_default_categories" AFTER INSERT ON "public"."household_members" FOR EACH ROW EXECUTE FUNCTION "public"."handle_new_household_member"();
CREATE OR REPLACE TRIGGER "on_auth_user_created" AFTER INSERT ON "auth"."users" FOR EACH ROW EXECUTE FUNCTION "public"."handle_new_user"();

CREATE OR REPLACE FUNCTION "public"."handle_budget_allocation_updated_at"() RETURNS trigger
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;
ALTER FUNCTION "public"."handle_budget_allocation_updated_at"() OWNER TO "postgres";

CREATE TRIGGER "set_budget_allocations_updated_at" BEFORE UPDATE ON "public"."budget_allocations" FOR EACH ROW EXECUTE FUNCTION "public"."handle_budget_allocation_updated_at"(); 