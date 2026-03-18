CI.run do
  step 'Setup: Dependencies', 'bundle install && yarn install'
  step 'Setup: Database', 'bin/rails db:prepare'

  step 'Style: Ruby', 'bundle exec rubocop'

  step 'Security: Gem audit', 'bundle exec bundler-audit check --update'
  step 'Security: Brakeman', 'bundle exec brakeman --no-pager --no-exit-on-warn'

  step 'Build: Vite assets', 'bundle exec vite build'
  step 'Tests: RSpec', 'bundle exec rspec'
end
