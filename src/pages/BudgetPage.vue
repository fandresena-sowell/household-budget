<template>
  <q-page padding class="budget-page">
    <div class="q-pa-md">
      <div class="row items-center justify-between">
        <div class="text-h6">Budget</div>
        <q-spinner-dots v-if="budgetStore.isLoading" color="primary" size="md" />
      </div>

      <!-- Month Selector -->
      <div class="row justify-center q-mt-md">
        <budget-month-selector
          v-model="budgetStore.selectedMonth"
          @month-change="budgetStore.fetchBudgetData"
        />
      </div>

      <!-- Available to Budget Summary -->
      <q-card class="q-mt-md">
        <q-card-section>
          <div class="text-subtitle1">Available to Budget</div>
          <div class="text-h5" :class="{ 'text-negative': budgetStore.availableToBudget < 0 }">
            {{ formatCurrency(budgetStore.availableToBudget) }}
          </div>
          <div class="text-caption q-mt-sm">
            This is the amount you have available to allocate to your budget categories.
          </div>
        </q-card-section>
      </q-card>

      <!-- Budget Categories -->
      <q-card class="q-mt-md">
        <q-card-section>
          <div class="text-subtitle1">Categories</div>
          <div class="text-caption q-mb-sm">Allocate your available money to these envelopes</div>
        </q-card-section>

        <q-separator />

        <q-list v-if="!budgetStore.isAllocationsLoading">
          <q-item-label header>Expenses</q-item-label>
          <category-budget-item
            v-for="category in budgetStore.categoryBudgets"
            :key="category.category_id"
            :id="category.category_id"
            :name="category.category_name"
            :icon="category.category_icon"
            :allocated="category.allocated_amount"
            :spent="category.spent_amount"
          />
          <q-item v-if="budgetStore.categoryBudgets.length === 0">
            <q-item-section>
              <q-item-label>No categories found</q-item-label>
              <q-item-label caption>
                Add expense categories in the settings menu to start budgeting
              </q-item-label>
            </q-item-section>
          </q-item>
        </q-list>
        <div v-else class="q-pa-md flex flex-center">
          <q-spinner color="primary" size="md" />
        </div>
      </q-card>

      <!-- Budget Summary -->
      <q-card class="q-mt-md">
        <q-card-section>
          <div class="text-subtitle1">Summary</div>
        </q-card-section>

        <q-list>
          <q-item>
            <q-item-section>Total Allocated</q-item-section>
            <q-item-section side>
              {{ formatCurrency(totalAllocated) }}
            </q-item-section>
          </q-item>

          <q-item>
            <q-item-section>Total Spent</q-item-section>
            <q-item-section side>
              {{ formatCurrency(totalSpent) }}
            </q-item-section>
          </q-item>

          <q-item>
            <q-item-section>Remaining in Envelopes</q-item-section>
            <q-item-section side>
              {{ formatCurrency(totalAllocated - totalSpent) }}
            </q-item-section>
          </q-item>
        </q-list>
      </q-card>
    </div>
  </q-page>
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue';
import { useBudgetStore } from 'src/stores/budget-store';
import { useFormatters } from 'src/composables/use-formatters';
import BudgetMonthSelector from 'src/components/BudgetMonthSelector.vue';
import CategoryBudgetItem from 'src/components/CategoryBudgetItem.vue';

const budgetStore = useBudgetStore();
const { formatCurrency } = useFormatters();
// Computed properties
const totalAllocated = computed(() => {
  return budgetStore.categoryBudgets.reduce((sum, category) => {
    return sum + category.allocated_amount;
  }, 0);
});

const totalSpent = computed(() => {
  return budgetStore.categoryBudgets.reduce((sum, category) => {
    return sum + category.spent_amount;
  }, 0);
});

onMounted(async () => {
  await budgetStore.fetchBudgetData();
});
</script>

<style lang="scss" scoped>
.budget-page {
  max-width: 960px;
  margin: 0 auto;
}
</style>
