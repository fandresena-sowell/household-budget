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
          <span class="text-h6 text-white text-weight-bold">{{
            $t('pages.register.logoPlaceholder')
          }}</span>
        </div>
        <h1
          class="text-h4 text-white text-weight-bold q-my-none q-mb-sm relative-position"
          style="z-index: 1"
        >
          {{ $t('pages.register.title') }}
        </h1>
        <div class="row items-center q-gutter-xs relative-position" style="z-index: 1">
          <span class="text-white-7 text-body2">{{ $t('pages.register.hasAccountPrompt') }}</span>
          <router-link to="/login" class="text-positive text-weight-bold text-body2 no-decoration">
            {{ $t('pages.register.signInLink') }}
          </router-link>
        </div>
      </div>

      <!-- Input section -->
      <div class="q-pa-md q-mb-md full-width">
        <form @submit.prevent="handleSubmit" class="full-width">
          <!-- First Name field -->
          <div class="q-mb-md">
            <label class="text-caption text-grey-7 text-weight-medium block q-mb-xs">
              {{ $t('pages.register.firstNameLabel') }}
            </label>
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
            <label class="text-caption text-grey-7 text-weight-medium block q-mb-xs">
              {{ $t('pages.register.lastNameLabel') }}
            </label>
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
            <label class="text-caption text-grey-7 text-weight-medium block q-mb-xs">
              {{ $t('pages.register.emailLabel') }}
            </label>
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
            <label class="text-caption text-grey-7 text-weight-medium block q-mb-xs">
              {{ $t('pages.register.passwordLabel') }}
            </label>
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
            <label class="text-caption text-grey-7 text-weight-medium block q-mb-xs">
              {{ $t('pages.register.confirmPasswordLabel') }}
            </label>
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
            <label class="text-caption text-grey-7 text-weight-medium block q-mb-xs">
              {{ $t('pages.register.householdIdLabel') }}
            </label>
            <q-input
              v-model="householdId"
              outlined
              type="text"
              class="custom-input"
              color="positive"
              bg-color="white"
              dense
              :placeholder="t('pages.register.householdIdPlaceholder')"
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
              {{ $t('pages.register.termsAgreementPrefix') }}
              <span class="text-dark text-weight-bold no-decoration">{{
                $t('pages.register.termsOfServiceLink')
              }}</span>
              and
              <span class="text-dark text-weight-bold no-decoration">
                {{ $t('pages.register.dataProcessingLink') }}
              </span>
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
            {{ $t('pages.register.createAccountButton') }}
          </q-btn>

          <!-- Divider -->
          <div class="row items-center q-mb-md">
            <div class="col bg-grey-3" style="height: 1px"></div>
            <span class="q-mx-md text-caption text-grey-7">{{
              $t('pages.register.orSignUpWith')
            }}</span>
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
                {{ $t('pages.register.googleButton') }}
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
                {{ $t('pages.register.facebookButton') }}
              </q-btn>
            </div>
          </div>
        </form>
      </div>
    </div>
  </q-page>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue';
import { useRouter } from 'vue-router';
import { useQuasar } from 'quasar';
import { useI18n } from 'vue-i18n';
import { useAuthStore } from 'src/stores/auth-store';
import { useHouseholdStore } from 'src/stores/household-store';
import { z } from 'zod';

const { notify } = useQuasar();
const router = useRouter();
const authStore = useAuthStore();
const householdStore = useHouseholdStore();
const { t } = useI18n();

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

const errors = reactive({
  firstName: '',
  lastName: '',
  email: '',
  password: '',
  passwordConfirm: '',
  householdId: '',
  acceptTerms: '',
});

const registrationSchema = z
  .object({
    firstName: z
      .string()
      .min(1, { message: t('validation.required', { field: t('pages.register.firstNameLabel') }) }),
    lastName: z
      .string()
      .min(1, { message: t('validation.required', { field: t('pages.register.lastNameLabel') }) }),
    email: z.string().email({ message: t('validation.invalidEmail') }),
    password: z.string().min(6, {
      message: t('validation.minLength', { field: t('pages.register.passwordLabel'), min: 6 }),
    }),
    passwordConfirm: z.string(),
    householdId: z
      .string()
      .uuid({ message: t('validation.invalidUuid') })
      .optional()
      .or(z.literal('')),
    acceptTerms: z.literal(true, { message: t('pages.register.errorTermsRequired') }),
  })
  .refine((data) => data.password === data.passwordConfirm, {
    message: t('validation.passwordsDoNotMatch'),
    path: ['passwordConfirm'],
  });

function resetErrors() {
  Object.keys(errors).forEach((key) => (errors[key as keyof typeof errors] = ''));
}

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
  resetErrors();

  const validationResult = registrationSchema.safeParse({
    firstName: firstName.value,
    lastName: lastName.value,
    email: email.value,
    password: password.value,
    passwordConfirm: passwordConfirm.value,
    householdId: householdId.value,
    acceptTerms: acceptTerms.value,
  });

  if (!validationResult.success) {
    const formattedErrors = validationResult.error.format();

    (Object.keys(errors) as Array<keyof typeof errors>).forEach((key) => {
      const fieldErrors = formattedErrors[key];
      if (fieldErrors && fieldErrors._errors.length > 0) {
        // Assign the first error message, defaulting to empty string if undefined
        errors[key] = fieldErrors._errors[0] ?? '';
      }
    });

    // Handle potential refine/superRefine errors (like password mismatch)
    // These are typically in the root _errors array
    if (formattedErrors._errors.length > 0) {
      // Find the specific refine error related to a field if possible
      const passwordMismatchError = validationResult.error.errors.find(
        (err) => err.path.includes('passwordConfirm') && err.code === 'custom',
      );
      if (passwordMismatchError) {
        // Assign to the relevant field in our errors state
        errors.passwordConfirm = passwordMismatchError.message;
      }
      // Add checks for other potential root-level errors if needed
    }

    return;
  }

  const formData = validationResult.data;

  try {
    loading.value = true;

    if (formData.householdId) {
      const householdExists = await checkHouseholdExists(formData.householdId);
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

    const { error } = await authStore.register(
      formData.email,
      formData.password,
      {
        first_name: formData.firstName,
        last_name: formData.lastName,
      },
      householdId.value || undefined,
    );

    if (error) throw error as Error;

    // Sign in with the newly created credentials
    const { error: loginError } = await authStore.login(email.value, password.value);

    if (loginError) throw loginError as Error;

    // No need to manually create household - it's now handled by database trigger

    // Redirect to dashboard
    await router.push({ name: 'home' });
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
