import { defineStore, acceptHMRUpdate } from 'pinia';
import { ref, computed } from 'vue';
import { supabase } from 'src/boot/supabase';
import { useHouseholdStore } from './household-store';

export interface Account {
  id: string;
  name: string;
  account_type_id: string;
  initial_balance: number;
  initial_balance_date: string;
  created_at: string | null;
  household_id: string;
  created_by_user_id: string;
  current_balance?: number;
  account_type?: {
    name: string;
  };
}

export const useAccountsStore = defineStore('accounts', () => {
  // State
  const accounts = ref<Account[]>([]);
  const isLoading = ref(false);
  const error = ref<Error | null>(null);

  // Getters
  const totalBalance = computed(() => {
    return accounts.value.reduce((sum, account) => {
      return sum + (account.current_balance || account.initial_balance);
    }, 0);
  });

  // Actions
  async function fetchAccounts() {
    const householdStore = useHouseholdStore();
    const householdId = householdStore.householdId;

    if (!householdId) {
      console.error('fetchAccounts - No household ID found');
      return;
    }

    isLoading.value = true;
    error.value = null;

    try {
      // Fetch accounts with account type information
      const { data, error: fetchError } = await supabase
        .from('accounts')
        .select(
          `
          *,
          account_type:account_types(name)
        `,
        )
        .eq('household_id', householdId)
        .order('name');

      if (fetchError) throw fetchError;

      if (data) {
        // For each account, calculate the current balance as of today
        const today = new Date().toISOString().split('T')[0] as string; // Format: YYYY-MM-DD
        const accountsWithBalance = await Promise.all(
          data.map(async (account) => {
            const { data: balanceData } = await supabase.rpc('fn_get_account_balance_as_of', {
              p_account_id: account.id,
              p_date: today,
            });

            return {
              ...account,
              current_balance: balanceData || account.initial_balance,
            };
          }),
        );

        accounts.value = accountsWithBalance as Account[];
      }
    } catch (err) {
      console.error('Error fetching accounts:', err);
      error.value = err instanceof Error ? err : new Error('Failed to fetch accounts');
    } finally {
      isLoading.value = false;
    }
  }

  async function createAccount(accountData: Omit<Account, 'id' | 'created_at'>) {
    isLoading.value = true;
    error.value = null;

    try {
      const { data, error: insertError } = await supabase
        .from('accounts')
        .insert(accountData)
        .select()
        .single();

      if (insertError) throw insertError;

      if (data) {
        // Add the new account to the accounts list with current balance equal to initial balance
        const newAccount = {
          ...data,
          current_balance: data.initial_balance,
        } as Account;
        accounts.value.push(newAccount);
        // Re-sort the accounts by name
        accounts.value.sort((a, b) => a.name.localeCompare(b.name));
      }

      return { data, error: null };
    } catch (err) {
      console.error('Error creating account:', err);
      error.value = err instanceof Error ? err : new Error('Failed to create account');
      return { data: null, error: error.value };
    } finally {
      isLoading.value = false;
    }
  }

  async function updateAccount(accountId: string, updateData: Partial<Account>) {
    isLoading.value = true;
    error.value = null;

    try {
      const { data, error: updateError } = await supabase
        .from('accounts')
        .update(updateData)
        .eq('id', accountId)
        .select()
        .single();

      if (updateError) throw updateError;

      if (data) {
        // Update the account in the accounts list
        const index = accounts.value.findIndex((acc) => acc.id === accountId);
        if (index >= 0) {
          // Preserve the current_balance if it exists
          const currentBalance = accounts.value[index]?.current_balance;
          accounts.value[index] = {
            ...data,
            current_balance: currentBalance || data.initial_balance,
          } as Account;
        }

        // Re-sort the accounts by name in case the name changed
        accounts.value.sort((a, b) => a.name.localeCompare(b.name));
      }

      return { data, error: null };
    } catch (err) {
      console.error('Error updating account:', err);
      error.value = err instanceof Error ? err : new Error('Failed to update account');
      return { data: null, error: error.value };
    } finally {
      isLoading.value = false;
    }
  }

  async function deleteAccount(accountId: string) {
    isLoading.value = true;
    error.value = null;

    try {
      const { error: deleteError } = await supabase.from('accounts').delete().eq('id', accountId);

      if (deleteError) throw deleteError;

      // Remove the account from the accounts list
      accounts.value = accounts.value.filter((acc) => acc.id !== accountId);

      return { error: null };
    } catch (err) {
      console.error('Error deleting account:', err);
      error.value = err instanceof Error ? err : new Error('Failed to delete account');
      return { error: error.value };
    } finally {
      isLoading.value = false;
    }
  }

  return {
    // State
    accounts,
    isLoading,
    error,

    // Getters
    totalBalance,

    // Actions
    fetchAccounts,
    createAccount,
    updateAccount,
    deleteAccount,
  };
});

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useAccountsStore, import.meta.hot));
}
