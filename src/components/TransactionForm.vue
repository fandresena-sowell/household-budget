<template>
  <div class="transaction-form">
    <q-form @submit="onSubmit" class="full-height bg-white text-dark">
      <!-- Header with form title and close button -->
      <q-toolbar>
        <q-btn
          flat
          dense
          no-caps
          color="positive"
          label="Cancel"
          class="text-weight-medium"
          @click="$emit('cancel')"
        />
        <q-toolbar-title class="text-h6 text-center text-weight-medium text-dark">{{
          formTitle
        }}</q-toolbar-title>
        <q-btn
          flat
          dense
          no-caps
          color="positive"
          label="Done"
          class="text-weight-medium"
          type="submit"
          :loading="isSubmitting"
        />
      </q-toolbar>
      <q-separator />

      <!-- Amount Input with large display at the top -->
      <div class="q-py-xl q-px-md text-center">
        <q-input
          v-model.number="formData.amount"
          type="number"
          step="0.1"
          borderless
          :input-class="amountInputClass"
          class="text-h3 text-weight-bold"
          :rules="[
            (val) => (val !== null && val !== '' && !isNaN(val)) || 'Amount is required',
            (val) => val > 0 || 'Amount must be positive',
          ]"
          hide-bottom-space
        >
          <template v-slot:prepend>
            <span class="text-h3" :class="amountInputClass">
              {{ selectedCategoryType === 'expense' ? '-$' : '$' }}
            </span>
          </template>
        </q-input>
      </div>

      <!-- Main form content with cells similar to Figma design -->
      <div class="form-cells q-px-md column q-gutter-y-md">
        <!-- Category Selection -->
        <div class="form-cell row items-center">
          <div class="form-cell-label">Category</div>
          <q-select
            v-model="formData.category_id"
            :options="categoryOptions"
            option-value="id"
            option-label="name"
            bg-color="white"
            color="grey-6"
            borderless
            dense
            emit-value
            map-options
            :rules="[(val) => !!val || 'Category is required']"
            class="col"
          >
            <template v-slot:option="scope">
              <q-item v-bind="scope.itemProps">
                <q-item-section>
                  <q-item-label>{{ scope.opt.name }}</q-item-label>
                </q-item-section>
                <q-item-section side>
                  <q-badge
                    :color="scope.opt.type === 'income' ? 'positive' : 'negative'"
                    text-color="white"
                    >{{ scope.opt.type }}
                  </q-badge>
                </q-item-section>
              </q-item>
            </template>
            <template v-slot:append>
              <q-icon name="chevron_right" color="grey-6" />
            </template>
          </q-select>
        </div>

        <!-- Date -->
        <div class="form-cell row items-center">
          <div class="form-cell-label">Date</div>
          <q-input
            class="col date-input"
            v-model="formData.transaction_date"
            borderless
            dense
            bg-color="white"
            :rules="[(val) => !!val || 'Date is required']"
          >
            <template v-slot:append>
              <q-icon name="event" color="grey-6" class="cursor-pointer">
                <q-popup-proxy cover transition-show="scale" transition-hide="scale">
                  <q-date v-model="formData.transaction_date" mask="YYYY-MM-DD" color="positive">
                    <div class="row items-center justify-end">
                      <q-btn v-close-popup label="Close" color="positive" flat />
                    </div>
                  </q-date>
                </q-popup-proxy>
              </q-icon>
            </template>
          </q-input>
        </div>

        <!-- Account Selection -->
        <div class="form-cell row items-center">
          <div class="form-cell-label">Account</div>
          <q-select
            v-model="formData.account_id"
            :options="accountOptions"
            borderless
            dense
            bg-color="white"
            emit-value
            map-options
            :rules="[(val) => !!val || 'Account is required']"
            :readonly="!!transaction && isEdit"
            class="col"
          >
            <template v-slot:append>
              <q-icon name="chevron_right" color="grey-6" />
            </template>
          </q-select>
        </div>

        <!-- Status Toggle -->
        <div class="form-cell row items-center justify-between">
          <div class="form-cell-label">Status</div>
          <div class="q-px-md q-py-sm">
            <q-toggle
              v-model="isCompleted"
              :color="accentColor"
              :label="isCompleted ? 'Completed' : 'Pending'"
              @update:model-value="updateStatus"
            />
          </div>
        </div>

        <!-- Description/Notes -->
        <div class="form-cell">
          <div class="form-cell-label">Notes</div>
          <q-input
            v-model="formData.description"
            borderless
            bg-color="white"
            type="textarea"
            dense
            placeholder="Optional"
            hide-bottom-space
            style="height: 155px; max-height: 155px"
            input-style="height: 150px; max-height: 150px"
          />
        </div>
      </div>
    </q-form>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue';
import { useAccountsStore } from 'src/stores/accounts-store';
import { useCategoriesStore } from 'src/stores/categories-store';
import { useHouseholdStore } from 'src/stores/household-store';
import { useAuthStore } from 'src/stores/auth-store';
import type { Transaction } from 'src/stores/transactions-store';

// Props
interface Props {
  transaction?: Transaction | null;
  isEdit?: boolean;
  accountId?: string;
  submitButtonText?: string;
  cancelButtonText?: string;
}
const props = withDefaults(defineProps<Props>(), {
  isEdit: false,
  submitButtonText: 'Save',
  cancelButtonText: 'Cancel',
});

// Emits
const emit = defineEmits<{
  (e: 'submit', data: any): void;
  (e: 'cancel'): void;
  (e: 'delete', transaction: Transaction): void;
}>();

// Stores
const accountsStore = useAccountsStore();
const categoriesStore = useCategoriesStore();
const householdStore = useHouseholdStore();
const authStore = useAuthStore();

// UI State
const isSubmitting = ref(false);
const isCompleted = ref(true);

// Form data with defaults
const formData = reactive({
  account_id: props.accountId || props.transaction?.account_id || '',
  category_id: props.transaction?.category_id || null,
  amount: props.transaction ? Math.abs(props.transaction.amount) : 0,
  description: props.transaction?.description || '',
  transaction_date:
    props.transaction?.transaction_date?.slice(0, 10) || new Date().toISOString().slice(0, 10),
  status: props.transaction?.status || 'completed',
  household_id: householdStore.householdId || '',
  created_by_user_id: authStore.userId || '',
});

// Form title
const formTitle = computed(() => {
  if (props.isEdit) {
    return 'Edit Transaction';
  }
  return selectedCategoryType.value === 'expense' ? 'Expense' : 'Income';
});

// Theme colors based on category type
const accentColor = computed(() => {
  return isCompleted.value ? 'positive' : 'grey-6';
});

const amountInputClass = computed(() => {
  return selectedCategoryType.value === 'expense'
    ? 'text-right text-negative'
    : 'text-right text-positive';
});

// Initialize isCompleted toggle based on status
onMounted(() => {
  isCompleted.value = formData.status === 'completed';
});

// Watch for changes in isCompleted to update formData.status
function updateStatus(val: boolean) {
  formData.status = val ? 'completed' : 'pending';
}

// Category type (income/expense) based on selected category
const selectedCategoryType = computed(() => {
  if (!formData.category_id) return null;
  const category = categoriesStore.categories.find((c) => c.id === formData.category_id);
  return category?.type || null;
});

// Options for form selects
const accountOptions = computed(() => {
  return accountsStore.accounts.map((account) => ({
    label: account.name,
    value: account.id,
  }));
});

const categoryOptions = computed(() => {
  return categoriesStore.categories.map((category) => ({
    name: category.name,
    id: category.id,
    type: category.type,
  }));
});

// Handle form submission
function onSubmit() {
  isSubmitting.value = true;

  try {
    // Determine if the amount should be positive or negative based on category type
    let finalAmount = formData.amount;
    if (selectedCategoryType.value === 'expense') {
      finalAmount = -Math.abs(finalAmount);
    } else if (selectedCategoryType.value === 'income') {
      finalAmount = Math.abs(finalAmount);
    }

    // Prepare data for submission
    const submitData = {
      ...formData,
      amount: finalAmount,
    };

    emit('submit', submitData);
  } finally {
    isSubmitting.value = false;
  }
}

// Load required data
onMounted(async () => {
  if (accountsStore.accounts.length === 0) {
    await accountsStore.fetchAccounts();
  }

  if (categoriesStore.categories.length === 0) {
    await categoriesStore.fetchCategories();
  }

  // If it's an edit and we have a transaction, set the form data
  if (props.isEdit && props.transaction) {
    formData.account_id = props.transaction.account_id;
    formData.category_id = props.transaction.category_id;
    formData.amount = Math.abs(props.transaction.amount || 0);
    formData.description = props.transaction.description || '';
    formData.transaction_date = props.transaction.transaction_date.slice(0, 10);
    formData.status = props.transaction.status;
    isCompleted.value = formData.status === 'completed';
  }
});
</script>

<style lang="scss" scoped>
.form-header {
  z-index: 10;
}

.amount-input {
  border-radius: 12px;
  max-width: 90%;
  margin: 0 auto;

  :deep(.q-field__control) {
    height: 70px;
  }

  :deep(.q-field__native, .q-field__prefix) {
    font-weight: 600;
    font-size: 2rem;
  }
}

.form-cells {
  .form-cell {
    border-bottom: 1px solid rgba(0, 0, 0, 0.1);

    .form-cell-label {
      font-size: 15px;
      font-weight: 500;
      color: $dark;
      opacity: 0.7;
    }

    :deep(.q-field__control) {
      height: 36px;
    }

    :deep(.q-field--with-bottom) {
      padding-bottom: 0;
    }
  }
}

.q-select,
.q-input.date-input {
  :deep(.q-field__native) {
    color: $positive;
    font-size: 16px;
    font-weight: 600;
    display: flex;
    justify-content: flex-end;
    text-align: right;
  }
}

.q-select {
  :deep(.q-field__append:last-child) {
    display: none;
  }
}

.form-footer {
  border-top: 1px solid rgba(0, 0, 0, 0.1);

  .separator {
    width: 1px;
    height: 30px;
    background-color: rgba(0, 0, 0, 0.1);
  }
}

.q-toggle {
  :deep(.q-toggle__label) {
    width: 68px;
    text-align: right;
  }
}
</style>
