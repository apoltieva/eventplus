# frozen_string_literal: true

desc 'Replaces examplatory Stripe Api key with the given one'

task :replace_stripe_key, [:key] do |_t, args|
  text = File.read("#{Rails.root}/config/application.example.yml")
  File.write("#{Rails.root}/config/application.example.yml",
             text.gsub(/STRIPE_SECRET_KEY/, args[:key]))
  puts 'Replaced STRIPE_SECRET_KEY'
end