import { defineStore, acceptHMRUpdate } from 'pinia';
import { supabase } from 'src/boot/supabase';
import type { User } from '@supabase/supabase-js';
import type { Tables } from 'src/types/database.types';
import { ref, computed } from 'vue';
import { useRouter } from 'vue-router';

export const useAuthStore = defineStore('auth', () => {
  // State
  const user = ref<User | null>(null);
  const isLoading = ref(false);
  const router = useRouter();

  // Getters
  const isAuthenticated = computed(() => !!user.value);
  const userId = computed(() => user.value?.id);
  const userEmail = computed(() => user.value?.email);
  const userMetadata = computed(() => user.value?.user_metadata);

  // Actions
  async function register(
    email: string,
    password: string,
    metadata: Partial<Pick<Tables<'users'>, 'first_name' | 'last_name'>> = {},
    target_household_id?: string,
  ) {
    isLoading.value = true;

    try {
      const { data, error } = await supabase.auth.signUp({
        email,
        password,
        options: {
          data: {
            ...metadata,
            target_household_id,
          },
        },
      });

      if (error) throw error;
      return { data, error: null };
    } catch (error) {
      console.error('Registration error:', error);
      return { data: null, error };
    } finally {
      isLoading.value = false;
    }
  }

  async function login(email: string, password: string) {
    isLoading.value = true;

    try {
      const { data, error } = await supabase.auth.signInWithPassword({
        email,
        password,
      });

      if (error) throw error;
      user.value = data.user;
      return { data, error: null };
    } catch (error) {
      console.error('Login error:', error);
      return { data: null, error };
    } finally {
      isLoading.value = false;
    }
  }

  async function logout() {
    isLoading.value = true;

    try {
      const { error } = await supabase.auth.signOut();
      if (error) throw error;
      user.value = null;

      // Navigate to login
      await router.push({ name: 'login' });
    } catch (error) {
      console.error('Logout error:', error);
    } finally {
      isLoading.value = false;
    }
  }

  async function checkAuth() {
    isLoading.value = true;

    try {
      const { data } = await supabase.auth.getSession();
      if (data?.session) {
        user.value = data.session.user;
      }
    } catch (error) {
      console.error('Auth check error:', error);
    } finally {
      isLoading.value = false;
    }
  }

  // Setup auth state change listener
  function setupAuthListener() {
    supabase.auth.onAuthStateChange((event, session) => {
      if (session && session.user) {
        user.value = session.user;
      } else {
        user.value = null;
      }
    });
  }

  return {
    // State
    user,
    isLoading,

    // Getters
    isAuthenticated,
    userId,
    userEmail,
    userMetadata,

    // Actions
    register,
    login,
    logout,
    checkAuth,
    setupAuthListener,
  };
});

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useAuthStore, import.meta.hot));
}
