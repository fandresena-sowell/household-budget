import type { RouteRecordRaw } from 'vue-router';

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    component: () => import('layouts/MainLayout.vue'),
    children: [
      { name: 'home', path: '', redirect: '/accounts' },
      { name: 'accounts', path: 'accounts', component: () => import('pages/AccountsPage.vue') },
      {
        name: 'account-detail',
        path: 'accounts/:id',
        component: () => import('pages/AccountDetailPage.vue'),
      },
      {
        name: 'settings',
        path: 'settings',
        component: () => import('pages/SettingsPage.vue'),
      },
      {
        name: 'categories',
        path: 'settings/categories',
        component: () => import('pages/CategoriesPage.vue'),
      },
      {
        name: 'budget',
        path: 'budget',
        component: () => import('pages/BudgetPage.vue'),
      },
    ],
  },

  // Auth routes
  {
    path: '/',
    component: () => import('layouts/AuthLayout.vue'),
    children: [
      { name: 'login', path: 'login', component: () => import('pages/LoginPage.vue') },
      { name: 'register', path: 'register', component: () => import('pages/RegisterPage.vue') },
    ],
  },

  // Always leave this as last one,
  // but you can also remove it
  {
    path: '/:catchAll(.*)*',
    component: () => import('pages/ErrorNotFound.vue'),
  },
];

export default routes;
