<template>
  <router-view />
</template>

<script setup lang="ts">
import { onMounted } from 'vue';
import { useAuthStore } from 'src/stores/auth-store';

const authStore = useAuthStore();

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
