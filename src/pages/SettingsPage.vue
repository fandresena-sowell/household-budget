<template>
  <q-page class="bg-white text-dark">
    <q-form @submit="saveSettings">
      <!-- Header -->
      <q-toolbar class="bg-positive text-white">
        <q-btn
          flat
          dense
          no-caps
          color="white"
          :label="t('pages.settings.cancelButton')"
          class="text-weight-medium"
          @click="cancel"
        />
        <q-toolbar-title class="text-h6 text-center text-weight-medium text-white">
          {{ t('pages.settings.title') }}
        </q-toolbar-title>
        <q-btn
          flat
          dense
          no-caps
          color="white"
          :label="t('pages.settings.saveButton')"
          class="text-weight-medium"
          type="submit"
          :loading="isSaving"
        />
      </q-toolbar>
      <q-separator />

      <!-- Form Content -->
      <div class="form-cells q-px-md column q-gutter-y-md q-mt-md">
        <!-- Categories Link -->
        <div class="form-cell row items-center" @click="goToCategories" clickable v-ripple>
          <div class="form-cell-label">{{ t('pages.settings.categoriesLabel') }}</div>
          <q-space />
          <q-icon name="chevron_right" color="grey-6" />
        </div>

        <!-- Currency Symbol -->
        <div class="form-cell row items-center">
          <div class="form-cell-label">{{ t('pages.settings.currencySymbolLabel') }}</div>
          <q-input
            v-model="settingsData.currency_symbol"
            borderless
            dense
            bg-color="white"
            class="col styled-input"
            :rules="[(val) => !!val || t('pages.settings.validationSymbolRequired')]"
            hide-bottom-space
          />
        </div>

        <!-- Number Format -->
        <div class="form-cell row items-center">
          <div class="form-cell-label">{{ t('pages.settings.numberFormatLabel') }}</div>
          <q-select
            v-model="settingsData.number_format"
            :options="numberFormatOptions"
            borderless
            dense
            bg-color="white"
            emit-value
            map-options
            class="col styled-select"
            :rules="[(val) => !!val || t('pages.settings.validationNumberFormatRequired')]"
            hide-bottom-space
          >
            <template v-slot:append>
              <q-icon name="chevron_right" color="grey-6" />
            </template>
          </q-select>
        </div>

        <!-- Symbol Position -->
        <div class="form-cell row items-center">
          <div class="form-cell-label">{{ t('pages.settings.symbolPositionLabel') }}</div>
          <q-select
            v-model="settingsData.symbol_position"
            :options="symbolPositionOptions"
            borderless
            dense
            bg-color="white"
            emit-value
            map-options
            class="col styled-select"
            :rules="[(val) => !!val || t('pages.settings.validationSymbolPositionRequired')]"
            hide-bottom-space
          >
            <template v-slot:append>
              <q-icon name="chevron_right" color="grey-6" />
            </template>
          </q-select>
        </div>
      </div>
    </q-form>
  </q-page>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue';
import { useI18n } from 'vue-i18n';
import { useRouter } from 'vue-router';
import { useQuasar } from 'quasar';
import { useHouseholdStore } from 'src/stores/household-store';

// Adjusted type definition to match database schema expectations ('comma' | 'plain')
interface SettingsData {
  currency_symbol: string;
  number_format: 'comma' | 'plain';
  symbol_position: 'before' | 'after';
}

const { t } = useI18n();
const router = useRouter();
const $q = useQuasar();
const householdStore = useHouseholdStore();

const isSaving = ref(false);

// Form data, initialized with store defaults or fallbacks
const settingsData = reactive<SettingsData>({
  currency_symbol: householdStore.currencySymbol ?? '$',
  number_format: householdStore.numberFormat ?? 'comma',
  symbol_position: (householdStore.symbolPosition as 'before' | 'after') ?? 'before',
});

// Options for selects
const numberFormatOptions = [
  { label: t('pages.settings.numberFormatComma'), value: 'comma' },
  { label: t('pages.settings.numberFormatPlain'), value: 'plain' },
];

const symbolPositionOptions = [
  { label: t('pages.settings.symbolPositionBefore'), value: 'before' },
  { label: t('pages.settings.symbolPositionAfter'), value: 'after' },
  { label: t('pages.settings.symbolPositionNone'), value: 'none' },
];

// Initialize form data when component mounts and store data is available
onMounted(() => {
  // Use currentHousehold from the store
  if (householdStore.currentHousehold) {
    settingsData.currency_symbol = householdStore.currentHousehold.currency_symbol;
    // Align with 'comma' | 'plain' type
    settingsData.number_format = householdStore.currentHousehold.number_format;
    settingsData.symbol_position = householdStore.currentHousehold.symbol_position as
      | 'before'
      | 'after';
  } else {
    // Optionally watch for household data to load if it might not be ready
    // Watcher logic could be added here if needed
    console.warn('Household data not available on mount for SettingsPage.');
  }
});

// --- Methods ---

function cancel() {
  router.push('/'); // Navigate back to home/dashboard
}

function goToCategories() {
  router.push({ name: 'categories' });
}

async function saveSettings() {
  isSaving.value = true;
  try {
    if (!householdStore.householdId) {
      throw new Error('Household ID is missing.');
    }
    // Call the newly added updateHousehold action
    await householdStore.updateHousehold(householdStore.householdId, {
      currency_symbol: settingsData.currency_symbol,
      number_format: settingsData.number_format,
      symbol_position: settingsData.symbol_position,
    });
    $q.notify({
      message: t('pages.settings.saveSuccess'),
      icon: 'check_circle',
    });
    router.push('/'); // Navigate back after successful save
  } catch (error) {
    console.error('Error saving settings:', error);
    $q.notify({
      color: 'negative',
      message: t('pages.settings.saveError'),
      icon: 'error',
    });
  } finally {
    isSaving.value = false;
  }
}
</script>

<style lang="scss" scoped>
// Styles adapted from TransactionForm.vue
.form-cells {
  .form-cell {
    border-bottom: 1px solid rgba(0, 0, 0, 0.1);
    min-height: 48px; // Ensure consistent height

    .form-cell-label {
      font-size: 15px;
      font-weight: 500;
      color: $dark;
      opacity: 0.7;
      flex-shrink: 0; // Prevent label from shrinking
      margin-right: 16px; // Add some space between label and input/select
      width: 130px; // Fixed width for labels to align inputs
    }

    :deep(.q-field__control) {
      height: 36px;
    }

    :deep(.q-field--with-bottom) {
      padding-bottom: 0;
    }

    // Make clickable rows look interactive
    &[clickable] {
      cursor: pointer;
      &:hover {
        background-color: rgba(0, 0, 0, 0.02);
      }
    }
  }
}

// Specific styling for inputs and selects in this form
.styled-select,
.styled-input {
  :deep(.q-field__native) {
    color: $positive;
    font-size: 16px;
    font-weight: 600;
    display: flex;
    justify-content: flex-end;
    text-align: right;
  }
}

// Hide the default dropdown arrow for styled selects, keep the chevron
.styled-select {
  :deep(.q-field__append:not(:last-child)) {
    display: none;
  }
}

// Ensure input text aligns right like selects
.styled-input {
  :deep(.q-field__native) {
    text-align: right;
  }
}
</style>
