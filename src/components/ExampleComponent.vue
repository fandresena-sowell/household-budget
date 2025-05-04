<template>
  <div>
    <p>{{ title }}</p>
    <ul>
      <li v-for="todo in todos" :key="todo.id" @click="increment">
        {{ todo.id }} - {{ todo.content }}
      </li>
    </ul>
    <p>{{ $t('components.example.countLabel') }} {{ todoCount }} / {{ meta.totalCount }}</p>
    <p>
      {{ $t('components.example.activeLabel') }}
      {{ active ? $t('components.example.activeYes') : $t('components.example.activeNo') }}
    </p>
    <p>{{ $t('components.example.clicksLabel') }} {{ clickCount }}</p>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue';
import type { Todo, Meta } from './models';

interface Props {
  title: string;
  todos?: Todo[];
  meta: Meta;
  active: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  todos: () => [],
});

const clickCount = ref(0);
function increment() {
  clickCount.value += 1;
  return clickCount.value;
}

const todoCount = computed(() => props.todos.length);
</script>
