<template>
  <q-page class="register-page">
    <div class="container">
      <!-- Head section -->
      <div class="header-section">
        <div class="app-logo">
          <div class="logo-container">
            <q-icon name="wallet" size="24px" color="white" />
          </div>
          <span class="logo-text">Logoipsum</span>
        </div>
        <h1 class="app-title">Create an Account</h1>
        <div class="login-link">
          <span class="have-account">Already have an account?</span>
          <router-link to="/login" class="sign-in">Sign In</router-link>
        </div>
      </div>

      <!-- Input section -->
      <div class="form-container">
        <form @submit.prevent="handleSubmit" class="register-form">
          <!-- First Name field -->
          <div class="input-field">
            <label class="field-label">First Name</label>
            <q-input
              v-model="firstName"
              filled
              type="text"
              class="custom-input"
              bg-color="white"
              dense
            />
          </div>

          <!-- Last Name field -->
          <div class="input-field">
            <label class="field-label">Last Name</label>
            <q-input
              v-model="lastName"
              filled
              type="text"
              class="custom-input"
              bg-color="white"
              dense
            />
          </div>

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

          <!-- Birth Date field -->
          <div class="input-field">
            <label class="field-label">Birth Date</label>
            <q-input
              v-model="birthDate"
              filled
              type="date"
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

          <!-- Confirm Password field -->
          <div class="input-field">
            <label class="field-label">Confirm Password</label>
            <q-input
              v-model="passwordConfirm"
              filled
              :type="showConfirmPassword ? 'text' : 'password'"
              class="custom-input"
              bg-color="white"
              dense
            >
              <template v-slot:append>
                <q-icon
                  :name="showConfirmPassword ? 'visibility_off' : 'visibility'"
                  class="cursor-pointer"
                  color="grey"
                  @click="showConfirmPassword = !showConfirmPassword"
                />
              </template>
            </q-input>
          </div>

          <!-- Terms acceptance -->
          <div class="terms-acceptance">
            <q-checkbox v-model="acceptTerms" color="grey" size="xs" dense />
            <span
              >I agree to the <span class="terms-link">Terms of Service</span> and
              <span class="terms-link">Data Processing Agreement</span></span
            >
          </div>

          <!-- Register button -->
          <q-btn
            type="submit"
            color="primary"
            class="register-btn"
            :loading="loading"
            no-caps
            unelevated
          >
            Create Account
          </q-btn>

          <!-- Divider -->
          <div class="divider">
            <div class="line"></div>
            <span class="divider-text">Or sign up with</span>
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
    </div>
  </q-page>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useQuasar } from 'quasar';
import { supabase } from 'src/boot/supabase';

const $q = useQuasar();
const router = useRouter();

const firstName = ref('');
const lastName = ref('');
const email = ref('');
const birthDate = ref('');
const password = ref('');
const passwordConfirm = ref('');
const acceptTerms = ref(false);
const showPassword = ref(false);
const showConfirmPassword = ref(false);
const loading = ref(false);

const handleSubmit = async () => {
  // Validate form fields
  if (
    !firstName.value ||
    !lastName.value ||
    !email.value ||
    !birthDate.value ||
    !password.value ||
    !passwordConfirm.value
  ) {
    $q.notify({
      type: 'negative',
      message: 'Please fill in all required fields',
    });
    return;
  }

  if (password.value !== passwordConfirm.value) {
    $q.notify({
      type: 'negative',
      message: 'Passwords do not match',
    });
    return;
  }

  if (!acceptTerms.value) {
    $q.notify({
      type: 'negative',
      message: 'You must accept the terms of service',
    });
    return;
  }

  try {
    loading.value = true;

    const { error } = await supabase.auth.signUp({
      email: email.value,
      password: password.value,
      options: {
        data: {
          first_name: firstName.value,
          last_name: lastName.value,
          birth_date: birthDate.value,
        },
      },
    });

    if (error) throw error;

    $q.notify({
      type: 'positive',
      message: 'Registration successful! Check your email to confirm your account.',
    });

    // Redirect to login page
    await router.push('/login');
  } catch (error: unknown) {
    const errorMessage =
      error instanceof Error ? error.message : 'An error occurred during registration';
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
.register-page {
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

.login-link {
  display: flex;
  align-items: center;
  gap: 6px;
  position: relative;
  z-index: 1;
}

.have-account {
  color: rgba(255, 255, 255, 0.7);
  font-size: 14px;
  font-weight: 400;
}

.sign-in {
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

.register-form {
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

.terms-acceptance {
  display: flex;
  align-items: flex-start;
  gap: 8px;
  margin-bottom: 24px;
}

.terms-acceptance span {
  color: #6c7278;
  font-size: 12px;
  font-weight: 500;
  line-height: 1.4;
}

.terms-link {
  color: #1a1c1e;
  text-decoration: none;
  font-weight: 600;
}

/* Button styles */
.register-btn {
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
</style>
