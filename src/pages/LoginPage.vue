<template>
  <q-page class="login-page">
    <div class="container">
      <!-- Head section -->
      <div class="header-section">
        <div class="app-logo">
          <div class="logo-container">
            <q-icon name="wallet" size="24px" color="white" />
          </div>
          <span class="logo-text">Logoipsum</span>
        </div>
        <h1 class="app-title">Sign in to your Account</h1>
        <div class="signup-link">
          <span class="no-account">Don't have an account?</span>
          <router-link to="/register" class="create-account">Sign Up</router-link>
        </div>
      </div>

      <!-- Input section -->
      <div class="form-container">
        <form @submit.prevent="handleSubmit" class="login-form">
          <!-- Email field -->
          <div class="input-field">
            <label class="field-label">Email</label>
            <q-input
              v-model="email"
              filled
              type="email"
              class="custom-input"
              bg-color="white"
              dense
            />
          </div>

          <!-- Password field -->
          <div class="input-field">
            <label class="field-label">Password</label>
            <q-input
              v-model="password"
              filled
              :type="showPassword ? 'text' : 'password'"
              class="custom-input"
              bg-color="white"
              dense
            >
              <template v-slot:append>
                <q-icon
                  :name="showPassword ? 'visibility_off' : 'visibility'"
                  class="cursor-pointer"
                  color="grey"
                  @click="showPassword = !showPassword"
                />
              </template>
            </q-input>
          </div>

          <!-- Remember me / Forgot password -->
          <div class="login-options">
            <div class="remember-me">
              <q-checkbox v-model="rememberMe" color="grey" size="xs" dense />
              <span>Remember me</span>
            </div>
            <router-link to="/forgot-password" class="forgot-password">
              Forgot Password ?
            </router-link>
          </div>

          <!-- Login button -->
          <q-btn
            type="submit"
            color="primary"
            class="login-btn"
            :loading="loading"
            no-caps
            unelevated
          >
            Log In
          </q-btn>

          <!-- Divider -->
          <div class="divider">
            <div class="line"></div>
            <span class="divider-text">Or login with</span>
            <div class="line"></div>
          </div>

          <!-- Social buttons -->
          <div class="social-buttons">
            <q-btn outline class="social-btn" no-caps>
              <img src="~assets/images/icons/google.svg" class="social-icon" alt="Google icon" />
              Google
            </q-btn>
            <q-btn outline class="social-btn" no-caps>
              <img
                src="~assets/images/icons/facebook.svg"
                class="social-icon"
                alt="Facebook icon"
              />
              Facebook
            </q-btn>
          </div>
        </form>
      </div>

      <!-- Terms text -->
      <p class="terms-text">
        By signing up, you agree to the <span class="terms-link">Terms of Service</span> and
        <span class="terms-link">Data Processing Agreement</span>
      </p>
    </div>
  </q-page>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useQuasar } from 'quasar';
import { useAuthStore } from 'src/stores/auth-store';
import { useHouseholdStore } from 'src/stores/household-store';

const $q = useQuasar();
const router = useRouter();
const authStore = useAuthStore();
const householdStore = useHouseholdStore();

const email = ref('');
const password = ref('');
const rememberMe = ref(false);
const showPassword = ref(false);
const loading = ref(false);

const handleSubmit = async () => {
  if (!email.value || !password.value) {
    $q.notify({
      type: 'negative',
      message: 'Please fill in all required fields',
    });
    return;
  }

  try {
    loading.value = true;

    // Login with auth store
    const { error } = await authStore.login(email.value, password.value);

    if (error) throw error as Error;

    // Fetch household data
    await householdStore.fetchUserHousehold();

    // Redirect to dashboard on successful login
    await router.push('/');

    $q.notify({
      type: 'positive',
      message: 'Login successful!',
    });
  } catch (error: unknown) {
    const errorMessage = error instanceof Error ? error.message : 'An error occurred during login';
    $q.notify({
      type: 'negative',
      message: errorMessage,
    });
  } finally {
    loading.value = false;
  }
};
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  background-color: white;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.container {
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: stretch;
}

/* Header section styles */
.header-section {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  margin-bottom: 32px;
  padding: 24px;
  background-color: #0d0d1b;
  position: relative;
  overflow: hidden;
}

.header-section::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  opacity: 0.6;
  background-image: radial-gradient(circle, rgba(255, 255, 255, 0.2) 1px, transparent 1px);
  background-size: 30px 30px;
  z-index: 0;
}

.app-logo {
  display: flex;
  align-items: center;
  margin-bottom: 24px;
  position: relative;
  z-index: 1;
}

.logo-container {
  width: 32px;
  height: 32px;
  background-color: #375dfb;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 8px;
}

.logo-text {
  font-size: 18px;
  font-weight: 600;
  color: white;
}

.app-title {
  color: white;
  font-size: 28px;
  font-weight: 700;
  margin: 0 0 12px 0;
  position: relative;
  z-index: 1;
}

.signup-link {
  display: flex;
  align-items: center;
  gap: 6px;
  position: relative;
  z-index: 1;
}

.no-account {
  color: rgba(255, 255, 255, 0.7);
  font-size: 14px;
  font-weight: 400;
}

.create-account {
  color: #4d81e7;
  font-size: 14px;
  font-weight: 600;
  text-decoration: none;
}

/* Form container styles */
.form-container {
  width: 100%;
  margin-bottom: 24px;
  padding: 20px;
}

.login-form {
  width: 100%;
}

.input-field {
  margin-bottom: 16px;
}

.field-label {
  display: block;
  color: #6c7278;
  font-size: 12px;
  font-weight: 500;
  margin-bottom: 2px;
}

.custom-input :deep(.q-field__control) {
  height: 54px;
  border-radius: 8px;
  border: 1px solid #edf1f3;
  box-shadow: 0px 1px 2px 0px rgba(228, 229, 231, 0.24);
}

.custom-input :deep(.q-field__native) {
  padding-left: 4px;
}

.login-options {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.remember-me {
  display: flex;
  align-items: center;
  gap: 5px;
}

.remember-me span {
  color: #6c7278;
  font-size: 12px;
  font-weight: 500;
}

.forgot-password {
  color: #4d81e7;
  font-size: 12px;
  font-weight: 600;
  text-decoration: none;
}

/* Button styles */
.login-btn {
  width: 100%;
  height: 46px;
  border-radius: 8px;
  font-weight: 500;
  font-size: 14px;
  margin-bottom: 24px;
  box-shadow:
    0px 0px 0px 1px rgba(55, 93, 251, 1),
    0px 1px 2px 0px rgba(37, 62, 167, 0.48);
}

.divider {
  display: flex;
  align-items: center;
  width: 100%;
  margin-bottom: 16px;
}

.line {
  flex: 1;
  height: 1px;
  background-color: #edf1f3;
}

.divider-text {
  margin: 0 16px;
  color: #6c7278;
  font-size: 12px;
  font-weight: 400;
}

.social-buttons {
  display: flex;
  justify-content: space-between;
  gap: 15px;
}

.social-btn {
  flex: 1;
  height: 46px;
  border-radius: 8px;
  border: 1px solid #eff0f6;
  font-weight: 600;
  font-size: 14px;
  color: #1a1c1e;
  box-shadow: inset 0px -3px 6px 0px rgba(244, 245, 250, 0.6);
}

.social-icon {
  width: 18px;
  height: 18px;
  margin-right: 8px;
}

/* Terms text */
.terms-text {
  text-align: center;
  color: #6c7278;
  font-size: 12px;
  font-weight: 500;
  margin-top: 8px;
  padding: 0 20px;
}

.terms-link {
  color: #1a1c1e;
  text-decoration: none;
}
</style>
