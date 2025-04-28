import { defineStore, acceptHMRUpdate } from 'pinia';
import { ref, computed } from 'vue';
import { supabase } from 'src/boot/supabase';
import { useHouseholdStore } from './household-store';

export interface Category {
  id: string;
  name: string;
  type: 'income' | 'expense';
  created_at: string | null;
  household_id: string;
  created_by_user_id: string;
}

export const useCategoriesStore = defineStore('categories', () => {
  // State
  const categories = ref<Category[]>([]);
  const isLoading = ref(false);
  const error = ref<Error | null>(null);

  // Getters
  const incomeCategories = computed(() => {
    return categories.value
      .filter((category) => category.type === 'income')
      .sort((a, b) => a.name.localeCompare(b.name));
  });

  const expenseCategories = computed(() => {
    return categories.value
      .filter((category) => category.type === 'expense')
      .sort((a, b) => a.name.localeCompare(b.name));
  });

  // Actions
  async function fetchCategories() {
    const householdStore = useHouseholdStore();
    const householdId = householdStore.householdId;

    if (!householdId) {
      console.error('fetchCategories - No household ID found');
      return;
    }

    isLoading.value = true;
    error.value = null;

    try {
      const { data, error: fetchError } = await supabase
        .from('categories')
        .select('*')
        .eq('household_id', householdId)
        .order('name');

      if (fetchError) throw fetchError;

      if (data) {
        // Cast the data to ensure type compatibility
        categories.value = data.map((item) => ({
          ...item,
          type: item.type as 'income' | 'expense',
        }));
      }
    } catch (err) {
      console.error('Error fetching categories:', err);
      error.value = err instanceof Error ? err : new Error('Failed to fetch categories');
    } finally {
      isLoading.value = false;
    }
  }

  async function createCategory(categoryData: Omit<Category, 'id' | 'created_at'>) {
    isLoading.value = true;
    error.value = null;

    try {
      const { data, error: insertError } = await supabase
        .from('categories')
        .insert(categoryData)
        .select()
        .single();

      if (insertError) throw insertError;

      if (data) {
        // Add the new category to the list with proper type casting
        const newCategory: Category = {
          ...data,
          type: data.type as 'income' | 'expense',
        };
        categories.value.push(newCategory);

        // Re-sort the categories
        categories.value.sort((a, b) => {
          if (a.type === b.type) return a.name.localeCompare(b.name);
          return a.type === 'income' ? -1 : 1;
        });
      }

      return { data, error: null };
    } catch (err) {
      console.error('Error creating category:', err);
      error.value = err instanceof Error ? err : new Error('Failed to create category');
      return { data: null, error: error.value };
    } finally {
      isLoading.value = false;
    }
  }

  async function updateCategory(
    categoryId: string,
    updateData: Partial<Omit<Category, 'id' | 'created_at'>>,
  ) {
    isLoading.value = true;
    error.value = null;

    try {
      const { data, error: updateError } = await supabase
        .from('categories')
        .update(updateData)
        .eq('id', categoryId)
        .select()
        .single();

      if (updateError) throw updateError;

      if (data) {
        // Update the category in the list with proper type casting
        const updatedCategory: Category = {
          ...data,
          type: data.type as 'income' | 'expense',
        };

        const index = categories.value.findIndex((cat) => cat.id === categoryId);
        if (index >= 0) {
          categories.value[index] = updatedCategory;
        }

        // Re-sort the categories
        categories.value.sort((a, b) => {
          if (a.type === b.type) return a.name.localeCompare(b.name);
          return a.type === 'income' ? -1 : 1;
        });
      }

      return { data, error: null };
    } catch (err) {
      console.error('Error updating category:', err);
      error.value = err instanceof Error ? err : new Error('Failed to update category');
      return { data: null, error: error.value };
    } finally {
      isLoading.value = false;
    }
  }

  async function deleteCategory(categoryId: string) {
    isLoading.value = true;
    error.value = null;

    try {
      const { error: deleteError } = await supabase
        .from('categories')
        .delete()
        .eq('id', categoryId);

      if (deleteError) throw deleteError;

      // Remove the category from the list
      categories.value = categories.value.filter((cat) => cat.id !== categoryId);

      return { error: null };
    } catch (err) {
      console.error('Error deleting category:', err);
      error.value = err instanceof Error ? err : new Error('Failed to delete category');
      return { error: error.value };
    } finally {
      isLoading.value = false;
    }
  }

  return {
    // State
    categories,
    isLoading,
    error,

    // Getters
    incomeCategories,
    expenseCategories,

    // Actions
    fetchCategories,
    createCategory,
    updateCategory,
    deleteCategory,
  };
});

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useCategoriesStore, import.meta.hot));
}
