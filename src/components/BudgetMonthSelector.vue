<template>
  <div class="month-selector">
    <q-btn flat round icon="chevron_left" @click="onPrevMonth" />
    <div class="month-display">
      <q-btn flat class="month-text" :label="monthName" @click="showMonthPicker = true" />

      <q-dialog v-model="showMonthPicker">
        <q-card style="min-width: 300px">
          <q-card-section class="row items-center q-pb-none">
            <div class="text-h6">Select Month</div>
            <q-space />
            <q-btn icon="close" flat round dense v-close-popup />
          </q-card-section>

          <q-card-section>
            <q-date
              v-model="selectedDate"
              minimal
              navigation-min-year-month="2020/01"
              :navigation-max-year-month="maxYearMonth"
              @update:model-value="updateDate"
              v-close-popup
            />
          </q-card-section>
        </q-card>
      </q-dialog>
    </div>
    <q-btn flat round icon="chevron_right" @click="onNextMonth" :disable="isCurrentMonth" />
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import { date } from 'quasar';

const props = defineProps({
  modelValue: {
    type: Date,
    required: true,
  },
});

const emit = defineEmits(['update:modelValue', 'month-change']);

// State
const showMonthPicker = ref(false);
const selectedDate = ref(date.formatDate(props.modelValue, 'YYYY/MM/DD'));

// Computed
const monthName = computed(() => {
  return date.formatDate(props.modelValue, 'MMMM YYYY');
});

const isCurrentMonth = computed(() => {
  const now = new Date();
  const currentYear = now.getFullYear();
  const currentMonth = now.getMonth();

  const selectedYear = props.modelValue.getFullYear();
  const selectedMonth = props.modelValue.getMonth();

  return selectedYear === currentYear && selectedMonth === currentMonth;
});

const maxYearMonth = computed(() => {
  const now = new Date();
  return `${now.getFullYear()}/${String(now.getMonth() + 1).padStart(2, '0')}`;
});

// Methods
function onPrevMonth() {
  const newDate = new Date(props.modelValue);
  newDate.setMonth(newDate.getMonth() - 1);
  updateModelValue(newDate);
}

function onNextMonth() {
  if (isCurrentMonth.value) return;

  const newDate = new Date(props.modelValue);
  newDate.setMonth(newDate.getMonth() + 1);
  updateModelValue(newDate);
}

function updateDate(val: string) {
  const newDate = new Date(val);
  updateModelValue(newDate);
}

function updateModelValue(newDate: Date) {
  emit('update:modelValue', newDate);
  emit('month-change', newDate);
}
</script>

<style lang="scss" scoped>
.month-selector {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 8px 0;
}

.month-display {
  min-width: 120px;
  text-align: center;
}

.month-text {
  font-size: 1.1rem;
  font-weight: 500;
}
</style>
