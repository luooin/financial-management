import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

/* Layout */
import Layout from '@/layout'

/**
 * Note: sub-menu only appear when route children.length >= 1
 * Detail see: https://panjiachen.github.io/vue-element-admin-site/guide/essentials/router-and-nav.html
 *
 * hidden: true                   if set true, item will not show in the sidebar(default is false)
 * alwaysShow: true               if set true, will always show the root menu
 *                                if not set alwaysShow, when item has more than one children route,
 *                                it will becomes nested mode, otherwise not show the root menu
 * redirect: noRedirect           if set noRedirect will no redirect in the breadcrumb
 * name:'router-name'             the name is used by <keep-alive> (must set!!!)
 * meta : {
    roles: ['admin','editor']    control the page roles (you can set multiple roles)
    title: 'title'               the name show in sidebar and breadcrumb (recommend set)
    icon: 'svg-name'/'el-icon-x' the icon show in the sidebar
    breadcrumb: false            if set false, the item will hidden in breadcrumb(default is true)
    activeMenu: '/example/list'  if set path, the sidebar will highlight the path you set
  }
 */

/**
 * constantRoutes
 * a base page that does not have permission requirements
 * all roles can be accessed
 */
export const constantRoutes = [
  {
    path: '/login',
    component: () => import('@/views/login/index'),
    hidden: true
  },

  {
    path: '/404',
    component: () => import('@/views/404'),
    hidden: true
  },

  {
    path: '/',
    component: Layout,
    redirect: '/system',
    children: [{
      path: 'system',
      name: '企业财务系统',
      component: () => import('@/views/data/index'),
      meta: { title: '首页', icon: 'el-icon-s-marketing' }
    }]
  },

  {
    path: '/approve',
    component: Layout,
    redirect: '/approve/invoice',
    name: '审批',
    meta: { title: '审批', icon: 'el-icon-s-help' },
    children: [
      {
        path: 'invoice',
        name: '发票审批',
        component: () => import('@/views/invoice/index'),
        meta: { title: '发票审批', icon: 'table' }
      },
      {
        path: 'off',
        name: '请假审批',
        component: () => import('@/views/off/index'),
        meta: { title: '请假审批', icon: 'tree' }
      }
    ]
  },

  {
    path: '/salary',
    component: Layout,
    children: [
      {
        path: 'salary',
        name: '工资',
        component: () => import('@/views/salary/index'),
        meta: { title: '工资单', icon: 'form' }
      }
    ]
  },

  {
    path: '/user',
    component: Layout,
    redirect: '/nested/menu1',
    name: '员工管理',
    meta: {
      title: '员工',
      icon: 'el-icon-s-custom'
    },
    children: [
      {
        path: 'menu1',
        component: () => import('@/views/nested/menu1/index'), // Parent router-view
        name: '初级',
        meta: { title: '初级' }
      },
      {
        path: 'menu2',
        component: () => import('@/views/nested/menu2/index'),
        name: '中级',
        meta: { title: '中级' }
      },
      {
        path: 'menu3',
        component: () => import('@/views/nested/menu3/index'),
        name: '高级',
        meta: { title: '高级' }
      }
    ]
  },
  {
    path: '/order',
    component: Layout,
    children: [
      {
        path: 'order',
        name: '收支',
        component: () => import('@/views/order/index'),
        meta: { title: '收支', icon: 'form' }
      }
    ]
  },
  // {
  //   path: '/data',
  //   component: Layout,
  //   children: [
  //     {
  //       path: 'data',
  //       name: '数据分析',
  //       component: () => import('@/views/data/index'),
  //       meta: { title: '数据分析', icon: 'el-icon-s-marketing' }
  //     }
  //   ]
  // },
  { path: '*', redirect: '/404', hidden: true }
]

const createRouter = () => new Router({
  // mode: 'history', // require service support
  scrollBehavior: () => ({ y: 0 }),
  routes: constantRoutes
})

const router = createRouter()

export function resetRouter() {
  const newRouter = createRouter()
  router.matcher = newRouter.matcher // reset router
}

export default router
