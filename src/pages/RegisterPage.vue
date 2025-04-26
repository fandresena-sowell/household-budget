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
              :error="!!errors.firstName"
              :error-message="errors.firstName"
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
              :error="!!errors.lastName"
              :error-message="errors.lastName"
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
              :error="!!errors.email"
              :error-message="errors.email"
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
              :error="!!errors.password"
              :error-message="errors.password"
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
              :error="!!errors.passwordConfirm"
              :error-message="errors.passwordConfirm"
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
            <q-checkbox
              v-model="acceptTerms"
              color="grey"
              size="xs"
              dense
              :error="!!errors.acceptTerms"
            />
            <span
              >I agree to the <span class="terms-link">Terms of Service</span> and
              <span class="terms-link">Data Processing Agreement</span></span
            >
          </div>
          <div v-if="errors.acceptTerms" class="error-message">
            {{ errors.acceptTerms }}
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
import { useAuthStore } from 'src/stores/auth-store';
import { useHouseholdStore } from 'src/stores/household-store';
import { z } from 'zod';

const $q = useQuasar();
const router = useRouter();
const authStore = useAuthStore();
const householdStore = useHouseholdStore();

const firstName = ref('');
const lastName = ref('');
const email = ref('');
const password = ref('');
const passwordConfirm = ref('');
const acceptTerms = ref(false);
const showPassword = ref(false);
const showConfirmPassword = ref(false);
const loading = ref(false);
const errors = ref<Record<string, string>>({});

// Define the validation schema
const schema = z
  .object({
    firstName: z.string().min(1, 'First name is required'),
    lastName: z.string().min(1, 'Last name is required'),
    email: z.string().min(1, 'Email is required').email('Invalid email format'),
    password: z
      .string()
      .min(1, 'Password is required')
      .min(8, 'Password must be at least 8 characters'),
    passwordConfirm: z.string().min(1, 'Please confirm your password'),
    acceptTerms: z.literal(true, {
      errorMap: () => ({ message: 'You must accept the terms of service' }),
    }),
  })
  .refine((data) => data.password === data.passwordConfirm, {
    message: 'Passwords do not match',
    path: ['passwordConfirm'],
  });

const validate = () => {
  const result = schema.safeParse({
    firstName: firstName.value,
    lastName: lastName.value,
    email: email.value,
    password: password.value,
    passwordConfirm: passwordConfirm.value,
    acceptTerms: acceptTerms.value,
  });

  // Reset errors
  errors.value = {};

  if (!result.success) {
    // Format and set errors
    const formattedErrors = result.error.format();

    // Handle string errors
    Object.entries(formattedErrors).forEach(([key, value]) => {
      if (
        key !== '_errors' &&
        typeof value === 'object' &&
        '_errors' in value &&
        value._errors.length
      ) {
        errors.value[key] = value._errors[0] ?? '';
      }
    });

    return false;
  }

  return true;
};

const handleSubmit = async () => {
  // Validate form using Zod
  const isValid = validate();

  if (!isValid) {
    return;
  }

  try {
    loading.value = true;

    // Register the user using the auth store
    const { error } = await authStore.register(email.value, password.value, {
      first_name: firstName.value,
      last_name: lastName.value,
    });

    if (error) throw error as Error;

    // Sign in with the newly created credentials
    const { error: loginError } = await authStore.login(email.value, password.value);

    if (loginError) throw loginError as Error;

    // Create a default household for the user
    if (authStore.userId) {
      const { error: householdError } = await householdStore.ensureUserInHousehold(
        authStore.userId,
        firstName.value,
      );

      if (householdError) {
        console.error('Error ensuring user in household:', householdError);
        // Continue even if household process fails - we can retry later
      }
    }

    $q.notify({
      type: 'positive',
      message: 'Registration successful! Welcome to the app.',
    });

    // Redirect to dashboard
    await router.push('/');
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
  margin-bottom: 8px;
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

.error-message {
  color: #c10015;
  font-size: 12px;
  margin-bottom: 16px;
  margin-top: -4px;
}

/* Button styles */
.register-btn {
  width: 100%;
  height: 46px;
  border-radius: 8px;
  font-weight: 500;
  font-size: 14px;
  margin-bottom: 24px;
  margin-top: 8px;
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
