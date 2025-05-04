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
            $t('pages.login.logoPlaceholder')
          }}</span>
        </div>
        <h1
          class="text-h4 text-white text-weight-bold q-my-none q-mb-sm relative-position"
          style="z-index: 1"
        >
          {{ $t('pages.login.title') }}
        </h1>
        <div class="row items-center q-gutter-xs relative-position" style="z-index: 1">
          <span class="text-white-7 text-body2">{{ $t('pages.login.noAccountPrompt') }}</span>
          <router-link
            to="/register"
            class="text-positive text-weight-bold text-body2 no-decoration"
          >
            {{ $t('pages.login.signUpLink') }}
          </router-link>
        </div>
      </div>

      <!-- Input section -->
      <div class="q-pa-md q-mb-md full-width">
        <form @submit.prevent="handleSubmit" class="full-width">
          <!-- Email field -->
          <div class="q-mb-md">
            <label class="text-caption text-grey-7 text-weight-medium block q-mb-xs">
              {{ $t('pages.login.emailLabel') }}
            </label>
            <q-input
              v-model="email"
              outlined
              type="email"
              class="custom-input"
              color="positive"
              bg-color="white"
              dense
            />
          </div>

          <!-- Password field -->
          <div class="q-mb-md">
            <label class="text-caption text-grey-7 text-weight-medium block q-mb-xs">
              {{ $t('pages.login.passwordLabel') }}
            </label>
            <q-input
              v-model="password"
              outlined
              :type="showPassword ? 'text' : 'password'"
              class="custom-input"
              color="positive"
              bg-color="white"
              dense
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

          <!-- Remember me / Forgot password -->
          <div class="row justify-between items-center q-mb-lg">
            <div class="row items-center q-gutter-x-xs">
              <q-checkbox v-model="rememberMe" color="grey" size="xs" dense />
              <span class="text-caption text-grey-7 text-weight-medium">
                {{ $t('pages.login.rememberMeLabel') }}
              </span>
            </div>
            <router-link
              to="/forgot-password"
              class="text-positive text-caption text-weight-bold no-decoration"
            >
              {{ $t('pages.login.forgotPasswordLink') }}
            </router-link>
          </div>

          <!-- Login button -->
          <q-btn
            type="submit"
            color="positive"
            class="full-width q-py-sm q-mb-lg rounded-borders"
            style="font-size: 14px; height: 46px"
            :loading="loading"
            no-caps
            unelevated
          >
            {{ $t('pages.login.loginButton') }}
          </q-btn>

          <!-- Divider -->
          <div class="row items-center q-mb-md">
            <div class="col bg-grey-3" style="height: 1px"></div>
            <span class="q-mx-md text-caption text-grey-7">{{
              $t('pages.login.orLoginWith')
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
                {{ $t('pages.login.googleButton') }}
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
                {{ $t('pages.login.facebookButton') }}
              </q-btn>
            </div>
          </div>
        </form>
      </div>

      <!-- Terms text -->
      <p class="text-center text-caption text-grey-7 q-mt-sm q-px-md">
        {{ $t('pages.login.termsPrefix') }}
        <span class="text-dark no-decoration">{{ $t('pages.login.termsOfServiceLink') }}</span> and
        <span class="text-dark no-decoration">{{ $t('pages.login.dataProcessingLink') }}</span>
      </p>
    </div>
  </q-page>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useQuasar } from 'quasar';
import { useI18n } from 'vue-i18n';
import { useAuthStore } from 'src/stores/auth-store';
import { useHouseholdStore } from 'src/stores/household-store';

const { notify } = useQuasar();
const router = useRouter();
const authStore = useAuthStore();
const householdStore = useHouseholdStore();
const { t } = useI18n();

const email = ref('');
const password = ref('');
const rememberMe = ref(false);
const showPassword = ref(false);
const loading = ref(false);

const handleSubmit = async () => {
  if (!email.value || !password.value) {
    notify({
      type: 'negative',
      textColor: 'white',
      message: t('pages.login.errorFillFields'),
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
    await router.push({ name: 'home' });
  } catch (error: unknown) {
    const errorMessage =
      error instanceof Error ? error.message : t('pages.login.errorLoginFallback');
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
