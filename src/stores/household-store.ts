import { defineStore, acceptHMRUpdate } from 'pinia';
import { ref, computed } from 'vue';
import { supabase } from 'src/boot/supabase';
import { useAuthStore } from './auth-store';

export interface HouseholdMember {
  user_id: string;
  household_id: string;
  role: 'owner' | 'member';
  joined_at: string | null;
  user?: {
    email: string;
    first_name: string | null;
    last_name: string | null;
    avatar_url: string | null;
  } | null;
}

export interface Household {
  id: string;
  name: string;
  created_at: string;
  members?: HouseholdMember[];
}

export const useHouseholdStore = defineStore('household', () => {
  // State
  const currentHousehold = ref<Household | null>(null);
  const members = ref<HouseholdMember[]>([]);
  const isLoading = ref(false);
  const error = ref<Error | null>(null);

  // Getters
  const householdId = computed(() => currentHousehold.value?.id);
  const householdName = computed(() => currentHousehold.value?.name);
  const isOwner = computed(() => {
    const authStore = useAuthStore();
    const userId = authStore.userId;
    return members.value.some((member) => member.user_id === userId && member.role === 'owner');
  });

  // Actions

  async function fetchUserHousehold() {
    const authStore = useAuthStore();
    if (!authStore.userId) return;

    isLoading.value = true;
    error.value = null;

    try {
      // Get the user's household memberships
      const { data: membershipData, error: membershipError } = await supabase
        .from('household_members')
        .select('household_id, role')
        .eq('user_id', authStore.userId)
        .single();

      if (membershipError) throw membershipError;

      if (membershipData) {
        // Fetch the household details
        const { data: householdData, error: householdError } = await supabase
          .from('households')
          .select('*')
          .eq('id', membershipData.household_id)
          .single()
          .overrideTypes<{ created_at: string }>();

        if (householdError) throw householdError;

        currentHousehold.value = householdData;

        // Now fetch all members of this household
        await fetchHouseholdMembers(membershipData.household_id);
      }
    } catch (err) {
      console.error('Error fetching household:', err);
      error.value = err instanceof Error ? err : new Error('Failed to fetch household');
    } finally {
      isLoading.value = false;
    }
  }

  async function fetchHouseholdMembers(householdId: string) {
    isLoading.value = true;
    error.value = null;

    try {
      // First get members
      const { data: membersData, error: membersError } = await supabase
        .from('household_members')
        .select('user_id, household_id, role, joined_at')
        .eq('household_id', householdId);

      if (membersError) throw membersError;

      if (!membersData || membersData.length === 0) {
        members.value = [];
        return;
      }

      // Now get user details for these members
      const userIds = membersData.map((member) => member.user_id);

      const { data: usersData, error: usersError } = await supabase
        .from('users')
        .select('id, email, first_name, last_name, avatar_url')
        .in('id', userIds);

      if (usersError) throw usersError;

      // Combine the data
      const combinedData: HouseholdMember[] = membersData.map((member) => {
        const userData = usersData?.find((user) => user.id === member.user_id);

        return {
          user_id: member.user_id,
          household_id: member.household_id,
          role: member.role as 'owner' | 'member',
          joined_at: member.joined_at,
          user: userData
            ? {
                email: userData.email,
                first_name: userData.first_name,
                last_name: userData.last_name,
                avatar_url: userData.avatar_url,
              }
            : null,
        };
      });

      members.value = combinedData;
    } catch (err) {
      console.error('Error fetching household members:', err);
      error.value = err instanceof Error ? err : new Error('Failed to fetch household members');
    } finally {
      isLoading.value = false;
    }
  }

  return {
    // State
    currentHousehold,
    members,
    isLoading,
    error,

    // Getters
    householdId,
    householdName,
    isOwner,

    // Actions
    fetchUserHousehold,
    fetchHouseholdMembers,
  };
});

if (import.meta.hot) {
  import.meta.hot.accept(acceptHMRUpdate(useHouseholdStore, import.meta.hot));
}
