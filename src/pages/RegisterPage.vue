<template>
  <q-page class="bg-white column items-center">
    <div class="full-width column">
      <!-- Head section -->
      <div class="bg-animated column q-pt-xl q-pb-lg q-px-md relative-position">
        <div class="wave"></div>
        <div class="wave"></div>
        <div class="wave"></div>
        <div class="row items-center q-mb-md relative-position" style="z-index: 1">
          <div
            class="bg-positive q-mr-sm flex items-center justify-center"
            style="width: 32px; height: 32px; border-radius: 8px"
          >
            <q-icon name="wallet" size="24px" color="white" />
          </div>
          <span class="text-h6 text-white text-weight-bold">Logoipsum</span>
        </div>
        <h1
          class="text-h4 text-white text-weight-bold q-my-none q-mb-sm relative-position"
          style="z-index: 1"
        >
          Create an Account
        </h1>
        <div class="row items-center q-gutter-xs relative-position" style="z-index: 1">
          <span class="text-white-7 text-body2">Already have an account?</span>
          <router-link to="/login" class="text-positive text-weight-bold text-body2 no-decoration"
            >Sign In</router-link
          >
        </div>
      </div>

      <!-- Input section -->
      <div class="q-pa-md q-mb-md full-width">
        <form @submit.prevent="handleSubmit" class="full-width">
          <!-- First Name field -->
          <div class="q-mb-md">
            <label class="text-caption text-grey-7 text-weight-medium block q-mb-xs"
              >First Name</label
            >
            <q-input
              v-model="firstName"
              outlined
              type="text"
              class="custom-input"
              color="positive"
              bg-color="white"
              dense
              :error="!!errors.firstName"
              :error-message="errors.firstName"
            />
          </div>

          <!-- Last Name field -->
          <div class="q-mb-md">
            <label class="text-caption text-grey-7 text-weight-medium block q-mb-xs"
              >Last Name</label
            >
            <q-input
              v-model="lastName"
              outlined
              type="text"
              class="custom-input"
              color="positive"
              bg-color="white"
              dense
              :error="!!errors.lastName"
              :error-message="errors.lastName"
            />
          </div>

          <!-- Email field -->
          <div class="q-mb-md">
            <label class="text-caption text-grey-7 text-weight-medium block q-mb-xs">Email</label>
            <q-input
              v-model="email"
              outlined
              type="email"
              class="custom-input"
              color="positive"
              bg-color="white"
              dense
              :error="!!errors.email"
              :error-message="errors.email"
            />
          </div>

          <!-- Password field -->
          <div class="q-mb-md">
            <label class="text-caption text-grey-7 text-weight-medium block q-mb-xs"
              >Password</label
            >
            <q-input
              v-model="password"
              outlined
              :type="showPassword ? 'text' : 'password'"
              class="custom-input"
              color="positive"
              bg-color="white"
              dense
              :error="!!errors.password"
              :error-message="errors.password"
            >
              <template v-slot:append>
                <q-icon
                  :name="showPassword ? 'visibility_off' : 'visibility'"
                  class="q-pt-sm cursor-pointer"
                  color="grey"
                  @click="showPassword = !showPassword"
                />
              </template>
            </q-input>
          </div>

          <!-- Confirm Password field -->
          <div class="q-mb-md">
            <label class="text-caption text-grey-7 text-weight-medium block q-mb-xs"
              >Confirm Password</label
            >
            <q-input
              v-model="passwordConfirm"
              outlined
              :type="showConfirmPassword ? 'text' : 'password'"
              class="custom-input"
              color="positive"
              bg-color="white"
              dense
              :error="!!errors.passwordConfirm"
              :error-message="errors.passwordConfirm"
            >
              <template v-slot:append>
                <q-icon
                  :name="showConfirmPassword ? 'visibility_off' : 'visibility'"
                  class="q-pt-sm cursor-pointer"
                  color="grey"
                  @click="showConfirmPassword = !showConfirmPassword"
                />
              </template>
            </q-input>
          </div>

          <!-- Household ID field (optional) -->
          <div class="q-mb-md">
            <label class="text-caption text-grey-7 text-weight-medium block q-mb-xs"
              >Household ID (Optional)</label
            >
            <q-input
              v-model="householdId"
              outlined
              type="text"
              class="custom-input"
              color="positive"
              bg-color="white"
              dense
              placeholder="Leave empty to create a new household"
              :error="!!errors.householdId"
              :error-message="errors.householdId"
            />
          </div>

          <!-- Terms acceptance -->
          <div class="row no-wrap items-start q-gutter-x-sm q-mb-md">
            <q-checkbox
              v-model="acceptTerms"
              color="positive"
              size="xs"
              dense
              :error="!!errors.acceptTerms"
            />
            <span class="text-caption text-grey-7 text-weight-medium" style="line-height: 1.4">
              I agree to the
              <span class="text-dark text-weight-bold no-decoration">Terms of Service</span> and
              <span class="text-dark text-weight-bold no-decoration"
                >Data Processing Agreement</span
              >
            </span>
          </div>
          <div v-if="errors.acceptTerms" class="text-negative text-caption q-mb-md q-mt-xs">
            {{ errors.acceptTerms }}
          </div>

          <!-- Register button -->
          <q-btn
            type="submit"
            color="positive"
            class="full-width q-py-sm q-mb-lg rounded-borders"
            style="font-size: 14px; height: 46px"
            :loading="loading"
            no-caps
            unelevated
          >
            Create Account
          </q-btn>

          <!-- Divider -->
          <div class="row items-center q-mb-md">
            <div class="col bg-grey-3" style="height: 1px"></div>
            <span class="q-mx-md text-caption text-grey-7">Or sign up with</span>
            <div class="col bg-grey-3" style="height: 1px"></div>
          </div>

          <!-- Social buttons -->
          <div class="row q-col-gutter-md">
            <div class="col-6">
              <q-btn
                outline
                class="full-width q-py-sm rounded-borders"
                style="height: 46px"
                no-caps
              >
                <img
                  src="~assets/images/icons/google.svg"
                  class="q-mr-sm"
                  style="width: 18px; height: 18px"
                  alt="Google icon"
                />
                Google
              </q-btn>
            </div>
            <div class="col-6">
              <q-btn
                outline
                class="full-width q-py-sm rounded-borders"
                style="height: 46px"
                no-caps
              >
                <img
                  src="~assets/images/icons/facebook.svg"
                  class="q-mr-sm"
                  style="width: 18px; height: 18px"
                  alt="Facebook icon"
                />
                Facebook
              </q-btn>
            </div>
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

const { notify } = useQuasar();
const router = useRouter();
const authStore = useAuthStore();
const householdStore = useHouseholdStore();

const firstName = ref('');
const lastName = ref('');
const email = ref('');
const password = ref('');
const passwordConfirm = ref('');
const householdId = ref('');
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
    householdId: z.string().optional(),
    acceptTerms: z.literal(true, {
      errorMap: () => ({ message: 'You must accept the terms of service' }),
    }),
  })
  .refine((data) => data.password === data.passwordConfirm, {
    message: 'Passwords do not match',
    path: ['passwordConfirm'],
  })
  .refine(
    (data) => {
      if (!data.householdId) return true;
      return /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(
        data.householdId,
      );
    },
    {
      message: 'Invalid household ID format',
      path: ['householdId'],
    },
  );

const validate = () => {
  const result = schema.safeParse({
    firstName: firstName.value,
    lastName: lastName.value,
    email: email.value,
    password: password.value,
    passwordConfirm: passwordConfirm.value,
    householdId: householdId.value,
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

const checkHouseholdExists = async (householdId: string): Promise<boolean> => {
  try {
    const { data, error } = await householdStore.fetchHouseholdById(householdId);
    if (error) throw error;
    return !!data;
  } catch (error) {
    console.error('Error checking household:', error);
    return false;
  }
};

const handleSubmit = async () => {
  // Validate form using Zod
  const isValid = validate();

  if (!isValid) {
    return;
  }

  try {
    loading.value = true;

    // If household ID is provided, verify it exists
    if (householdId.value) {
      const householdExists = await checkHouseholdExists(householdId.value);
      if (!householdExists) {
        notify({
          type: 'negative',
          textColor: 'white',
          message:
            'The household ID you entered does not exist. Please check the ID or leave it empty to create a new household.',
        });
        return;
      }
    }

    // Register the user using the auth store
    const { error } = await authStore.register(
      email.value,
      password.value,
      {
        first_name: firstName.value,
        last_name: lastName.value,
      },
      householdId.value || undefined,
    );

    if (error) throw error as Error;

    // Sign in with the newly created credentials
    const { error: loginError } = await authStore.login(email.value, password.value);

    if (loginError) throw loginError as Error;

    // No need to manually create household - it's now handled by database trigger

    // Redirect to dashboard
    await router.push('/');
  } catch (error: unknown) {
    const errorMessage =
      error instanceof Error ? error.message : 'An error occurred during registration';
    notify({
      type: 'negative',
      textColor: 'white',
      message: errorMessage,
    });
  } finally {
    loading.value = false;
  }
};
</script>

<style lang="scss" scoped>
// Import authentication styles
@import 'src/css/auth.scss';
</style>
