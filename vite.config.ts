import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import inject from "@rollup/plugin-inject";
import StimulusHMR from 'vite-plugin-stimulus-hmr'

export default defineConfig({
  plugins: [
    inject({   // => that should be first under plugins array
      $: 'jquery',
      jQuery: 'jquery'
    }),
    RubyPlugin(),
    StimulusHMR(),
  ],
  build: {
    commonjsOptions: {
      transformMixedEsModules: true,
    },
  }
})
