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

    <!-- Account cards -->
    <div class="q-px-md q-pb-xl">
      <div v-if="isLoading" class="q-pa-md flex flex-center">
        <q-spinner color="white" size="3em" />
        <div class="q-ml-sm">Loading accounts...</div>
      </div>

      <div v-else-if="accounts.length === 0" class="q-pa-md">
        <q-card flat bordered class="text-center q-pa-md">
          <div class="text-h6 q-mb-md">No Accounts Yet</div>
          <p class="text-body1">You haven't added any accounts yet.</p>
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
import { onMounted, computed, ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAccountsStore } from 'src/stores/accounts-store';

const accountsStore = useAccountsStore();
const router = useRouter();
const currentPeriod = ref('monthly');

const accounts = computed(() => accountsStore.accounts);
const isLoading = computed(() => accountsStore.isLoading);
const totalBalance = computed(() => accountsStore.totalBalance);

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
