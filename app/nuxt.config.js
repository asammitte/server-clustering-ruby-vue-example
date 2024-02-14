export default {
  server: {
    port: 3008
  },

  // runtimeConfig: {
  //   // apiSecret: '', // can be overridden by NUXT_API_SECRET environment variable
  //   public: {
  //     mapboxAccessToken: '', // can be overridden by NUXT_PUBLIC_API_BASE environment variable
  //   }
  // },

  publicRuntimeConfig: {
    NUXT_PUBLIC_MAPBOX_ACCESS_TOKEN: process.env.NUXT_PUBLIC_MAPBOX_ACCESS_TOKEN
  },

  // Global page headers: https://go.nuxtjs.dev/config-head
  head: {
    title: 'app',
    htmlAttrs: {
      lang: 'en',
    },
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: '' },
      { name: 'format-detection', content: 'telephone=no' },
    ],
    link: [{ rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }],
  },

  // Global CSS: https://go.nuxtjs.dev/config-css
  css: [
    '@/assets/css/main'
  ],

  // Plugins to run before rendering page: https://go.nuxtjs.dev/config-plugins
  plugins: [],

  // Auto import components: https://go.nuxtjs.dev/config-components
  components: true,

  // Modules for dev and build (recommended): https://go.nuxtjs.dev/config-modules
  buildModules: [
    // https://go.nuxtjs.dev/eslint
    '@nuxtjs/eslint-module',
  ],

  // Modules: https://go.nuxtjs.dev/config-modules
  modules: [
    '@nuxtjs/axios',
  ],

  // Build Configuration: https://go.nuxtjs.dev/config-build
  build: {},

  axios: {
    '/api': {
      target: process.env.API_URL,
      // target: 'http://localhost:8090/',
      pathRewrite: {
          '^/api': '/'
      },
      changeOrigin: true
    },
  },
}
