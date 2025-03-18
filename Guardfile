# Guardfile configured to only watch Ruby files in a Rails app and lib directory

guard :rspec, cmd: "bundle exec rspec" do
  # Watch Ruby files in app and lib
  watch(%r{^app/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }

  # Watch spec files
  watch(%r{^spec/.+_spec\.rb$})

  # Watch spec helper/support files
  watch(%r{^spec/spec_helper\.rb$}) { "spec" }
  watch(%r{^spec/rails_helper\.rb$}) { "spec" }
  watch(%r{^spec/support/(.+)\.rb$}) { "spec" }

  # Watch factory files
  watch(%r{^spec/factories/(.+)\.rb$}) do |m|
    [
      "spec/models/#{m[1].singularize}_spec.rb",
      "spec/controllers/#{m[1]}_controller_spec.rb",
      "spec/requests/#{m[1]}_spec.rb"
    ]
  end
end
