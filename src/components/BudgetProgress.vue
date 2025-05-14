<template>
  <div class="budget-progress">
    <q-circular-progress
      :value="progressValue"
      size="50px"
      :thickness="0.2"
      :color="progressColor"
      track-color="grey-3"
      class="q-mb-sm"
      show-value
      font-size="12px"
    >
      {{ Math.round(progressValue) }}%
    </q-circular-progress>
    <div v-if="showDetails" class="budget-details">
      <div class="row justify-between q-mt-xs">
        <div class="text-subtitle2">{{ label }}</div>
        <div class="text-subtitle2" :class="progressColor">
          {{ formatCurrency(available) }} left
        </div>
      </div>
      <div class="row justify-between text-caption text-grey">
        <div>{{ formatCurrency(allocated) }} allocated</div>
        <div>{{ formatCurrency(spent) }} spent</div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { useFormatters } from 'src/composables/use-formatters';

const props = defineProps({
  allocated: {
    type: Number,
    required: true,
  },
  spent: {
    type: Number,
    required: true,
  },
  label: {
    type: String,
    default: '',
  },
  showDetails: {
    type: Boolean,
    default: true,
  },
});

const { formatCurrency } = useFormatters();

const progressValue = computed(() => {
  if (props.allocated <= 0) return 0;
  return Math.min((props.spent / props.allocated) * 100, 100);
});

const progressColor = computed(() => {
  if (progressValue.value < 80) return 'positive';
  if (progressValue.value < 100) return 'warning';
  return 'negative';
});

const available = computed(() => {
  return Math.max(props.allocated - props.spent, 0);
});
</script>

<style lang="scss" scoped>
.budget-progress {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.budget-details {
  width: 100%;
}
</style>
