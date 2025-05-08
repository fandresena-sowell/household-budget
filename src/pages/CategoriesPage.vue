<template>
  <q-page class="text-black">
    <!-- Header with back button -->
    <q-header class="bg-positive">
      <q-toolbar>
        <q-btn flat round dense icon="arrow_back" class="q-mr-sm" @click="goBack" />
        <q-toolbar-title class="text-h6 text-center text-weight-medium" style="padding-left: 40px">
          {{ $t('pages.categories.title') }}
        </q-toolbar-title>
        <q-btn
          flat
          round
          dense
          icon="add_circle_outline"
          class="q-mr-sm"
          @click="openAddCategoryDialog"
        />
      </q-toolbar>
    </q-header>

    <div class="categories-page q-pa-md q-mt-xl">
      <!-- Loading state -->
      <div v-if="isLoading" class="q-pa-md flex flex-center">
        <q-spinner color="positive" size="3em" />
        <div class="q-ml-sm">{{ $t('pages.categories.loading') }}</div>
      </div>

      <template v-else>
        <!-- Income Categories -->
        <div class="q-mb-lg">
          <div class="text-subtitle1 text-positive q-mb-sm">
            <q-icon name="arrow_upward" /> {{ $t('pages.categories.incomeTitle') }}
          </div>
          <q-list bordered separator>
            <q-item v-for="category in incomeCategories" :key="category.id">
              <q-item-section avatar>
                <q-icon :name="category.icon" color="positive" size="sm" />
              </q-item-section>
              <q-item-section>
                <q-item-label>{{ category.name }}</q-item-label>
              </q-item-section>
              <q-item-section side>
                <div class="row items-center">
                  <q-btn
                    flat
                    round
                    color="positive"
                    icon="edit"
                    size="sm"
                    @click="openEditDialog(category)"
                  />
                  <q-btn
                    flat
                    round
                    color="negative"
                    icon="delete"
                    size="sm"
                    @click="confirmDelete(category)"
                  />
                </div>
              </q-item-section>
            </q-item>
            <q-item v-if="incomeCategories.length === 0">
              <q-item-section>
                <q-item-label class="text-grey">{{ $t('pages.categories.noIncome') }}</q-item-label>
              </q-item-section>
            </q-item>
          </q-list>
        </div>

        <!-- Expense Categories -->
        <div>
          <div class="text-subtitle1 text-negative q-mb-sm">
            <q-icon name="arrow_downward" /> {{ $t('pages.categories.expenseTitle') }}
          </div>
          <q-list bordered separator>
            <q-item v-for="category in expenseCategories" :key="category.id">
              <q-item-section avatar>
                <q-icon :name="category.icon" color="negative" size="sm" />
              </q-item-section>
              <q-item-section>
                <q-item-label>{{ category.name }}</q-item-label>
              </q-item-section>
              <q-item-section side>
                <div class="row items-center">
                  <q-btn
                    flat
                    round
                    color="positive"
                    icon="edit"
                    size="sm"
                    @click="openEditDialog(category)"
                  />
                  <q-btn
                    flat
                    round
                    color="negative"
                    icon="delete"
                    size="sm"
                    @click="confirmDelete(category)"
                  />
                </div>
              </q-item-section>
            </q-item>
            <q-item v-if="expenseCategories.length === 0">
              <q-item-section>
                <q-item-label class="text-grey">{{
                  $t('pages.categories.noExpense')
                }}</q-item-label>
              </q-item-section>
            </q-item>
          </q-list>
        </div>
      </template>
    </div>

    <!-- Add category dialog -->
    <q-dialog v-model="addDialog" persistent>
      <q-card style="min-width: 350px">
        <q-card-section class="row items-center">
          <div class="text-h6">{{ $t('pages.categories.addDialogTitle') }}</div>
          <q-space />
          <q-btn flat round dense icon="close" v-close-popup />
        </q-card-section>

        <q-card-section>
          <q-form @submit="addCategory" class="q-gutter-md">
            <q-input
              v-model="newCategory.name"
              :label="t('pages.categories.categoryNameLabel')"
              color="positive"
              dense
              :error="!!newCategoryErrors.name"
              :error-message="newCategoryErrors.name"
              @update:model-value="() => validateField(newCategory, newCategoryErrors, 'name')"
            />
            <q-select
              v-model="newCategory.type"
              :options="typeOptions"
              :label="t('pages.categories.typeLabel')"
              color="positive"
              dense
              emit-value
              map-options
              :error="!!newCategoryErrors.type"
              :error-message="newCategoryErrors.type"
              @update:model-value="() => validateField(newCategory, newCategoryErrors, 'type')"
            />

            <q-select
              v-model="newCategory.icon"
              :options="iconOptions"
              :label="t('pages.categories.iconLabel')"
              color="positive"
              dense
              emit-value
              map-options
              use-chips
              :error="!!newCategoryErrors.icon"
              :error-message="newCategoryErrors.icon"
              @update:model-value="() => validateField(newCategory, newCategoryErrors, 'icon')"
            >
              <template v-slot:option="scope">
                <q-item v-bind="scope.itemProps">
                  <q-item-section avatar>
                    <q-icon :name="scope.opt.value" />
                  </q-item-section>
                  <q-item-section>
                    <q-item-label>{{ scope.opt.label }}</q-item-label>
                  </q-item-section>
                </q-item>
              </template>

              <template v-slot:selected>
                <q-chip dense>
                  <q-avatar>
                    <q-icon :name="newCategory.icon" />
                  </q-avatar>
                  {{ getIconLabel(newCategory.icon) }}
                </q-chip>
              </template>
            </q-select>

            <div class="row justify-end q-gutter-sm">
              <q-btn
                flat
                :label="t('pages.categories.cancelButton')"
                color="positive"
                v-close-popup
              />
              <q-btn
                type="submit"
                :label="t('pages.categories.addButton')"
                color="positive"
                :loading="isAdding"
                :disable="!newCategory.name || !newCategory.type || !newCategory.icon"
              />
            </div>
          </q-form>
        </q-card-section>
      </q-card>
    </q-dialog>

    <!-- Edit category dialog -->
    <q-dialog v-model="editDialog" persistent>
      <q-card style="min-width: 350px">
        <q-card-section>
          <div class="text-h6">{{ $t('pages.categories.editDialogTitle') }}</div>
        </q-card-section>

        <q-card-section>
          <q-form @submit="saveEdit" class="q-gutter-md">
            <q-input
              v-model="editingCategory.name"
              :label="t('pages.categories.categoryNameLabel')"
              color="positive"
              dense
              :error="!!editingCategoryErrors.name"
              :error-message="editingCategoryErrors.name"
              @update:model-value="
                () => validateField(editingCategory, editingCategoryErrors, 'name')
              "
            />
            <q-select
              v-model="editingCategory.type"
              :options="typeOptions"
              :label="t('pages.categories.typeLabel')"
              color="positive"
              dense
              emit-value
              map-options
              :error="!!editingCategoryErrors.type"
              :error-message="editingCategoryErrors.type"
              @update:model-value="
                () => validateField(editingCategory, editingCategoryErrors, 'type')
              "
            />

            <q-select
              v-model="editingCategory.icon"
              :options="iconOptions"
              :label="t('pages.categories.iconLabel')"
              color="positive"
              dense
              use-chips
              emit-value
              map-options
              :error="!!editingCategoryErrors.icon"
              :error-message="editingCategoryErrors.icon"
              @update:model-value="
                () => validateField(editingCategory, editingCategoryErrors, 'icon')
              "
            >
              <template v-slot:option="scope">
                <q-item v-bind="scope.itemProps">
                  <q-item-section avatar>
                    <q-icon :name="scope.opt.value" />
                  </q-item-section>
                  <q-item-section>
                    <q-item-label>{{ scope.opt.label }}</q-item-label>
                  </q-item-section>
                </q-item>
              </template>

              <template v-slot:selected>
                <q-chip dense>
                  <q-avatar>
                    <q-icon :name="editingCategory.icon" />
                  </q-avatar>
                  {{ getIconLabel(editingCategory.icon) }}
                </q-chip>
              </template>
            </q-select>

            <div class="row justify-end q-gutter-sm">
              <q-btn
                flat
                :label="t('pages.categories.cancelButton')"
                color="positive"
                v-close-popup
              />
              <q-btn
                type="submit"
                :label="t('pages.categories.saveButton')"
                color="positive"
                :loading="isEditing"
                :disable="!editingCategory.name || !editingCategory.type || !editingCategory.icon"
              />
            </div>
          </q-form>
        </q-card-section>
      </q-card>
    </q-dialog>

    <!-- Confirm delete dialog -->
    <q-dialog v-model="deleteDialog" persistent>
      <q-card>
        <q-card-section class="row items-center">
          <q-icon name="warning" color="warning" size="md" />
          <div class="text-h6 q-ml-md">{{ $t('pages.categories.deleteDialogTitle') }}</div>
        </q-card-section>

        <q-card-section>
          <p>
            {{ $t('pages.categories.deleteConfirmationPrompt') }}
            <strong>{{ categoryToDelete?.name }}</strong
            >? {{ $t('pages.categories.deleteConfirmationWarning') }}
          </p>
        </q-card-section>

        <q-card-actions align="right">
          <q-btn flat :label="t('pages.categories.cancelButton')" color="positive" v-close-popup />
          <q-btn
            flat
            :label="t('pages.categories.deleteButton')"
            color="negative"
            @click="deleteCategory"
            :loading="isDeleting"
          />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </q-page>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue';
import { useQuasar } from 'quasar';
import { useI18n } from 'vue-i18n';
import { useCategoriesStore } from 'src/stores/categories-store';
import { useHouseholdStore } from 'src/stores/household-store';
import { useAuthStore } from 'src/stores/auth-store';
import { useRouter } from 'vue-router';
import type { Category } from 'src/stores/categories-store';
import { z } from 'zod';

// Initialize stores and utils
const $q = useQuasar();
const router = useRouter();
const categoriesStore = useCategoriesStore();
const householdStore = useHouseholdStore();
const authStore = useAuthStore();
const { t } = useI18n();

// Navigation
function goBack() {
  void router.push({ name: 'home' });
}

// Component state
const isLoading = computed(() => categoriesStore.isLoading);
const isAdding = ref(false);
const isEditing = ref(false);
const isDeleting = ref(false);
const addDialog = ref(false);
const editDialog = ref(false);
const deleteDialog = ref(false);
const categoryToDelete = ref<Category | null>(null);

// Categories data
const incomeCategories = computed(() => categoriesStore.incomeCategories);
const expenseCategories = computed(() => categoriesStore.expenseCategories);

// Define Zod schema for category validation
const nameSchema = z
  .string()
  .min(1, 'Category name is required')
  .max(50, 'Category name must be 50 characters or less');

const typeSchema = z.enum(['income', 'expense'], {
  required_error: 'Category type is required',
});

const iconSchema = z.string().min(1, 'Icon is required');

const categorySchema = z.object({
  name: nameSchema,
  type: typeSchema,
  icon: iconSchema,
});

// Form state with validation errors
const newCategory = reactive({
  name: '',
  type: 'expense' as 'income' | 'expense',
  icon: 'payments',
});

const newCategoryErrors = reactive({
  name: '',
  type: '',
  icon: '',
});

const editingCategory = reactive({
  id: '',
  name: '',
  type: '' as 'income' | 'expense',
  icon: '',
});

const editingCategoryErrors = reactive({
  name: '',
  type: '',
  icon: '',
});

// Category type options for select
const typeOptions = computed(() => [
  { label: t('pages.categories.incomeOption'), value: 'income' },
  { label: t('pages.categories.expenseOption'), value: 'expense' },
]);

// Add icon options
const iconOptions = computed(() => [
  { label: t('pages.categories.icons.payments'), value: 'payments' },
  { label: t('pages.categories.icons.work'), value: 'work' },
  { label: t('pages.categories.icons.trendingUp'), value: 'trending_up' },
  { label: t('pages.categories.icons.redeem'), value: 'redeem' },
  { label: t('pages.categories.icons.shoppingCart'), value: 'shopping_cart' },
  { label: t('pages.categories.icons.restaurant'), value: 'restaurant' },
  { label: t('pages.categories.icons.car'), value: 'directions_car' },
  { label: t('pages.categories.icons.home'), value: 'home' },
  { label: t('pages.categories.icons.videoGames'), value: 'videogame_asset' },
  { label: t('pages.categories.icons.utilities'), value: 'bolt' },
  { label: t('pages.categories.icons.subscriptions'), value: 'subscriptions' },
  { label: t('pages.categories.icons.fitness'), value: 'fitness_center' },
  { label: t('pages.categories.icons.health'), value: 'health_and_safety' },
  { label: t('pages.categories.icons.education'), value: 'school' },
  { label: t('pages.categories.icons.travel'), value: 'flight' },
  { label: t('pages.categories.icons.creditCard'), value: 'credit_card' },
  { label: t('pages.categories.icons.savings'), value: 'savings' },
  { label: t('pages.categories.icons.investment'), value: 'account_balance' },
]);

// Helper function to get icon label
function getIconLabel(iconValue: string) {
  // Convert snake_case to camelCase (e.g., trending_up → trendingUp)
  const camelCaseKey = iconValue.replace(/_([a-z])/g, (_, letter) => letter.toUpperCase());
  return t(`pages.categories.icons.${camelCaseKey}`) || iconValue;
}

// Validate a single field
function validateField(formData: any, errors: any, field: 'name' | 'type' | 'icon') {
  try {
    if (field === 'name') {
      nameSchema.parse(formData.name);
      errors.name = '';
    } else if (field === 'type') {
      typeSchema.parse(formData.type);
      errors.type = '';
    } else if (field === 'icon') {
      console.log('formData.icon', formData.icon);
      iconSchema.parse(formData.icon);
      errors.icon = '';
    }
  } catch (error) {
    if (error instanceof z.ZodError) {
      error.errors.forEach((err) => {
        if (field === 'name') errors.name = err.message;
        if (field === 'type') errors.type = err.message;
        if (field === 'icon') errors.icon = err.message;
      });
    }
  }
}

// Validate the entire form
function validateForm(formData: any, errors: any) {
  try {
    categorySchema.parse(formData);
    errors.name = '';
    errors.type = '';
    errors.icon = '';
    return true;
  } catch (error) {
    if (error instanceof z.ZodError) {
      error.errors.forEach((err) => {
        const path = err.path[0] as string;
        if (path === 'name') errors.name = err.message;
        if (path === 'type') errors.type = err.message;
        if (path === 'icon') errors.icon = err.message;
      });
    }
    return false;
  }
}

// Validate category methods
function validateNewCategory() {
  return validateForm(newCategory, newCategoryErrors);
}

function validateEditingCategory() {
  return validateForm(editingCategory, editingCategoryErrors);
}

// Methods
async function addCategory() {
  if (!validateNewCategory()) return;
  if (!householdStore.householdId || !authStore.userId) {
    $q.notify({
      color: 'negative',
      textColor: 'white',
      message: 'User or household information missing',
    });
    return;
  }

  isAdding.value = true;
  try {
    const { error } = await categoriesStore.createCategory({
      name: newCategory.name,
      type: newCategory.type,
      icon: newCategory.icon,
      household_id: householdStore.householdId,
      created_by_user_id: authStore.userId,
    });

    if (error) throw error;

    // Close dialog and reset form
    addDialog.value = false;
    newCategory.name = '';
    newCategory.type = 'expense';
    newCategory.icon = 'payments';
    newCategoryErrors.name = '';
    newCategoryErrors.type = '';
    newCategoryErrors.icon = '';

    $q.notify({
      message: 'Category added successfully',
    });
  } catch (err) {
    console.error('Error adding category:', err);
    $q.notify({
      color: 'negative',
      textColor: 'white',
      message: 'Failed to add category',
    });
  } finally {
    isAdding.value = false;
  }
}

function openEditDialog(category: Category) {
  editingCategory.id = category.id;
  editingCategory.name = category.name;
  editingCategory.type = category.type;
  editingCategory.icon = category.icon;
  editingCategoryErrors.name = '';
  editingCategoryErrors.type = '';
  editingCategoryErrors.icon = '';
  editDialog.value = true;
}

async function saveEdit() {
  if (!validateEditingCategory()) return;

  isEditing.value = true;
  try {
    const { error } = await categoriesStore.updateCategory(editingCategory.id, {
      name: editingCategory.name,
      type: editingCategory.type,
      icon: editingCategory.icon,
    });

    if (error) throw error;

    editDialog.value = false;
    $q.notify({
      message: 'Category updated successfully',
    });
  } catch (err) {
    console.error('Error updating category:', err);
    $q.notify({
      color: 'negative',
      textColor: 'white',
      message: 'Failed to update category',
    });
  } finally {
    isEditing.value = false;
  }
}

function confirmDelete(category: Category) {
  categoryToDelete.value = category;
  deleteDialog.value = true;
}

async function deleteCategory() {
  if (!categoryToDelete.value) return;

  isDeleting.value = true;
  try {
    const { error } = await categoriesStore.deleteCategory(categoryToDelete.value.id);

    if (error) throw error;

    deleteDialog.value = false;
    categoryToDelete.value = null;
    $q.notify({
      message: 'Category deleted successfully',
    });
  } catch (err) {
    console.error('Error deleting category:', err);
    $q.notify({
      color: 'negative',
      textColor: 'white',
      message: 'Failed to delete category',
    });
  } finally {
    isDeleting.value = false;
  }
}

// Open dialogs
function openAddCategoryDialog() {
  // Reset form state
  newCategory.name = '';
  newCategory.type = 'expense';
  newCategory.icon = 'payments';
  newCategoryErrors.name = '';
  newCategoryErrors.type = '';
  newCategoryErrors.icon = '';
  addDialog.value = true;
}

// Initialize
onMounted(async () => {
  await categoriesStore.fetchCategories();
});
</script>

<style lang="scss" scoped>
.categories-page {
  max-width: 800px;
  margin: 0 auto;
  padding-top: 20px;
}
</style>
