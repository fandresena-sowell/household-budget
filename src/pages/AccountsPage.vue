<template>
  <q-page class="text-white" :class="backgroundColor">
    <!-- Header with title and icons from Figma -->
    <q-header :class="backgroundColor">
      <q-toolbar>
        <q-btn flat round dense icon="settings" class="q-mr-sm" @click="openSettings" />
        <q-toolbar-title class="text-h6 text-center text-weight-medium" style="padding-left: 40px">
          {{ $t('pages.accounts.title') }}
        </q-toolbar-title>
        <div class="row q-gutter-x-sm">
          <q-btn flat round dense icon="logout" @click="handleLogout" />
        </div>
      </q-toolbar>
    </q-header>

    <AccountList v-if="householdStore.currentHousehold" />

    <!-- Loading state -->
    <div v-else-if="householdStore.isLoading" class="q-pa-md flex flex-center text-white">
      <q-spinner color="white" size="3em" />
      <div class="q-ml-sm">{{ $t('pages.accounts.loadingHousehold') }}</div>
    </div>
  </q-page>
</template>

<script setup lang="ts">
import { onMounted, computed } from 'vue';
import { useHouseholdStore } from 'src/stores/household-store';
import { useAccountsStore } from 'src/stores/accounts-store';
import { useAuthStore } from 'src/stores/auth-store';
import AccountList from 'src/components/AccountList.vue';
import { useRouter } from 'vue-router';

const householdStore = useHouseholdStore();
const accountsStore = useAccountsStore();
const authStore = useAuthStore();
const router = useRouter();

const backgroundColor = computed(() =>
  accountsStore.totalBalance >= 0 ? 'bg-positive' : 'bg-negative',
);

async function handleLogout() {
  try {
    await authStore.logout();
    // The redirect to login page is already handled in the auth store logout method
  } catch (error) {
    console.error('Logout failed:', error);
  }
}

async function openSettings() {
  await router.push({ name: 'settings' });
}

onMounted(async () => {
  // Ensure household data is loaded
  if (!householdStore.currentHousehold) {
    await householdStore.fetchUserHousehold();
  }
});
</script>

<style lang="scss" scoped></style>
