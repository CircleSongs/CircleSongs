# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "popper", to: 'popper.js', preload: true
pin "bootstrap", to: 'bootstrap.min.js', preload: true
pin "vexchords", to: "https://ga.jspm.io/npm:vexchords@1.2.0/index.js"
pin "@svgdotjs/svg.js", to: "https://ga.jspm.io/npm:@svgdotjs/svg.js@3.1.2/dist/svg.esm.js"
pin "chordsheetjs", to: "https://ga.jspm.io/npm:chordsheetjs@6.3.0/lib/index.js"
pin "fs", to: "https://ga.jspm.io/npm:@jspm/core@2.0.0-beta.24/nodelibs/browser/fs.js"
pin "handlebars", to: "https://ga.jspm.io/npm:handlebars@4.7.7/lib/index.js"
pin "lodash.get", to: "https://ga.jspm.io/npm:lodash.get@4.4.2/index.js"
pin "process", to: "https://ga.jspm.io/npm:@jspm/core@2.0.0-beta.24/nodelibs/browser/process-production.js"
pin "source-map", to: "https://ga.jspm.io/npm:source-map@0.6.1/source-map.js"
pin_all_from "app/javascript/src", under: "src"
