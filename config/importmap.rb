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
pin "fetch", to: "https://ga.jspm.io/npm:fetch@1.1.0/lib/fetch.js"
pin "buffer", to: "https://ga.jspm.io/npm:@jspm/core@2.0.0-beta.24/nodelibs/browser/buffer.js"
pin "dns", to: "https://ga.jspm.io/npm:@jspm/core@2.0.0-beta.24/nodelibs/browser/dns.js"
pin "encoding", to: "https://ga.jspm.io/npm:encoding@0.1.12/lib/encoding.js"
pin "http", to: "https://ga.jspm.io/npm:@jspm/core@2.0.0-beta.24/nodelibs/browser/http.js"
pin "https", to: "https://ga.jspm.io/npm:@jspm/core@2.0.0-beta.24/nodelibs/browser/https.js"
pin "iconv-lite", to: "https://ga.jspm.io/npm:iconv-lite@0.4.24/lib/index.js"
pin "net", to: "https://ga.jspm.io/npm:@jspm/core@2.0.0-beta.24/nodelibs/browser/net.js"
pin "safer-buffer", to: "https://ga.jspm.io/npm:safer-buffer@2.1.2/safer.js"
pin "stream", to: "https://ga.jspm.io/npm:@jspm/core@2.0.0-beta.24/nodelibs/browser/stream.js"
pin "string_decoder", to: "https://ga.jspm.io/npm:@jspm/core@2.0.0-beta.24/nodelibs/browser/string_decoder.js"
pin "url", to: "https://ga.jspm.io/npm:@jspm/core@2.0.0-beta.24/nodelibs/browser/url.js"
pin "util", to: "https://ga.jspm.io/npm:@jspm/core@2.0.0-beta.24/nodelibs/browser/util.js"
pin "zlib", to: "https://ga.jspm.io/npm:@jspm/core@2.0.0-beta.24/nodelibs/browser/zlib.js"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "lodash", to: "https://ga.jspm.io/npm:lodash@4.17.21/lodash.js"
