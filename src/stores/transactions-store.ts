import { defineStore, acceptHMRUpdate } from 'pinia';
import { ref, computed } from 'vue';
import { supabase } from 'src/boot/supabase';
import { useHouseholdStore } from './household-store';

export interface Transaction {
  id: string;
  account_id: string;
  category_id: string | null;
  amount: number;
  description: string | null;
  transaction_date: string;
  status: 'pending' | 'completed' | 'canceled';
  created_at: string | null;
  household_id: string;
  created_by_user_id: string;

  // Joined fields
  category?: {
    name: string;
    type: string;
    icon: string;
  } | null;
  account?: {
    name: string;
  };
  created_by?: {
    email: string;
    first_name: string | null;
    last_name: string | null;
  };
}

export const useTransactionsStore = defineStore('transactions', () => {
  // State
  const transactions = ref<Transaction[]>([]);
  const isLoading = ref(false);
  const error = ref<Error | null>(null);

  // Getters
  const transactionsByDate = computed(() => {
    const grouped: Record<string, Transaction[]> = {};

    transactions.value.forEach((transaction) => {
      try {
        const date = new Date(transaction.transaction_date).toISOString().split('T')[0];
        if (!date) return;

        if (!grouped[date]) {
          grouped[date] = [];
        }

        grouped[date].push(transaction);
      } catch (error) {
        console.error('Error processing transaction date:', error);
      }
    });

    // Sort each group by transaction date
    Object.keys(grouped).forEach((date) => {
      const group = grouped[date];
      if (group) {
        group.sort((a, b) => {
          try {
            return new Date(b.transaction_date).getTime() - new Date(a.transaction_date).getTime();
          } catch (error) {
            console.error('Error sorting transactions:', error);
            return 0;
          }
        });
      }
    });

    return grouped;
  });

  const incomeTransactions = computed(() => {
    return transactions.value.filter((t) => t.amount > 0);
  });

  const expenseTransactions = computed(() => {
    return transactions.value.filter((t) => t.amount < 0);
  });

  // Actions
  async function fetchTransactionsForAccount(accountId: string) {
    isLoading.value = true;
    error.value = null;

    try {
      const { data, error: fetchError } = await supabase
        .from('transactions')
        .select(
          `
          *,
          category:categories(name, type, icon),
          account:accounts(name),
          created_by:users(email, first_name, last_name)
        `,
        )
        .eq('account_id', accountId)
        .order('transaction_date', { ascending: false });

      if (fetchError) throw fetchError;

      if (data) {
        transactions.value = data as unknown as Transaction[];
      }
    } catch (err) {
      console.error('Error fetching transactions:', err);
      error.value = err instanceof Error ? err : new Error('Failed to fetch transactions');
    } finally {
      isLoading.value = false;
    }
  }

  async function fetchTransactionsForPeriod(startDate: string, endDate: string) {
    const householdStore = useHouseholdStore();
    const householdId = householdStore.householdId;

    if (!householdId) {
      console.error('fetchTransactionsForPeriod - No household ID found');
      return;
    }

    isLoading.value = true;
    error.value = null;

    try {
      const { data, error: fetchError } = await supabase
        .from('transactions')
        .select(
          `
          *,
          category:categories(name, type, icon),
          account:accounts(name),
          created_by:users(email, first_name, last_name)
        `,
        )
        .eq('household_id', householdId)
        .eq('status', 'completed')
        .gte('transaction_date', startDate)
        .lte('transaction_date', endDate)
        .order('transaction_date', { ascending: false });

      if (fetchError) throw fetchError;

      if (data) {
        transactions.value = data as unknown as Transaction[];
      }
    } catch (err) {
      console.error('Error fetching transactions for period:', err);
      error.value =
        err instanceof Error ? err : new Error('Failed to fetch transactions for period');
    } finally {
      isLoading.value = false;
    }
  }

  async function fetchTransactionsForAccountAndPeriod(
    accountId: string,
    startDate: string,
    endDate: string,
  ) {
    isLoading.value = true;
    error.value = null;

    try {
      const { data, error: fetchError } = await supabase
        .from('transactions')
        .select(
          `
          *,
          category:categories(name, type, icon),
          account:accounts(name),
          created_by:users(email, first_name, last_name)
        `,
        )
        .eq('account_id', accountId)
        .gte('transaction_date', startDate)
        .lte('transaction_date', endDate)
        .order('transaction_date', { ascending: false });

      if (fetchError) throw fetchError;

      if (data) {
        transactions.value = data as unknown as Transaction[];
      }
    } catch (err) {
      console.error('Error fetching transactions for account and period:', err);
      error.value =
        err instanceof Error
          ? err
          : new Error('Failed to fetch transactions for account and period');
    } finally {
      isLoading.value = false;
    }
  }

  async function createTransaction(
    transactionData: Omit<Transaction, 'id' | 'created_at' | 'created_by' | 'category' | 'account'>,
  ) {
    isLoading.value = true;
    error.value = null;

    try {
      const { data, error: insertError } = await supabase
        .from('transactions')
        .insert(transactionData)
        .select(
          `
          *,
          category:categories(name, type, icon),
          account:accounts(name),
          created_by:users(email, first_name, last_name)
        `,
        )
        .single();

      if (insertError) throw insertError;

      if (data) {
        // Add the new transaction to the list
        transactions.value.unshift(data as unknown as Transaction);
        // Re-sort transactions by date
        transactions.value.sort((a, b) => {
          return new Date(b.transaction_date).getTime() - new Date(a.transaction_date).getTime();
        });
      }

      return { data, error: null };
    } catch (err) {
      console.error('Error creating transaction:', err);
      error.value = err instanceof Error ? err : new Error('Failed to create transaction');
      return { data: null, error: error.value };
    } finally {
      isLoading.value = false;
    }
  }

  async function updateTransaction(
    transactionId: string,
    updateData: Partial<
      Omit<Transaction, 'id' | 'created_at' | 'created_by' | 'category' | 'account'>
    >,
  ) {
    isLoading.value = true;
    error.value = null;

    try {
      const { data, error: updateError } = await supabase
        .from('transactions')
        .update(updateData)
        .eq('id', transactionId)
        .select(
          `
          *,
          category:categories(name, type, icon),
          account:accounts(name),
          created_by:users(email, first_name, last_name)
        `,
        )
        .single();

      if (updateError) throw updateError;

      if (data) {
        // Update the transaction in the list
        const index = transactions.value.findIndex((t) => t.id === transactionId);
        if (index >= 0) {
          transactions.value[index] = data as unknown as Transaction;
        }
        // Re-sort transactions by date
        transactions.value.sort((a, b) => {
          return new Date(b.transaction_date).getTime() - new Date(a.transaction_date).getTime();
        });
      }

      return { data, error: null };
    } catch (err) {
      console.error('Error updating transaction:', err);
      error.value = err instanceof Error ? err : new Error('Failed to update transaction');
      return { data: null, error: error.value };
    } finally {
      isLoading.value = false;
    }
  }

  async function deleteTransaction(transactionId: string) {
    isLoading.value = true;
    error.value = null;

    try {
      const { error: deleteError } = await supabase
        .from('transactions')
        .delete()
        .eq('id', transactionId);

      if (deleteError) throw deleteError;

      // Remove the transaction from the list
      transactions.value = transactions.value.filter((t) => t.id !== transactionId);

      return { error: null };
    } catch (err) {
      console.error('Error deleting transaction:', err);
      error.value = err instanceof Error ? err : new Error('Failed to delete transaction');
      return { error: error.value };
    } finally {
      isLoading.value = false;
    }
  }

  async function fetchTransactionsByDateRange(startDate: string, endDate: string) {
    const householdStore = useHouseholdStore();
    const householdId = householdStore.householdId;

    if (!householdId) {
      console.error('fetchTransactionsByDateRange - No household ID found');
      transactions.value = [];
      return;
    }

    isLoading.value = true;
    error.value = null;

    try {
      const { data, error: fetchError } = await supabase
        .from('transactions')
        .select(
          `
          *,
          category:categories(name, type, icon),
          created_by:users(email),
          account:accounts(name)
        `,
        )
        .eq('household_id', householdId)
        .gte('transaction_date', startDate)
        .lte('transaction_date', endDate)
        .order('transaction_date', { ascending: false })
        .returns<Transaction[]>();

      if (fetchError) throw fetchError;

      transactions.value = data || [];
    } catch (err) {
      console.error('Error fetching transactions:', err);
      error.value = err instanceof Error ? err : new Error('Failed to fetch transactions');
      transactions.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  return {
    // State
    transactions,
    isLoading,
    error,

    // Getters
    transactionsByDate,
    incomeTransactions,
    expenseTransactions,

    // Actions
    fetchTransactionsForAccount,
    fetchTransactionsForPeriod,
    fetchTransactionsForAccountAndPeriod,
    createTransaction,
    updateTransaction,
    deleteTransaction,
    fetchTransactionsByDateRange,
  };
});

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useTransactionsStore, import.meta.hot));
}
