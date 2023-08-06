import DashboardLayout from '@/pages/Layout/DashboardLayout.vue';

import Dashboard from '@/pages/Dashboard.vue';
import UserProfile from '@/pages/UserProfile.vue';
import TableList from '@/pages/TableList.vue';
import Typography from '@/pages/Typography.vue';
import Notifications from '@/pages/Notifications.vue';
import Hotels from '@/pages/Hotels.vue';
import Hotel from '@/pages/Hotel.vue';
import Locations from '@/pages/Locations.vue';
import Users from '@/pages/Users.vue';

const routes = [
  {
    path: '/',
    component: DashboardLayout,
    redirect: '/dashboard',
    children: [
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: Dashboard,
      },
      {
        path: 'hotels',
        name: 'Hotels',
        component: Hotels,
      },
      {
        path: 'hotels/add-hotel',
        name: 'Add Hotels',
        component: Hotel,
      },
      {
        path: 'hotels/edit-hotel/:id',
        name: 'Edit Hotels',
        component: Hotel,
      },
      {
        path: 'user',
        name: 'User Profile',
        component: UserProfile,
      },
      {
        path: 'locations',
        name: 'Locations',
        component: Locations,
      },
      {
        path: 'users',
        name: 'Users',
        component: Users,
      },
      {
        path: 'table',
        name: 'Table List',
        component: TableList,
      },
      {
        path: 'typography',
        name: 'Typography',
        component: Typography,
      },
      {
        path: 'notifications',
        name: 'Notifications',
        component: Notifications,
      },
    ],
  },
];

export default routes;
