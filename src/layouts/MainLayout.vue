<template>
  <q-layout view="lHh Lpr lFf">
    <q-header elevated>
      <q-toolbar>
        <q-btn flat dense round icon="menu" aria-label="Menu" @click="toggleLeftDrawer" />

        <q-toolbar-title> Household Budget </q-toolbar-title>

        <q-btn
          v-if="authStore.isAuthenticated"
          flat
          dense
          round
          icon="logout"
          aria-label="Logout"
          @click="handleLogout"
        />
      </q-toolbar>
    </q-header>

    <q-drawer v-model="leftDrawerOpen" show-if-above bordered>
      <q-list>
        <q-item-label header> Main Navigation </q-item-label>

        <EssentialLink v-for="link in appLinks" :key="link.title" v-bind="link" />
      </q-list>
    </q-drawer>

    <q-page-container>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { useQuasar } from 'quasar';
import { useAuthStore } from 'src/stores/auth-store';
import EssentialLink, { type EssentialLinkProps } from 'components/EssentialLink.vue';

const $q = useQuasar();
const authStore = useAuthStore();

const appLinks: EssentialLinkProps[] = [
  {
    title: 'Dashboard',
    caption: 'Overview of your finances',
    icon: 'dashboard',
    link: '/',
  },
  {
    title: 'Accounts',
    caption: 'Manage your accounts',
    icon: 'account_balance',
    link: '/accounts',
  },
  {
    title: 'Transactions',
    caption: 'View and manage transactions',
    icon: 'receipt_long',
    link: '/transactions',
  },
  {
    title: 'Categories',
    caption: 'Organize your finances with categories',
    icon: 'category',
    link: '/categories',
  },
  {
    title: 'Household',
    caption: 'Manage household members',
    icon: 'people',
    link: '/household',
  },
  {
    title: 'Settings',
    caption: 'App preferences and configuration',
    icon: 'settings',
    link: '/settings',
  },
];

const leftDrawerOpen = ref(false);

function toggleLeftDrawer() {
  leftDrawerOpen.value = !leftDrawerOpen.value;
}

async function handleLogout() {
  try {
    await authStore.logout();
    $q.notify({
      type: 'positive',
      message: 'You have been logged out successfully',
    });
  } catch (error) {
    console.error('Logout error:', error);
    $q.notify({
      type: 'negative',
      message: 'Error logging out',
    });
  }
}
</script>
