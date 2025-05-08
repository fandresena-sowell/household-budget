<template>
  <div class="transaction-list">
    <!-- Loading state -->
    <div v-if="isLoading" class="q-pa-md flex flex-center">
      <q-spinner color="primary" size="3em" />
      <div class="q-ml-sm">{{ $t('components.transactionList.loading') }}</div>
    </div>

    <!-- No transactions state -->
    <div v-else-if="groupedTransactions.size === 0" class="q-pa-md">
      <q-card flat class="text-center q-pa-md bg-white text-dark">
        <div class="text-subtitle1 text-weight-bold q-mb-md">
          {{ $t('components.transactionList.emptyTitle') }}
        </div>
        <p class="text-body1 text-grey-7">
          {{ $t('components.transactionList.emptyMessage') }}
        </p>
        <q-img
          width="200px"
          src="~assets/images/empty-state-transactions.svg"
          alt="No transactions"
        />
      </q-card>
    </div>

    <!-- Transactions list grouped by date -->
    <div v-else class="bg-white rounded-borders-top">
      <template v-for="[groupLabel, transactions] in groupedTransactions" :key="groupLabel">
        <!-- Date group header -->
        <div class="q-pt-lg q-pb-sm relative-position">
          <div
            class="q-px-md text-subtitle1 text-grey text-uppercase text-weight-medium q-opacity-3"
          >
            {{ groupLabel }}
          </div>
          <q-separator class="q-mt-sm" color="grey-3" />
        </div>

        <!-- Transactions in this group -->
        <template v-for="transaction in transactions" :key="transaction.id">
          <q-item clickable v-ripple class="q-mb-sm" @click="$emit('edit', transaction)">
            <q-item-section avatar>
              <div class="category-icon-wrapper flex flex-center rounded">
                <q-icon
                  :name="transaction.category?.icon || 'attach_money'"
                  size="24px"
                  color="primary"
                />
              </div>
            </q-item-section>

            <q-item-section>
              <q-item-label class="text-subtitle1 text-weight-medium text-dark q-opacity-8">
                {{ transaction.category?.name || $t('components.transactionList.uncategorized') }}
              </q-item-label>
              <q-item-label v-if="transaction.transaction_date" caption class="text-grey">
                {{ formatDate(transaction.transaction_date) }}
              </q-item-label>
            </q-item-section>

            <q-item-section side>
              <q-item-label
                class="text-subtitle1 text-weight-medium"
                :class="{
                  'text-positive': transaction.amount > 0,
                  'text-negative': transaction.amount < 0,
                }"
              >
                {{ formatCurrency(transaction.amount) }}
              </q-item-label>
            </q-item-section>
          </q-item>

          <q-separator color="grey-3" />
        </template>
      </template>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { useI18n } from 'vue-i18n';
import { useTransactionsStore } from 'src/stores/transactions-store';
import type { Transaction } from 'src/stores/transactions-store';
import { formatCurrency, formatDate } from 'src/utils/formatters';

const { t } = useI18n();

// Props
interface Props {
  accountId?: string;
  showCreator?: boolean;
}
withDefaults(defineProps<Props>(), {
  showCreator: true,
});

// Emits
defineEmits<{
  (e: 'add'): void;
  (e: 'edit', transaction: Transaction): void;
}>();

// Stores
const transactionsStore = useTransactionsStore();

// Computed
const isLoading = computed(() => transactionsStore.isLoading);

// Group and sort transactions by date categories
const groupedTransactions = computed(() => {
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const yesterday = new Date(today);
  yesterday.setDate(yesterday.getDate() - 1);

  const lastWeekStart = new Date(today);
  lastWeekStart.setDate(lastWeekStart.getDate() - 7);

  const lastMonthStart = new Date(today);
  lastMonthStart.setDate(lastMonthStart.getDate() - 30);

  // Sort all transactions by date (newest first)
  const sorted = [...transactionsStore.transactions].sort((a, b) => {
    return new Date(b.transaction_date).getTime() - new Date(a.transaction_date).getTime();
  });

  // Create a Map to preserve insertion order of groups
  const groups = new Map<string, Transaction[]>();
  groups.set(t('components.transactionList.groupToday'), []);
  groups.set(t('components.transactionList.groupYesterday'), []);
  groups.set(t('components.transactionList.groupLastWeek'), []);
  groups.set(t('components.transactionList.groupLastMonth'), []);
  groups.set(t('components.transactionList.groupOthers'), []);

  // Categorize each transaction
  sorted.forEach((transaction) => {
    const transactionDate = new Date(transaction.transaction_date);
    transactionDate.setHours(0, 0, 0, 0);

    if (transactionDate.getTime() === today.getTime()) {
      groups.get(t('components.transactionList.groupToday'))?.push(transaction);
    } else if (transactionDate.getTime() === yesterday.getTime()) {
      groups.get(t('components.transactionList.groupYesterday'))?.push(transaction);
    } else if (transactionDate >= lastWeekStart && transactionDate < yesterday) {
      groups.get(t('components.transactionList.groupLastWeek'))?.push(transaction);
    } else if (transactionDate >= lastMonthStart && transactionDate < lastWeekStart) {
      groups.get(t('components.transactionList.groupLastMonth'))?.push(transaction);
    } else {
      groups.get(t('components.transactionList.groupOthers'))?.push(transaction);
    }
  });

  // Remove empty groups
  for (const [key, transactions] of groups.entries()) {
    if (transactions.length === 0) {
      groups.delete(key);
    }
  }

  return groups;
});
</script>

<style lang="scss" scoped>
/* Custom CSS only for styles not available in Quasar */
.rounded-borders-top {
  border-radius: 16px 16px 0 0;
}

.category-icon-wrapper {
  width: 40px;
  height: 40px;
  background-color: rgba(101, 188, 191, 0.1);
  border-radius: 50%;
}
</style>
