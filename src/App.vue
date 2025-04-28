<template>
  <router-view />
</template>

<script setup lang="ts">
import { onMounted, watch } from 'vue';
import { useAuthStore } from 'src/stores/auth-store';
import { useHouseholdStore } from 'src/stores/household-store';
import { useCategoriesStore } from 'src/stores/categories-store';

const authStore = useAuthStore();
const householdStore = useHouseholdStore();
const categoriesStore = useCategoriesStore();

// Watch for authentication state changes
watch(
  () => authStore.isAuthenticated,
  async (isAuthenticated) => {
    if (isAuthenticated) {
      // Load household data when authenticated
      try {
        await householdStore.fetchUserHousehold();

        // Fetch categories - no need to initialize anymore as they are created by the database trigger
        await categoriesStore.fetchCategories();
      } catch (error) {
        console.error('Error initializing app data:', error);
      }
    }
  },
);

onMounted(async () => {
  // Setup auth state listener
  authStore.setupAuthListener();

  // Check current auth status
  try {
    await authStore.checkAuth();
  } catch (error) {
    console.error('Error checking authentication status:', error);
  }
});
</script>
