<template>
  <q-dialog ref="dialogRef" @hide="onDialogHide" persistent position="standard">
    <q-card class="q-pa-md" style="min-width: 350px">
      <q-card-section class="q-pt-none">
        <div class="text-h6">{{ categoryName }}</div>
        <div class="text-subtitle2 q-mt-sm">Allocate funds for {{ monthName }}</div>
      </q-card-section>

      <q-card-section>
        <div class="row items-center q-mb-md">
          <div class="col-12">
            <div class="text-body2">Available to Budget:</div>
            <div class="text-h6 q-mb-md" :class="{ 'text-negative': availableToBudget < 0 }">
              {{ formatCurrency(availableToBudget) }}
            </div>
          </div>
        </div>

        <q-input
          v-model.number="allocatedAmount"
          filled
          type="number"
          label="Allocation amount"
          :prefix="currencySymbol"
          :rules="[
            (val) => (val !== null && val !== undefined) || 'Amount is required',
            (val) => val >= 0 || 'Amount must be positive',
          ]"
        >
          <template v-slot:append>
            <q-btn round flat icon="add" @click="increaseAmount" />
            <q-btn
              round
              flat
              icon="remove"
              @click="decreaseAmount"
              :disable="allocatedAmount <= 0"
            />
          </template>
        </q-input>

        <div class="row items-center q-mt-md">
          <div class="col-12">
            <div class="text-body2">Spent so far:</div>
            <div class="text-subtitle1">{{ formatCurrency(spentAmount) }}</div>
          </div>
        </div>

        <div class="row items-center q-mt-md">
          <div class="col-12">
            <div class="text-body2">Available after allocation:</div>
            <div class="text-subtitle1" :class="availableAfterClass">
              {{ formatCurrency(availableAfter) }}
            </div>
          </div>
        </div>
      </q-card-section>

      <q-card-actions align="right">
        <q-btn flat label="Cancel" color="primary" @click="onCancelClick" />
        <q-btn
          flat
          label="Save"
          color="primary"
          @click="onOKClick"
          :disable="availableToBudget < allocatedAmount - originalAmount"
        />
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { useDialogPluginComponent } from 'quasar';
import { useHouseholdStore } from 'src/stores/household-store';
import { useFormatters } from 'src/composables/use-formatters';

const props = defineProps({
  categoryId: {
    type: String,
    required: true,
  },
  categoryName: {
    type: String,
    required: true,
  },
  currentAllocation: {
    type: Number,
    default: 0,
  },
  spentAmount: {
    type: Number,
    default: 0,
  },
  availableToBudget: {
    type: Number,
    required: true,
  },
  monthName: {
    type: String,
    required: true,
  },
});

const { dialogRef, onDialogHide, onDialogOK, onDialogCancel } = useDialogPluginComponent();
const householdStore = useHouseholdStore();
const { formatCurrency } = useFormatters();
// Get currency formatting
const currencySymbol = computed(() => householdStore.currencySymbol);

// State
const allocatedAmount = ref(props.currentAllocation);
const originalAmount = ref(props.currentAllocation);

// Computed properties
const availableAfter = computed(() => {
  return props.availableToBudget - (allocatedAmount.value - originalAmount.value);
});

const availableAfterClass = computed(() => {
  return availableAfter.value < 0 ? 'text-negative' : 'text-positive';
});

// Actions
function increaseAmount() {
  // Step size for increment (can be adjusted as needed)
  const stepSize = 10;
  allocatedAmount.value += stepSize;
}

function decreaseAmount() {
  // Step size for decrement (can be adjusted as needed)
  const stepSize = 10;
  allocatedAmount.value = Math.max(0, allocatedAmount.value - stepSize);
}

// Event handlers
function onOKClick() {
  onDialogOK(allocatedAmount.value);
}

function onCancelClick() {
  onDialogCancel();
}

onMounted(() => {
  // Set the initial value
  allocatedAmount.value = props.currentAllocation;
  originalAmount.value = props.currentAllocation;
});
</script>
