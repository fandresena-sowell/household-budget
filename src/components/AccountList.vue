<template>
  <div class="account-list text-white">
    <!-- Time period filter as q-tabs -->
    <div class="q-px-md q-py-sm">
      <q-tabs
        v-model="currentPeriod"
        class="text-white"
        active-color="white"
        indicator-color="white"
        narrow-indicator
        align="center"
        dense
      >
        <q-tab name="daily" label="DAILY" />
        <q-tab name="weekly" label="WEEKLY" />
        <q-tab name="monthly" label="MONTHLY" />
        <q-tab name="yearly" label="YEARLY" />
      </q-tabs>
    </div>

    <q-carousel
      v-model="slide"
      transition-prev="slide-right"
      transition-next="slide-left"
      swipeable
      animated
      control-color="white"
      navigation
      arrows
      unelevated
      height="300px"
      class="bg-transparent"
    >
      <q-carousel-slide name="balance" class="column no-wrap flex-center">
        <!-- Balance summary -->
        <div class="balance-section q-px-md q-py-md text-center">
          <div class="text-overline text-weight-bold balance-label">BALANCE</div>
          <div
            class="text-h2 text-white q-my-sm text-weight-bold"
            :class="totalBalance >= 0 ? 'text-positive' : 'text-negative'"
          >
            {{ formatCurrency(totalBalance) }}
          </div>
        </div>
      </q-carousel-slide>
      <q-carousel-slide name="transactions" class="row no-wrap flex-center">
        <div class="col-6 row justify-center items-center">
          <q-knob
            show-value
            :min="0"
            :max="100"
            size="115px"
            class="text-white q-ma-md"
            :model-value="transactionPercentage"
            readonly
            color="white"
            track-color="dark-overlay"
            :thickness="0.1"
          >
            <div class="text-white text-weight-bold" style="font-size: 40px; padding-left: 12px">
              {{ transactionPercentage }}
              <span style="font-size: 19px; position: relative; top: -10px; left: -10px">%</span>
            </div>
          </q-knob>
        </div>
        <div class="column">
          <div class="q-px-md q-py-md">
            <div class="text-overline text-weight-bold balance-label">INCOMES</div>
            <div class="text-h5 text-white text-weight-bold text-positive">
              {{ formatCurrency(totalIncome) }}
            </div>
          </div>
          <div class="q-px-md q-py-md">
            <div class="text-overline text-weight-bold balance-label">EXPENSES</div>
            <div class="text-h5 text-white text-weight-bold text-negative">
              {{ formatCurrency(totalExpenses) }}
            </div>
          </div>
        </div>
      </q-carousel-slide>
    </q-carousel>

    <!-- Account cards -->
    <div class="q-px-md q-pb-xl">
      <div v-if="isLoading" class="q-pa-md flex flex-center">
        <q-spinner color="white" size="3em" />
        <div class="q-ml-sm">Loading data...</div>
      </div>

      <div v-else-if="accounts.length === 0" class="q-pa-md">
        <q-card flat bordered class="text-center q-pa-md">
          <div class="text-subtitle1 text-weight-bold q-mb-md text-dark">No Accounts Yet</div>
          <p class="text-body1 text-grey-7">Contact your household manager to add an account.</p>
          <q-img width="200px" src="~assets/images/empty-state-accounts.svg" alt="No accounts" />
        </q-card>
      </div>

      <div v-else>
        <q-card
          v-for="account in accounts"
          :key="account.id"
          flat
          bordered
          class="q-mb-md account-card cursor-pointer"
          @click="goToAccount(account.id)"
        >
          <q-card-section class="q-pa-md">
            <div class="text-subtitle1 text-dark account-name">{{ account.name }}</div>
            <div class="text-caption text-grey">{{ account.account_type?.name }}</div>
            <div
              class="text-h5 text-weight-bold q-mt-xs"
              :class="
                (account.current_balance ?? account.initial_balance) >= 0
                  ? 'text-positive'
                  : 'text-negative'
              "
            >
              {{ formatCurrency(account.current_balance ?? account.initial_balance) }}
            </div>
          </q-card-section>
        </q-card>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, computed, ref, watch } from 'vue';
import { useRouter } from 'vue-router';
import { useAccountsStore } from 'src/stores/accounts-store';
import { useTransactionsStore } from 'src/stores/transactions-store';
import {
  format,
  startOfDay,
  endOfDay,
  startOfWeek,
  endOfWeek,
  startOfMonth,
  endOfMonth,
  startOfYear,
  endOfYear,
} from 'date-fns';

const accountsStore = useAccountsStore();
const router = useRouter();
const currentPeriod = ref('monthly');
const slide = ref('balance');

const accounts = computed(() => accountsStore.accounts);
const isLoadingAccounts = computed(() => accountsStore.isLoading);
const totalBalance = computed(() => accountsStore.totalBalance);

// --- Transaction Data ---
const transactionsStore = useTransactionsStore();
const isLoadingTransactions = computed(() => transactionsStore.isLoading);

// Combined loading state
const isLoading = computed(() => isLoadingAccounts.value || isLoadingTransactions.value);

const currentDateRange = computed(() => {
  const now = new Date();
  let start, end;
  switch (currentPeriod.value) {
    case 'daily':
      start = startOfDay(now);
      end = endOfDay(now);
      break;
    case 'weekly':
      start = startOfWeek(now);
      end = endOfWeek(now);
      break;
    case 'monthly':
    default: // Default to monthly
      start = startOfMonth(now);
      end = endOfMonth(now);
      break;
    case 'yearly':
      start = startOfYear(now);
      end = endOfYear(now);
      break;
  }
  return {
    startDate: format(start, 'yyyy-MM-dd'),
    endDate: format(end, 'yyyy-MM-dd'),
  };
});

const totalIncome = computed(() => {
  return transactionsStore.transactions
    .filter((t) => t.status === 'completed' && t.amount > 0)
    .reduce((sum, t) => sum + t.amount, 0);
});

const totalExpenses = computed(() => {
  // Sum of negative amounts, will result in a negative or zero value
  return transactionsStore.transactions
    .filter((t) => t.status === 'completed' && t.amount < 0)
    .reduce((sum, t) => sum + t.amount, 0);
});

const transactionPercentage = computed(() => {
  const income = totalIncome.value;
  const expenses = Math.abs(totalExpenses.value); // Use absolute value for percentage calculation

  if (income <= 0) {
    return 0; // Avoid division by zero and handle cases with no income
  }
  if (expenses <= 0) {
    return 0; // No expenses
  }

  const percentage = (expenses / income) * 100;
  return Math.min(Math.round(percentage), 100); // Cap at 100% for the knob display
});

// --- Fetching Logic ---
async function fetchTransactionsForPeriod() {
  try {
    await transactionsStore.fetchTransactionsForPeriod(
      currentDateRange.value.startDate,
      currentDateRange.value.endDate,
    );
  } catch (error) {
    console.error('Failed to fetch transactions for period:', error);
    // Handle error (e.g., show a notification)
  }
}

// Watch for period changes to refetch transactions
watch(
  currentPeriod,
  async () => {
    await fetchTransactionsForPeriod();
    slide.value = 'balance';
  },
  { immediate: true },
); // immediate: true to fetch on initial load

function formatCurrency(amount: number): string {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
    minimumFractionDigits: 2,
  }).format(amount);
}

async function goToAccount(accountId: string): Promise<void> {
  await router.push(`/accounts/${accountId}`);
}

onMounted(async () => {
  try {
    // Fetch accounts - transactions are fetched by the watcher
    await accountsStore.fetchAccounts();
  } catch (error) {
    console.error('Failed to fetch accounts:', error);
  }
});
</script>

<style lang="scss" scoped>
.period-btn {
  text-transform: uppercase;
  font-weight: 700;
  letter-spacing: -0.26px;
  opacity: 0.7;

  &.active-period {
    opacity: 1;
  }
}

.balance-section {
  margin-top: 20px;
}

.balance-label {
  font-weight: 600;
  letter-spacing: -0.24px;
  opacity: 0.5;
}

.text-h2 {
  font-size: 40px;
  font-weight: 600;
  letter-spacing: -2px;
}

.account-card {
  border-radius: 8px;
  margin-bottom: 16px;

  .account-name {
    font-weight: 500;
    letter-spacing: -0.32px;
    opacity: 0.6;
  }

  .text-h5 {
    font-size: 28px;
    font-weight: 600;
    letter-spacing: -0.56px;
  }
}
</style>
