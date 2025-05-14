CREATE TABLE "public"."account_types" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "name" "text" NOT NULL
);
ALTER TABLE "public"."account_types" OWNER TO "postgres";
ALTER TABLE ONLY "public"."account_types"
    ADD CONSTRAINT "account_types_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."account_types"
    ADD CONSTRAINT "account_types_name_key" UNIQUE ("name");

CREATE TABLE "public"."households" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "name" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "currency_symbol" "text" DEFAULT '$'::"text" NOT NULL,
    "symbol_position" "text" DEFAULT 'before'::"text" NOT NULL,
    "number_format" "text" DEFAULT 'comma'::"text" NOT NULL,
    CONSTRAINT "households_symbol_position_check" CHECK (("symbol_position" = ANY (ARRAY['before'::"text", 'after'::"text", 'none'::"text"])) ),
    CONSTRAINT "households_number_format_check" CHECK (("number_format" = ANY (ARRAY['comma'::"text", 'plain'::"text"])) )
);
ALTER TABLE "public"."households" OWNER TO "postgres";
ALTER TABLE ONLY "public"."households"
    ADD CONSTRAINT "households_pkey" PRIMARY KEY ("id");

CREATE TABLE "public"."accounts" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "household_id" "uuid" NOT NULL,
    "created_by_user_id" "uuid" NOT NULL,
    "name" "text" NOT NULL,
    "account_type_id" "uuid" NOT NULL,
    "initial_balance" numeric(10,2) DEFAULT 0.00 NOT NULL,
    "initial_balance_date" timestamp with time zone DEFAULT "now"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."accounts" OWNER TO "postgres";
ALTER TABLE ONLY "public"."accounts"
    ADD CONSTRAINT "accounts_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."accounts"
    ADD CONSTRAINT "accounts_account_type_id_fkey" FOREIGN KEY ("account_type_id") REFERENCES "public"."account_types"("id");
ALTER TABLE ONLY "public"."accounts"
    ADD CONSTRAINT "accounts_created_by_user_id_fkey" FOREIGN KEY ("created_by_user_id") REFERENCES "auth"."users"("id");
ALTER TABLE ONLY "public"."accounts"
    ADD CONSTRAINT "accounts_household_id_fkey" FOREIGN KEY ("household_id") REFERENCES "public"."households"("id") ON DELETE CASCADE;

CREATE TABLE "public"."categories" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "household_id" "uuid" NOT NULL,
    "created_by_user_id" "uuid" NOT NULL,
    "name" "text" NOT NULL,
    "type" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "icon" "text" DEFAULT 'payments'::"text" NOT NULL,
    CONSTRAINT "categories_type_check" CHECK (("type" = ANY (ARRAY['income'::"text", 'expense'::"text"])))
);
ALTER TABLE "public"."categories" OWNER TO "postgres";
ALTER TABLE ONLY "public"."categories"
    ADD CONSTRAINT "categories_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."categories"
    ADD CONSTRAINT "categories_household_id_name_type_key" UNIQUE ("household_id", "name", "type");
ALTER TABLE ONLY "public"."categories"
    ADD CONSTRAINT "categories_created_by_user_id_fkey" FOREIGN KEY ("created_by_user_id") REFERENCES "auth"."users"("id");
ALTER TABLE ONLY "public"."categories"
    ADD CONSTRAINT "categories_household_id_fkey" FOREIGN KEY ("household_id") REFERENCES "public"."households"("id") ON DELETE CASCADE;

CREATE TABLE "public"."household_members" (
    "household_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "role" "text" DEFAULT 'member'::"text" NOT NULL,
    "joined_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "household_members_role_check" CHECK (("role" = ANY (ARRAY['owner'::"text", 'member'::"text"])))
);
ALTER TABLE "public"."household_members" OWNER TO "postgres";
ALTER TABLE ONLY "public"."household_members"
    ADD CONSTRAINT "household_members_pkey" PRIMARY KEY ("household_id", "user_id");
ALTER TABLE ONLY "public"."household_members"
    ADD CONSTRAINT "household_members_household_id_fkey" FOREIGN KEY ("household_id") REFERENCES "public"."households"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."household_members"
    ADD CONSTRAINT "household_members_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;

CREATE TABLE "public"."users" (
    "id" "uuid" NOT NULL,
    "email" "text" NOT NULL,
    "first_name" "text",
    "last_name" "text",
    "avatar_url" "text",
    "created_at" timestamp with time zone NOT NULL DEFAULT "now"(),
    "updated_at" timestamp with time zone NOT NULL DEFAULT "now"()
);
ALTER TABLE "public"."users" OWNER TO "postgres";
ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE; 

CREATE TABLE "public"."transactions" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "household_id" "uuid" NOT NULL,
    "created_by_user_id" "uuid" NOT NULL,
    "account_id" "uuid" NOT NULL,
    "category_id" "uuid",
    "amount" numeric(10,2) NOT NULL,
    "description" "text",
    "transaction_date" timestamp with time zone DEFAULT "now"() NOT NULL,
    "status" "text" DEFAULT 'completed'::"text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "transactions_status_check" CHECK (("status" = ANY (ARRAY['pending'::"text", 'completed'::"text", 'canceled'::"text"])))
);
ALTER TABLE "public"."transactions" OWNER TO "postgres";
ALTER TABLE ONLY "public"."transactions"
    ADD CONSTRAINT "transactions_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."transactions"
    ADD CONSTRAINT "transactions_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "public"."accounts"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."transactions"
    ADD CONSTRAINT "transactions_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "public"."categories"("id") ON DELETE SET NULL;
ALTER TABLE ONLY "public"."transactions"
    ADD CONSTRAINT "transactions_created_by_user_id_fkey" FOREIGN KEY ("created_by_user_id") REFERENCES "public"."users"("id");
ALTER TABLE ONLY "public"."transactions"
    ADD CONSTRAINT "transactions_household_id_fkey" FOREIGN KEY ("household_id") REFERENCES "public"."households"("id") ON DELETE CASCADE;

CREATE INDEX IF NOT EXISTS idx_accounts_household_id_name ON public.accounts (household_id, name);
CREATE INDEX IF NOT EXISTS idx_categories_household_id_name ON public.categories (household_id, name);
CREATE INDEX IF NOT EXISTS idx_transactions_account_id_status ON public.transactions (account_id, status);
CREATE INDEX IF NOT EXISTS idx_transactions_account_id_tx_date_desc ON public.transactions (account_id, transaction_date DESC);
CREATE INDEX IF NOT EXISTS idx_household_members_user_id ON public.household_members (user_id);

CREATE TABLE "public"."budget_allocations" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "household_id" "uuid" NOT NULL,
    "created_by_user_id" "uuid" NOT NULL,
    "category_id" "uuid" NOT NULL,
    "month" "date" NOT NULL,
    "allocated_amount" numeric(10,2) DEFAULT 0 NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"()
);
ALTER TABLE "public"."budget_allocations" OWNER TO "postgres";
ALTER TABLE ONLY "public"."budget_allocations"
    ADD CONSTRAINT "budget_allocations_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."budget_allocations"
    ADD CONSTRAINT "budget_allocations_household_id_category_id_month_key" UNIQUE ("household_id", "category_id", "month");
ALTER TABLE ONLY "public"."budget_allocations"
    ADD CONSTRAINT "budget_allocations_household_id_fkey" FOREIGN KEY ("household_id") REFERENCES "public"."households"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."budget_allocations"
    ADD CONSTRAINT "budget_allocations_created_by_user_id_fkey" FOREIGN KEY ("created_by_user_id") REFERENCES "public"."users"("id");
ALTER TABLE ONLY "public"."budget_allocations"
    ADD CONSTRAINT "budget_allocations_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "public"."categories"("id") ON DELETE CASCADE;

CREATE INDEX IF NOT EXISTS idx_budget_allocations_household_id_month ON public.budget_allocations (household_id, month);
CREATE INDEX IF NOT EXISTS idx_budget_allocations_category_id ON public.budget_allocations (category_id);
