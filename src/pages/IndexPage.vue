<template>
  <q-page class="row items-center justify-evenly">
    <example-component
      :title="$t('pages.index.exampleComponentTitle')"
      active
      :todos="todos"
      :meta="meta"
    ></example-component>
  </q-page>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue';
import type { Todo, Meta } from 'components/models';
import ExampleComponent from 'components/ExampleComponent.vue';

import { supabase } from 'boot/supabase';

const todos = ref<Todo[]>([]);
const meta = ref<Meta>({
  totalCount: 0,
});

async function getTodos() {
  const { data } = await supabase.from('todos').select();
  todos.value = data ?? [];
  meta.value.totalCount = data?.length ?? 0;
}

onMounted(() => {
  void getTodos();
});
</script>
