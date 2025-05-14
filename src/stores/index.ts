import { defineStore } from '#q-app/wrappers';
import { createPinia } from 'pinia';

// Import all stores for easier access
import { useAuthStore } from './auth-store';
import { useHouseholdStore } from './household-store';
import { useAccountsStore } from './accounts-store';
import { useBudgetStore } from './budget-store';

/*
 * When adding new properties to stores, you should also
 * extend the `PiniaCustomProperties` interface.
 * @see https://pinia.vuejs.org/core-concepts/plugins.html#typing-new-store-properties
 */
declare module 'pinia' {
  // eslint-disable-next-line @typescript-eslint/no-empty-object-type
  export interface PiniaCustomProperties {
    // add your custom properties here, if any
  }
}

export default defineStore((/* { ssrContext } */) => {
  const pinia = createPinia();

  // You can add Pinia plugins here
  // pinia.use(SomePiniaPlugin)

  return pinia;
});

// Export stores for easier imports
export { useAuthStore, useHouseholdStore, useAccountsStore, useBudgetStore };
