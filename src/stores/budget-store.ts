import { defineStore } from 'pinia';
import { supabase } from 'src/boot/supabase';
import { useHouseholdStore } from './household-store';
import { date } from 'quasar';
import { ref, computed } from 'vue';
import { useAuthStore } from './auth-store';

interface BudgetAllocation {
  id: string;
  household_id: string;
  created_by_user_id: string;
  category_id: string;
  month: string;
  allocated_amount: number;
  created_at: string;
  updated_at: string;
  category?: {
    name: string;
    icon: string;
  };
}

interface CategoryBudget {
  category_id: string;
  category_name: string;
  category_icon: string;
  allocated_amount: number;
  spent_amount: number;
  available_amount: number;
  percentage_used: number;
}

export const useBudgetStore = defineStore('budget', () => {
  // State
  const selectedMonth = ref(new Date());
  const budgetAllocations = ref<BudgetAllocation[]>([]);
  const isLoading = ref(false);
  const error = ref<string | null>(null);
  const availableToBudget = ref(0);
  const categoryBudgets = ref<CategoryBudget[]>([]);
  const isAllocationsLoading = ref(false);

  // Getters
  const formattedSelectedMonth = computed(() => {
    return date.formatDate(selectedMonth.value, 'YYYY-MM-01');
  });

  const monthName = computed(() => {
    return date.formatDate(selectedMonth.value, 'MMMM YYYY');
  });

  // Actions
  async function setSelectedMonth(newMonth: Date) {
    selectedMonth.value = newMonth;
    await fetchBudgetData();
  }

  async function prevMonth() {
    const newMonth = new Date(selectedMonth.value);
    newMonth.setMonth(newMonth.getMonth() - 1);
    await setSelectedMonth(newMonth);
  }

  async function nextMonth() {
    const newMonth = new Date(selectedMonth.value);
    newMonth.setMonth(newMonth.getMonth() + 1);
    await setSelectedMonth(newMonth);
  }

  async function fetchBudgetData() {
    const householdStore = useHouseholdStore();
    const { currentHousehold: household } = householdStore;

    if (!household) {
      error.value = 'No household found';
      return;
    }

    isLoading.value = true;
    error.value = null;

    try {
      // Fetch available to budget amount
      const { data: availableData, error: availableError } = await supabase.rpc(
        'fn_get_available_to_budget',
        {
          p_household_id: household.id,
          p_month: formattedSelectedMonth.value,
        },
      );

      if (availableError) throw new Error(availableError.message);
      availableToBudget.value = availableData || 0;

      // Fetch allocations with category details
      const { data: allocationsData, error: allocationsError } = await supabase
        .from('budget_allocations')
        .select('*, category:categories(name, icon)')
        .eq('household_id', household.id)
        .eq('month', formattedSelectedMonth.value)
        .overrideTypes<BudgetAllocation[]>();

      if (allocationsError) throw new Error(allocationsError.message);
      budgetAllocations.value = allocationsData || [];

      // Fetch spending data for categories
      await fetchCategoryBudgets();
    } catch (err) {
      console.error('Error fetching budget data:', err);
      error.value = err instanceof Error ? err.message : 'Unknown error';
    } finally {
      isLoading.value = false;
    }
  }

  async function fetchCategoryBudgets() {
    const householdStore = useHouseholdStore();
    const { currentHousehold: household } = householdStore;

    if (!household) return;

    isAllocationsLoading.value = true;

    try {
      // Fetch categories for the household
      const { data: categoriesData, error: categoriesError } = await supabase
        .from('categories')
        .select('id, name, icon')
        .eq('household_id', household.id)
        .eq('type', 'expense');

      if (categoriesError) throw new Error(categoriesError.message);

      // Get the end of the selected month for transaction calculations
      const startOfMonth = formattedSelectedMonth.value;
      const endOfMonth = date.formatDate(
        date.addToDate(new Date(startOfMonth), { month: 1, day: -1 }),
        'YYYY-MM-DD',
      );

      // Calculate spent amount for each category
      const budgets: CategoryBudget[] = await Promise.all(
        categoriesData?.map(async (category) => {
          // Get allocated amount from allocations
          const allocation = budgetAllocations.value.find((a) => a.category_id === category.id);
          const allocated = allocation?.allocated_amount || 0;

          // Get transactions for this category in the selected month
          const { data: transactionsData } = await supabase
            .from('transactions')
            .select('amount')
            .eq('household_id', household.id)
            .eq('category_id', category.id)
            .eq('status', 'completed')
            .lt('amount', 0) // Only expenses (negative amounts)
            .gte('transaction_date', startOfMonth)
            .lte('transaction_date', endOfMonth);

          // Calculate spent amount (absolute value since expenses are negative)
          const spent = transactionsData?.reduce((sum, t) => sum + Math.abs(t.amount), 0) || 0;

          // Calculate available amount using the function
          const { data: availableData } = await supabase.rpc('fn_get_category_available', {
            p_household_id: household.id,
            p_category_id: category.id,
            p_month: formattedSelectedMonth.value,
          });

          const available = availableData || 0;
          const percentageUsed = allocated > 0 ? ((allocated - available) / allocated) * 100 : 0;

          return {
            category_id: category.id,
            category_name: category.name,
            category_icon: category.icon,
            allocated_amount: allocated,
            spent_amount: spent,
            available_amount: available,
            percentage_used: percentageUsed,
          };
        }) || [],
      );

      categoryBudgets.value = budgets;
    } catch (err) {
      console.error('Error fetching category budgets:', err);
      error.value = err instanceof Error ? err.message : 'Unknown error';
    } finally {
      isAllocationsLoading.value = false;
    }
  }

  async function allocateBudget(categoryId: string, amount: number) {
    const householdStore = useHouseholdStore();
    const authStore = useAuthStore();
    const { currentHousehold: household } = householdStore;
    const { userId } = authStore;

    if (!household || !userId) {
      error.value = 'No household or user found';
      return;
    }

    // Check if allocation exists
    const existingAllocation = budgetAllocations.value.find((a) => a.category_id === categoryId);

    try {
      if (existingAllocation) {
        // Update existing allocation
        const { error: updateError } = await supabase
          .from('budget_allocations')
          .update({
            allocated_amount: amount,
            updated_at: new Date().toISOString(),
          })
          .eq('id', existingAllocation.id);

        if (updateError) throw new Error(updateError.message);
      } else {
        // Create new allocation
        const { error: insertError } = await supabase.from('budget_allocations').insert({
          household_id: household.id,
          created_by_user_id: userId,
          category_id: categoryId,
          month: formattedSelectedMonth.value,
          allocated_amount: amount,
        });

        if (insertError) throw new Error(insertError.message);
      }

      // Refresh budget data
      await fetchBudgetData();
    } catch (err) {
      console.error('Error allocating budget:', err);
      error.value = err instanceof Error ? err.message : 'Unknown error';
    }
  }

  async function getCategoryAvailable(categoryId: string): Promise<number> {
    const householdStore = useHouseholdStore();
    const { currentHousehold: household } = householdStore;

    if (!household) return 0;

    try {
      const { data, error: rpcError } = await supabase.rpc('fn_get_category_available', {
        p_household_id: household.id,
        p_category_id: categoryId,
        p_month: formattedSelectedMonth.value,
      });

      if (rpcError) throw new Error(rpcError.message);
      return data || 0;
    } catch (err) {
      console.error('Error getting category available:', err);
      return 0;
    }
  }

  return {
    selectedMonth,
    formattedSelectedMonth,
    monthName,
    budgetAllocations,
    availableToBudget,
    categoryBudgets,
    isLoading,
    isAllocationsLoading,
    error,
    setSelectedMonth,
    prevMonth,
    nextMonth,
    fetchBudgetData,
    allocateBudget,
    getCategoryAvailable,
  };
});
