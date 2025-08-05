import { RouteInfo } from './sidebar.metadata';

export const ROUTES: RouteInfo[] = [
  {
    path: '',
    title: 'Main',
    icon: '',
    class: 'header',
    groupTitle: true,
    visibleTo: ['ROLE_SUPERADMIN', 'ROLE_PROVIDER_ADMIN','ROLE_PROVIDER_EMPLOYEE'],
    submenu: [],

  },
  {
    path: '/dashboard/main',
    title: 'Dashboard',
    icon: 'monitor',
    class: '',
    groupTitle: false,
    visibleTo: ['ROLE_SUPERADMIN', 'ROLE_PROVIDER_ADMIN','ROLE_PROVIDER_EMPLOYEE'],
    submenu: [
      /* {
        path: '/dashboard/main',
        title: 'Main',
        icon: '',
        class: 'ml-menu',
        groupTitle: false,
        submenu: []
      }, */
      /* {
        path: '/dashboard/sales',
        title: 'Sales',
        icon: '',
        class: 'ml-menu',
        groupTitle: false,
        submenu: []
      }, */
    ]
  },
  {
    path: 'customers',
    title: 'Customers',
    icon: 'users',
    class: '',
    groupTitle: false,
    visibleTo: ['ROLE_SUPERADMIN',''],
    submenu: []
  },
  {
    path: 'user-management',
    title: 'Employees',
    icon: 'users',
    class: '',
    groupTitle: false,
    visibleTo: ['ROLE_PROVIDER_ADMIN',''],
    submenu: []
  },
  {
    path: 'providers',
    title: 'Providers',
    icon: 'briefcase',
    class: '',
    visibleTo: ['ROLE_SUPERADMIN', ''],

    groupTitle: false,
    submenu: []
  },
  {
    path: '',
    title: 'Orders',
    icon: 'grid',
    class: 'menu-toggle',
    groupTitle: false,
    visibleTo: ['ROLE_SUPERADMIN', 'ROLE_PROVIDER_ADMIN','ROLE_PROVIDER_EMPLOYEE'],

    submenu: [
      {
        path: '/orders/running',
        title: 'Running Orders',
        icon: '',
        class: 'ml-menu',
        groupTitle: false,
        visibleTo: ['ROLE_SUPERADMIN', 'ROLE_PROVIDER_ADMIN','ROLE_PROVIDER_EMPLOYEE'],
        submenu: []
      },
      {
        path: '/orders/scheduled',
        title: 'Scheduled Orders',
        icon: '',
        class: 'ml-menu',
        groupTitle: false,
        visibleTo: ['ROLE_SUPERADMIN', 'ROLE_PROVIDER_ADMIN','ROLE_PROVIDER_EMPLOYEE'],
        submenu: []
      },
      {
        path: '/orders/history',
        title: "Orders History",
        icon: '',
        class: 'ml-menu',
        groupTitle: false,
        visibleTo: ['ROLE_SUPERADMIN', 'ROLE_PROVIDER_ADMIN','ROLE_PROVIDER_EMPLOYEE'],
        submenu: []
      }
    ]
  },
  {
      path: 'payment',
      title: 'Payments',
      icon: 'dollar-sign',
      class: '',
      visibleTo: ['ROLE_SUPERADMIN', 'ROLE_PROVIDER_ADMIN','ROLE_PROVIDER_EMPLOYEE'],

      groupTitle: false,
      submenu: []
    },
    {
      path: 'provider-data',
      title: 'Provider Config',
      icon: 'grid',
      class: 'menu-toggle',
      groupTitle: false,
      visibleTo: ['', 'ROLE_PROVIDER_ADMIN'],
      submenu: [
        {
          path: '/provider-data/insurances',
          title: 'Insurances',
          icon: '',
          class: 'ml-menu',
          groupTitle: false,
          visibleTo: ['', 'ROLE_PROVIDER_ADMIN'],
          submenu: []
        },
        {
          path: '/provider-data/vehicles',
          title: 'Vehicles',
          icon: '',
          class: 'ml-menu',
          groupTitle: false,
          visibleTo: ['', 'ROLE_PROVIDER_ADMIN'],
          submenu: []
        },
        {
          path: '/provider-data/licenses',
          title: 'Licenses',
          icon: '',
          class: 'ml-menu',
          groupTitle: false,
          visibleTo: ['', 'ROLE_PROVIDER_ADMIN'],
          submenu: []
        }
      ]
      },

  {
    path: '',
    title: 'Super Admin rights',
    icon: '',
    class: '',
    groupTitle: true,
    visibleTo: ['ROLE_SUPERADMIN', ''],
    submenu: []
  },

  {
    path: '',
    title: 'Metadata',
    icon: 'grid',
    class: 'menu-toggle',
    groupTitle: false,
    visibleTo: ['ROLE_SUPERADMIN', ''],
    submenu: [
      {
        path: '/meta-data/category',
        title: 'Category',
        icon: '',
        class: 'ml-menu',
        groupTitle: false,
        visibleTo: ['ROLE_SUPERADMIN', ''],
        submenu: []
      },
      {
        path: '/meta-data/help',
        title: 'Help & Support',
        icon: '',
        class: 'ml-menu',
        groupTitle: false,
        visibleTo: ['ROLE_SUPERADMIN', ''],
        submenu: []
      },
      {
              path: '/meta-data/commission',
              title: 'Commission Details',
              icon: '',
              class: 'ml-menu',
              groupTitle: false,
              visibleTo: ['ROLE_SUPERADMIN', ''],
              submenu: []
      },
      {
        path: '/meta-data/faq',
        title: "FAQ's",
        icon: '',
        class: 'ml-menu',
        groupTitle: false,
        visibleTo: ['ROLE_SUPERADMIN', ''],
        submenu: []
      },
      // {
      //   path: '/meta-data/static-content',
      //   title: 'Static Content',
      //   icon: '',
      //   class: 'ml-menu',
      //   groupTitle: false,
      //   visibleTo: ['ROLE_SUPERADMIN', ''],
      //   submenu: []
      // },

      {
        path: '/meta-data/tax',
        title: 'Tax',
        icon: '',
        class: 'ml-menu',
        groupTitle: false,
        visibleTo: ['ROLE_SUPERADMIN', ''],
        submenu: []
      },
       {
              path: '/meta-data/country',
              title: 'Country',
              icon: '',
              class: 'ml-menu',
              groupTitle: false,
              visibleTo: ['ROLE_SUPERADMIN', ''],
              submenu: []
            },
      {
        path: '/meta-data/insurance-type',
        title: 'Insurance Type',
        icon: '',
        class: 'ml-menu',
        groupTitle: false,
        visibleTo: ['ROLE_SUPERADMIN', ''],
        submenu: []
      },
      {
        path: '/meta-data/license-type',
        title: 'License Type',
        icon: '',
        class: 'ml-menu',
        groupTitle: false,
        visibleTo: ['ROLE_SUPERADMIN', ''],
        submenu: []
      }

    ]
  },



];
