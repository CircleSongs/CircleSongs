import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import inject from "@rollup/plugin-inject";

export default defineConfig({
  plugins: [
    RubyPlugin(),
    inject({   // => that should be first under plugins array
      $: 'jquery',
      jQuery: 'jquery',
    }),
  ],
})
