import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import tailwindcss from '@tailwindcss/vite'
import StimulusHMR from 'vite-plugin-stimulus-hmr'

export default defineConfig({
  plugins: [
    tailwindcss(),
    RubyPlugin(),
    StimulusHMR(),
  ],
  build: {
    commonjsOptions: {
      transformMixedEsModules: true,
    },
  }
})
