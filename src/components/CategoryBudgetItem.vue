<template>
  <q-item clickable v-ripple @click="openAllocationDialog">
    <q-item-section avatar>
      <q-icon :name="icon" />
    </q-item-section>

    <q-item-section>
      <q-item-label>{{ name }}</q-item-label>
      <q-item-label caption> {{ formatCurrency(allocated) }} allocated </q-item-label>
    </q-item-section>

    <q-item-section side>
      <budget-progress :allocated="allocated" :spent="spent" :label="name" :show-details="false" />
    </q-item-section>
  </q-item>
</template>

<script setup lang="ts">
import { useQuasar } from 'quasar';
import { useBudgetStore } from 'src/stores/budget-store';
import { useFormatters } from 'src/composables/use-formatters';
import BudgetProgress from './BudgetProgress.vue';
import BudgetAllocationDialog from './BudgetAllocationDialog.vue';

const props = defineProps({
  id: {
    type: String,
    required: true,
  },
  name: {
    type: String,
    required: true,
  },
  icon: {
    type: String,
    default: 'attach_money',
  },
  allocated: {
    type: Number,
    default: 0,
  },
  spent: {
    type: Number,
    default: 0,
  },
});

const $q = useQuasar();
const budgetStore = useBudgetStore();
const { formatCurrency } = useFormatters();
function openAllocationDialog() {
  $q.dialog({
    component: BudgetAllocationDialog,
    componentProps: {
      categoryId: props.id,
      categoryName: props.name,
      currentAllocation: props.allocated,
      spentAmount: props.spent,
      availableToBudget: budgetStore.availableToBudget,
      monthName: budgetStore.monthName,
    },
  }).onOk(async (amount: number) => {
    // Handle allocation
    await budgetStore.allocateBudget(props.id, amount);
  });
}
</script>
