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
        <div v-for="transaction in transactions" :key="transaction.id">
          <!-- Transaction item -->
          <div class="relative-position q-pb-xs cursor-pointer" @click="$emit('edit', transaction)">
            <div class="row q-pa-md items-center no-wrap">
              <!-- Category icon -->
              <div class="category-icon-wrapper q-mr-md flex flex-center rounded">
                <q-icon
                  :name="getCategoryIcon(transaction.category?.name)"
                  size="24px"
                  color="primary"
                />
              </div>

              <!-- Transaction details -->
              <div class="col">
                <div class="text-subtitle1 text-weight-medium text-dark q-opacity-8">
                  {{ transaction.category?.name || $t('components.transactionList.uncategorized') }}
                </div>
                <div v-if="transaction.description" class="text-caption text-grey">
                  {{ transaction.description }}
                </div>
              </div>

              <!-- Amount -->
              <div
                class="text-subtitle1 text-weight-medium text-right q-ml-md"
                :class="{
                  'text-positive': transaction.amount > 0,
                  'text-negative': transaction.amount < 0,
                }"
              >
                {{ formatCurrency(transaction.amount) }}
              </div>
            </div>

            <!-- Separator -->
            <q-separator color="grey-3" />
          </div>
        </div>
      </template>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { useI18n } from 'vue-i18n';
import { useTransactionsStore } from 'src/stores/transactions-store';
import type { Transaction } from 'src/stores/transactions-store';

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

  // Sort all transactions by date (newest first)
  const sorted = [...transactionsStore.transactions].sort((a, b) => {
    return new Date(b.transaction_date).getTime() - new Date(a.transaction_date).getTime();
  });

  // Create a Map to preserve insertion order of groups
  const groups = new Map<string, Transaction[]>();
  groups.set(t('components.transactionList.groupToday'), []);
  groups.set(t('components.transactionList.groupYesterday'), []);
  groups.set(t('components.transactionList.groupLastWeek'), []);
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

function formatCurrency(amount: number): string {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
    minimumFractionDigits: 2,
  }).format(amount);
}

function getCategoryIcon(categoryName?: string): string {
  if (!categoryName) return 'attach_money';

  const name = categoryName.toLowerCase();

  if (name.includes('salary') || name.includes('income') || name.includes('revenue')) {
    return 'img:src/assets/icons/Money.svg';
  }
  if (name.includes('car') || name.includes('transport')) {
    return 'img:src/assets/icons/Car.svg';
  }
  if (name.includes('house') || name.includes('rent') || name.includes('mortgage')) {
    return 'img:src/assets/icons/House.svg';
  }
  if (name.includes('food') || name.includes('restaurant') || name.includes('dining')) {
    return 'img:src/assets/icons/Restaurant.svg';
  }
  if (name.includes('coffee')) {
    return 'img:src/assets/icons/Coffee.svg';
  }
  if (name.includes('phone') || name.includes('mobile')) {
    return 'img:src/assets/icons/Phone.svg';
  }
  if (name.includes('entertainment')) {
    return 'img:src/assets/icons/Entertaintment.svg';
  }

  // Default icon if no match
  return 'attach_money';
}
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
