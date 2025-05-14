<template>
  <q-page class="text-white bg-white">
    <!-- Header with back button and icons from Figma -->
    <q-header :class="backgroundColor">
      <q-toolbar>
        <div class="row items-center">
          <q-btn flat round dense icon="arrow_back" class="q-mr-sm" to="/accounts" />
        </div>
        <q-toolbar-title class="text-h6 text-center text-weight-medium" style="padding-left: 40px">
          {{ account?.name || $t('pages.accountDetail.defaultTitle') }}
        </q-toolbar-title>
        <div class="row q-gutter-x-sm">
          <q-btn flat round dense icon="add_circle_outline" @click="openAddDialog" />
          <q-btn flat round dense icon="logout" @click="handleLogout" />
        </div>
      </q-toolbar>
    </q-header>

    <!-- Loading state -->
    <div v-if="isLoading" class="q-pa-md flex flex-center" :class="backgroundColor">
      <q-spinner color="white" size="3em" />
      <div class="q-ml-sm">{{ $t('pages.accountDetail.loading') }}</div>
    </div>

    <template v-else-if="account">
      <div :class="backgroundColor">
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
            <q-tab name="daily" :label="t('pages.accountDetail.tabDaily')" />
            <q-tab name="weekly" :label="t('pages.accountDetail.tabWeekly')" />
            <q-tab name="monthly" :label="t('pages.accountDetail.tabMonthly')" />
            <q-tab name="yearly" :label="t('pages.accountDetail.tabYearly')" />
          </q-tabs>
        </div>

        <!-- Carousel for Balance and Income/Expense Summary -->
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
              <div class="text-overline text-weight-bold q-opacity-5">
                {{ $t('pages.accountDetail.carouselBalanceLabel') }}
              </div>
              <div
                class="balance-value text-white q-my-sm text-weight-bold"
                :class="
                  (account.current_balance || account.initial_balance) >= 0
                    ? 'text-positive'
                    : 'text-negative'
                "
              >
                {{ formatCurrency(account.current_balance || account.initial_balance) }}
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
                <div
                  class="text-white text-weight-bold"
                  style="font-size: 40px; padding-left: 12px"
                >
                  {{ transactionPercentage }}
                  <span style="font-size: 19px; position: relative; top: -10px; left: -10px"
                    >%</span
                  >
                </div>
              </q-knob>
            </div>
            <div class="column">
              <div class="q-px-md q-py-md">
                <div class="text-overline text-weight-bold balance-label q-opacity-5">
                  {{ $t('pages.accountDetail.carouselIncomesLabel') }}
                </div>
                <div class="text-h6 text-white text-weight-bold text-positive">
                  {{ formatCurrency(totalIncome) }}
                </div>
              </div>
              <div class="q-px-md q-py-md">
                <div class="text-overline text-weight-bold balance-label q-opacity-5">
                  {{ $t('pages.accountDetail.carouselExpensesLabel') }}
                </div>
                <div class="text-h6 text-white text-weight-bold text-negative">
                  {{ formatCurrency(totalExpenses) }}
                </div>
              </div>
            </div>
          </q-carousel-slide>
        </q-carousel>

        <!-- Transactions list -->
        <div class="bg-white rounded-borders q-mt-md transactions-container">
          <transaction-list :account-id="accountId" @add="openAddDialog" @edit="openEditDialog" />
        </div>
      </div>
    </template>

    <div v-else class="q-pa-md">
      <q-card flat bordered class="text-center q-pa-md">
        <div class="text-h6 q-mb-md">{{ $t('pages.accountDetail.errorNotFoundTitle') }}</div>
        <p class="text-body1">
          {{ $t('pages.accountDetail.errorNotFoundMessage') }}
        </p>
        <q-btn color="primary" label="Go to Accounts" to="/accounts" no-caps unelevated />
      </q-card>
    </div>

    <!-- Fullscreen Dialog for Add/Edit Transaction -->
    <q-dialog v-model="transactionDialog" maximized persistent>
      <transaction-form
        :transaction="currentTransaction"
        :is-edit="isEdit"
        :account-id="accountId"
        @submit="handleSubmit"
        @cancel="transactionDialog = false"
        @delete="handleDeleteTransaction"
      />
    </q-dialog>
  </q-page>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useQuasar } from 'quasar';
import { useI18n } from 'vue-i18n';
import { format, startOfDay, endOfDay } from 'date-fns'; // Import date-fns functions
import { useAccountsStore } from 'src/stores/accounts-store';
import { useTransactionsStore, type Transaction } from 'src/stores/transactions-store';
import { useHouseholdStore } from 'src/stores/household-store';
import { useAuthStore } from 'src/stores/auth-store';
import { useFormatters } from 'src/composables/use-formatters';
import TransactionList from 'src/components/TransactionList.vue';
import TransactionForm from 'src/components/TransactionForm.vue';

// Initialize
const $q = useQuasar();
const route = useRoute();
const router = useRouter();
const { t } = useI18n();
const householdStore = useHouseholdStore();
const accountsStore = useAccountsStore();
const transactionsStore = useTransactionsStore();
const authStore = useAuthStore();
const { formatCurrency } = useFormatters();
// State
const transactionDialog = ref(false);
const isEdit = ref(false);
const currentTransaction = ref<Transaction | null>(null);
const currentPeriod = ref('monthly'); // Keep track of the selected period
const slide = ref('balance'); // Add state for carousel slide

// Route params
const accountId = computed(() => route.params.id as string);

// Computed
const isLoading = computed(() => accountsStore.isLoading || transactionsStore.isLoading);
const account = computed(() => accountsStore.accounts.find((acc) => acc.id === accountId.value));
const backgroundColor = computed(() => {
  if (!account.value) return 'bg-positive';
  return (account.value.current_balance || account.value.initial_balance) >= 0
    ? 'bg-positive'
    : 'bg-negative';
});

// Calculate date range based on currentPeriod
const currentDateRange = computed(() => {
  const now = new Date();
  let start, end;
  switch (currentPeriod.value) {
    case 'daily':
      start = startOfDay(now);
      end = endOfDay(now);
      break;
    case 'weekly':
      start = startOfDay(new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000));
      end = endOfDay(now);
      break;
    case 'monthly':
    default: // Default to monthly
      start = startOfDay(new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000));
      end = endOfDay(now);
      break;
    case 'yearly':
      start = startOfDay(new Date(now.getTime() - 365 * 24 * 60 * 60 * 1000));
      end = endOfDay(now);
      break;
  }
  return {
    startDate: format(start, 'yyyy-MM-dd'),
    endDate: format(end, 'yyyy-MM-dd'),
  };
});

// Computed properties for Income/Expense Summary based on filtered transactions
const totalIncome = computed(() => {
  return transactionsStore.transactions
    .filter((t) => t.status === 'completed' && t.amount > 0)
    .reduce((sum, t) => sum + t.amount, 0);
});

const totalExpenses = computed(() => {
  // Sum of negative amounts
  return transactionsStore.transactions
    .filter((t) => t.status === 'completed' && t.amount < 0)
    .reduce((sum, t) => sum + t.amount, 0);
});

const transactionPercentage = computed(() => {
  const income = totalIncome.value;
  const expenses = Math.abs(totalExpenses.value);

  if (income <= 0) {
    return 0;
  }
  if (expenses <= 0) {
    return 0;
  }

  const percentage = (expenses / income) * 100;
  return Math.min(Math.round(percentage), 100);
});

// Fetch transactions for the current account and period
async function fetchAccountTransactionsForPeriod() {
  if (!accountId.value) return;
  try {
    await transactionsStore.fetchTransactionsForAccountAndPeriod(
      accountId.value,
      currentDateRange.value.startDate,
      currentDateRange.value.endDate,
    );
  } catch (error) {
    console.error('Failed to fetch transactions for account and period:', error);
    // Optionally show error notification
  }
}

// Methods
function openAddDialog() {
  isEdit.value = false;
  currentTransaction.value = null;
  transactionDialog.value = true;
}

function openEditDialog(transaction: Transaction) {
  isEdit.value = true;
  currentTransaction.value = transaction;
  transactionDialog.value = true;
}

async function handleLogout() {
  try {
    await authStore.logout();
    await router.push({ name: 'login' });
  } catch (error) {
    console.error('Logout failed:', error);
  }
}

async function handleSubmit(formData: any) {
  try {
    if (isEdit.value && currentTransaction.value) {
      // Update existing transaction
      const { error } = await transactionsStore.updateTransaction(
        currentTransaction.value.id,
        formData,
      );

      if (error) throw error;

      $q.notify({
        message: 'Transaction updated successfully',
      });
    } else {
      // Create new transaction
      const { error } = await transactionsStore.createTransaction(formData);

      if (error) throw error;

      $q.notify({
        message: 'Transaction added successfully',
      });
    }

    // Close dialog
    transactionDialog.value = false;

    // Refresh account balances
    await accountsStore.fetchAccounts();
  } catch (err) {
    console.error('Error saving transaction:', err);
    $q.notify({
      color: 'negative',
      textColor: 'white',
      message: `Failed to ${isEdit.value ? 'update' : 'add'} transaction`,
    });
  }
}

function handleDeleteTransaction(transaction: Transaction) {
  try {
    // Confirm deletion
    $q.dialog({
      title: 'Confirm Deletion',
      message: 'Are you sure you want to delete this transaction?',
      cancel: true,
      persistent: true,
    }).onOk(async () => {
      const { error } = await transactionsStore.deleteTransaction(transaction.id);

      if (error) throw error;

      $q.notify({
        message: 'Transaction deleted successfully',
      });

      // Close dialog
      transactionDialog.value = false;

      // Refresh account balances
      await accountsStore.fetchAccounts();
    });
  } catch (err) {
    console.error('Error deleting transaction:', err);
    $q.notify({
      color: 'negative',
      textColor: 'white',
      message: 'Failed to delete transaction',
    });
  }
}

// Watch for route changes (account ID)
watch(accountId, async (newId) => {
  if (newId) {
    // When account changes, fetch data for the current period
    await fetchAccountTransactionsForPeriod();
    slide.value = 'balance';
  }
});

// Watch for period changes
watch(currentPeriod, async () => {
  // When period changes, fetch data for the current account
  await fetchAccountTransactionsForPeriod();
  slide.value = 'balance';
});

// Initialize data
onMounted(async () => {
  // Ensure household data is loaded
  if (!householdStore.currentHousehold) {
    await householdStore.fetchUserHousehold();
  }
  if (accountsStore.accounts.length === 0) {
    await accountsStore.fetchAccounts();
  }

  // Initial fetch for the current account and default period
  await fetchAccountTransactionsForPeriod();
});
</script>

<style lang="scss" scoped>
/* Only custom styles that can't be achieved with Quasar classes */
.rounded-borders {
  border-top-left-radius: 16px;
  border-top-right-radius: 16px;
}

.transactions-container {
  min-height: 60vh;
}

.balance-value {
  font-size: 40px;
  font-weight: 600;
  letter-spacing: -2px;
}
</style>
