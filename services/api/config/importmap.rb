# Pin npm packages by running ./bin/importmap

pin 'application'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin_all_from 'app/javascript/helpers', under: 'helpers'
pin 'debounce' # @2.2.0
pin 'stimulus-use' # @0.52.3
pin 'dropzone' # @6.0.0
pin 'just-extend' # @5.1.1
pin '@rails/activestorage', to: '@rails--activestorage.js' # @8.0.200
pin "@rails/request.js", to: "@rails--request.js.js" # @0.0.12
pin "sortablejs" # @1.15.6
