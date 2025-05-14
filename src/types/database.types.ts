export type Json = string | number | boolean | null | { [key: string]: Json | undefined } | Json[];

export type Database = {
  graphql_public: {
    Tables: {
      [_ in never]: never;
    };
    Views: {
      [_ in never]: never;
    };
    Functions: {
      graphql: {
        Args: {
          operationName?: string;
          query?: string;
          variables?: Json;
          extensions?: Json;
        };
        Returns: Json;
      };
    };
    Enums: {
      [_ in never]: never;
    };
    CompositeTypes: {
      [_ in never]: never;
    };
  };
  public: {
    Tables: {
      account_types: {
        Row: {
          id: string;
          name: string;
        };
        Insert: {
          id?: string;
          name: string;
        };
        Update: {
          id?: string;
          name?: string;
        };
        Relationships: [];
      };
      accounts: {
        Row: {
          account_type_id: string;
          created_at: string | null;
          created_by_user_id: string;
          household_id: string;
          id: string;
          initial_balance: number;
          initial_balance_date: string;
          name: string;
        };
        Insert: {
          account_type_id: string;
          created_at?: string | null;
          created_by_user_id: string;
          household_id: string;
          id?: string;
          initial_balance?: number;
          initial_balance_date?: string;
          name: string;
        };
        Update: {
          account_type_id?: string;
          created_at?: string | null;
          created_by_user_id?: string;
          household_id?: string;
          id?: string;
          initial_balance?: number;
          initial_balance_date?: string;
          name?: string;
        };
        Relationships: [
          {
            foreignKeyName: 'accounts_account_type_id_fkey';
            columns: ['account_type_id'];
            isOneToOne: false;
            referencedRelation: 'account_types';
            referencedColumns: ['id'];
          },
          {
            foreignKeyName: 'accounts_household_id_fkey';
            columns: ['household_id'];
            isOneToOne: false;
            referencedRelation: 'households';
            referencedColumns: ['id'];
          },
        ];
      };
      budget_allocations: {
        Row: {
          allocated_amount: number;
          category_id: string;
          created_at: string | null;
          created_by_user_id: string;
          household_id: string;
          id: string;
          month: string;
          updated_at: string | null;
        };
        Insert: {
          allocated_amount?: number;
          category_id: string;
          created_at?: string | null;
          created_by_user_id: string;
          household_id: string;
          id?: string;
          month: string;
          updated_at?: string | null;
        };
        Update: {
          allocated_amount?: number;
          category_id?: string;
          created_at?: string | null;
          created_by_user_id?: string;
          household_id?: string;
          id?: string;
          month?: string;
          updated_at?: string | null;
        };
        Relationships: [
          {
            foreignKeyName: 'budget_allocations_category_id_fkey';
            columns: ['category_id'];
            isOneToOne: false;
            referencedRelation: 'categories';
            referencedColumns: ['id'];
          },
          {
            foreignKeyName: 'budget_allocations_created_by_user_id_fkey';
            columns: ['created_by_user_id'];
            isOneToOne: false;
            referencedRelation: 'users';
            referencedColumns: ['id'];
          },
          {
            foreignKeyName: 'budget_allocations_household_id_fkey';
            columns: ['household_id'];
            isOneToOne: false;
            referencedRelation: 'households';
            referencedColumns: ['id'];
          },
        ];
      };
      categories: {
        Row: {
          created_at: string | null;
          created_by_user_id: string;
          household_id: string;
          icon: string;
          id: string;
          name: string;
          type: string;
        };
        Insert: {
          created_at?: string | null;
          created_by_user_id: string;
          household_id: string;
          icon?: string;
          id?: string;
          name: string;
          type: string;
        };
        Update: {
          created_at?: string | null;
          created_by_user_id?: string;
          household_id?: string;
          icon?: string;
          id?: string;
          name?: string;
          type?: string;
        };
        Relationships: [
          {
            foreignKeyName: 'categories_household_id_fkey';
            columns: ['household_id'];
            isOneToOne: false;
            referencedRelation: 'households';
            referencedColumns: ['id'];
          },
        ];
      };
      household_members: {
        Row: {
          household_id: string;
          joined_at: string | null;
          role: string;
          user_id: string;
        };
        Insert: {
          household_id: string;
          joined_at?: string | null;
          role?: string;
          user_id: string;
        };
        Update: {
          household_id?: string;
          joined_at?: string | null;
          role?: string;
          user_id?: string;
        };
        Relationships: [
          {
            foreignKeyName: 'household_members_household_id_fkey';
            columns: ['household_id'];
            isOneToOne: false;
            referencedRelation: 'households';
            referencedColumns: ['id'];
          },
        ];
      };
      households: {
        Row: {
          created_at: string | null;
          currency_symbol: string;
          id: string;
          name: string;
          number_format: string;
          symbol_position: string;
        };
        Insert: {
          created_at?: string | null;
          currency_symbol?: string;
          id?: string;
          name: string;
          number_format?: string;
          symbol_position?: string;
        };
        Update: {
          created_at?: string | null;
          currency_symbol?: string;
          id?: string;
          name?: string;
          number_format?: string;
          symbol_position?: string;
        };
        Relationships: [];
      };
      transactions: {
        Row: {
          account_id: string;
          amount: number;
          category_id: string | null;
          created_at: string | null;
          created_by_user_id: string;
          description: string | null;
          household_id: string;
          id: string;
          status: string;
          transaction_date: string;
        };
        Insert: {
          account_id: string;
          amount: number;
          category_id?: string | null;
          created_at?: string | null;
          created_by_user_id: string;
          description?: string | null;
          household_id: string;
          id?: string;
          status?: string;
          transaction_date?: string;
        };
        Update: {
          account_id?: string;
          amount?: number;
          category_id?: string | null;
          created_at?: string | null;
          created_by_user_id?: string;
          description?: string | null;
          household_id?: string;
          id?: string;
          status?: string;
          transaction_date?: string;
        };
        Relationships: [
          {
            foreignKeyName: 'transactions_account_id_fkey';
            columns: ['account_id'];
            isOneToOne: false;
            referencedRelation: 'accounts';
            referencedColumns: ['id'];
          },
          {
            foreignKeyName: 'transactions_category_id_fkey';
            columns: ['category_id'];
            isOneToOne: false;
            referencedRelation: 'categories';
            referencedColumns: ['id'];
          },
          {
            foreignKeyName: 'transactions_created_by_user_id_fkey';
            columns: ['created_by_user_id'];
            isOneToOne: false;
            referencedRelation: 'users';
            referencedColumns: ['id'];
          },
          {
            foreignKeyName: 'transactions_household_id_fkey';
            columns: ['household_id'];
            isOneToOne: false;
            referencedRelation: 'households';
            referencedColumns: ['id'];
          },
        ];
      };
      users: {
        Row: {
          avatar_url: string | null;
          created_at: string;
          email: string;
          first_name: string | null;
          id: string;
          last_name: string | null;
          updated_at: string;
        };
        Insert: {
          avatar_url?: string | null;
          created_at?: string;
          email: string;
          first_name?: string | null;
          id: string;
          last_name?: string | null;
          updated_at?: string;
        };
        Update: {
          avatar_url?: string | null;
          created_at?: string;
          email?: string;
          first_name?: string | null;
          id?: string;
          last_name?: string | null;
          updated_at?: string;
        };
        Relationships: [];
      };
    };
    Views: {
      [_ in never]: never;
    };
    Functions: {
      fn_check_household_exists: {
        Args: { household_id: string };
        Returns: boolean;
      };
      fn_create_default_categories_for_household: {
        Args: { p_household_id: string; p_created_by_user_id: string };
        Returns: undefined;
      };
      fn_create_household_for_user: {
        Args: { user_id: string; household_name: string };
        Returns: string;
      };
      fn_ensure_household_has_categories: {
        Args: Record<PropertyKey, never>;
        Returns: undefined;
      };
      fn_ensure_user_in_household: {
        Args: {
          user_id: string;
          user_first_name: string;
          target_household_id?: string;
        };
        Returns: string;
      };
      fn_get_account_balance: {
        Args: { p_account_id: string };
        Returns: number;
      };
      fn_get_account_balance_as_of: {
        Args: { p_account_id: string; p_date: string };
        Returns: number;
      };
      fn_get_available_to_budget: {
        Args: { p_household_id: string; p_month: string };
        Returns: number;
      };
      fn_get_category_available: {
        Args: { p_household_id: string; p_category_id: string; p_month: string };
        Returns: number;
      };
      is_household_member: {
        Args: { household_uuid: string };
        Returns: boolean;
      };
      is_household_owner: {
        Args: { household_uuid: string };
        Returns: boolean;
      };
    };
    Enums: {
      [_ in never]: never;
    };
    CompositeTypes: {
      [_ in never]: never;
    };
  };
};

type DefaultSchema = Database[Extract<keyof Database, 'public'>];

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema['Tables'] & DefaultSchema['Views'])
    | { schema: keyof Database },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof Database;
  }
    ? keyof (Database[DefaultSchemaTableNameOrOptions['schema']]['Tables'] &
        Database[DefaultSchemaTableNameOrOptions['schema']]['Views'])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends { schema: keyof Database }
  ? (Database[DefaultSchemaTableNameOrOptions['schema']]['Tables'] &
      Database[DefaultSchemaTableNameOrOptions['schema']]['Views'])[TableName] extends {
      Row: infer R;
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema['Tables'] & DefaultSchema['Views'])
    ? (DefaultSchema['Tables'] & DefaultSchema['Views'])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R;
      }
      ? R
      : never
    : never;

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema['Tables']
    | { schema: keyof Database },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof Database;
  }
    ? keyof Database[DefaultSchemaTableNameOrOptions['schema']]['Tables']
    : never = never,
> = DefaultSchemaTableNameOrOptions extends { schema: keyof Database }
  ? Database[DefaultSchemaTableNameOrOptions['schema']]['Tables'][TableName] extends {
      Insert: infer I;
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema['Tables']
    ? DefaultSchema['Tables'][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I;
      }
      ? I
      : never
    : never;

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema['Tables']
    | { schema: keyof Database },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof Database;
  }
    ? keyof Database[DefaultSchemaTableNameOrOptions['schema']]['Tables']
    : never = never,
> = DefaultSchemaTableNameOrOptions extends { schema: keyof Database }
  ? Database[DefaultSchemaTableNameOrOptions['schema']]['Tables'][TableName] extends {
      Update: infer U;
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema['Tables']
    ? DefaultSchema['Tables'][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U;
      }
      ? U
      : never
    : never;

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    // eslint-disable-next-line @typescript-eslint/no-redundant-type-constituents
    keyof DefaultSchema['Enums'] | { schema: keyof Database },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof Database;
  }
    ? keyof Database[DefaultSchemaEnumNameOrOptions['schema']]['Enums']
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends { schema: keyof Database }
  ? Database[DefaultSchemaEnumNameOrOptions['schema']]['Enums'][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema['Enums']
    ? DefaultSchema['Enums'][DefaultSchemaEnumNameOrOptions]
    : never;

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    // eslint-disable-next-line @typescript-eslint/no-redundant-type-constituents
    keyof DefaultSchema['CompositeTypes'] | { schema: keyof Database },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof Database;
  }
    ? keyof Database[PublicCompositeTypeNameOrOptions['schema']]['CompositeTypes']
    : never = never,
> = PublicCompositeTypeNameOrOptions extends { schema: keyof Database }
  ? Database[PublicCompositeTypeNameOrOptions['schema']]['CompositeTypes'][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema['CompositeTypes']
    ? DefaultSchema['CompositeTypes'][PublicCompositeTypeNameOrOptions]
    : never;

export const Constants = {
  graphql_public: {
    Enums: {},
  },
  public: {
    Enums: {},
  },
} as const;
