import { defineStore } from 'pinia';
import { ref } from 'vue';

export type TimePeriod = 'daily' | 'weekly' | 'monthly' | 'yearly';

export const useUiStore = defineStore('ui', () => {
  const selectedTimePeriod = ref<TimePeriod>('monthly');

  function setSelectedTimePeriod(period: TimePeriod) {
    selectedTimePeriod.value = period;
  }

  return {
    selectedTimePeriod,
    setSelectedTimePeriod,
  };
});
