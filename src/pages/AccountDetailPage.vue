<template>
  <q-page class="text-white bg-white">
    <!-- Header with back button and icons from Figma -->
    <q-header :class="backgroundColor">
      <q-toolbar>
        <div class="row items-center">
          <q-btn flat round dense icon="arrow_back" class="q-mr-sm" to="/accounts" />
        </div>
        <q-toolbar-title class="text-h6 text-center text-weight-medium" style="padding-left: 40px">
          {{ account?.name || 'Account' }}
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
      <div class="q-ml-sm">Loading account details...</div>
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
            <q-tab name="daily" label="DAILY" />
            <q-tab name="weekly" label="WEEKLY" />
            <q-tab name="monthly" label="MONTHLY" />
            <q-tab name="yearly" label="YEARLY" />
          </q-tabs>
        </div>

        <!-- Balance summary -->
        <div class="q-px-md q-py-md text-center q-mt-lg">
          <div class="text-overline text-weight-bold q-opacity-5">BALANCE</div>
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

        <!-- Transactions list -->
        <div class="bg-white rounded-borders q-mt-md transactions-container">
          <transaction-list :account-id="accountId" @add="openAddDialog" @edit="openEditDialog" />
        </div>
      </div>
    </template>

    <div v-else class="q-pa-md">
      <q-card flat bordered class="text-center q-pa-md">
        <div class="text-h6 q-mb-md">Account Not Found</div>
        <p class="text-body1">
          The account you are looking for does not exist or you don't have access to it.
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
import { useRoute } from 'vue-router';
import { useQuasar } from 'quasar';
import { useAccountsStore } from 'src/stores/accounts-store';
import { useTransactionsStore, type Transaction } from 'src/stores/transactions-store';
import { useHouseholdStore } from 'src/stores/household-store';
import { useAuthStore } from 'src/stores/auth-store';
import TransactionList from 'src/components/TransactionList.vue';
import TransactionForm from 'src/components/TransactionForm.vue';

// Initialize
const $q = useQuasar();
const route = useRoute();
const householdStore = useHouseholdStore();
const accountsStore = useAccountsStore();
const transactionsStore = useTransactionsStore();
const authStore = useAuthStore();

// State
const transactionDialog = ref(false);
const isEdit = ref(false);
const currentTransaction = ref<Transaction | null>(null);
const currentPeriod = ref('monthly');

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

// Methods
function formatCurrency(amount: number): string {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
    minimumFractionDigits: 2,
  }).format(amount);
}

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
    // The redirect to login page is already handled in the auth store logout method
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

// Watch for route changes
watch(
  () => route.params.id,
  async (newId) => {
    if (newId) {
      await transactionsStore.fetchTransactionsForAccount(newId as string);
    }
  },
);

// Initialize data
onMounted(async () => {
  // Ensure household data is loaded
  if (!householdStore.currentHousehold) {
    await householdStore.fetchUserHousehold();
  }
  if (accountsStore.accounts.length === 0) {
    await accountsStore.fetchAccounts();
  }

  if (accountId.value) {
    await transactionsStore.fetchTransactionsForAccount(accountId.value);
  }
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
