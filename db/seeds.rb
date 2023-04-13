require 'faker'

Faker::Config.locale = :en

15.times do
    SearchQuery.create!(query: "What tech stacks are Helpjuice working with?", ip_address: Faker::Internet.ip_v4_address, counter: 1)
end

10.times do
  SearchQuery.create!(query: "Who is Emil Hajric?", ip_address: Faker::Internet.ip_v4_address, counter: 1)
end

15.times do
  SearchQuery.create!(query: "What is Helpjuice?", ip_address: Faker::Internet.ip_v4_address, counter: 1)
end

5.times do
  SearchQuery.create!(query: "Who is the owner of Helpjuice", ip_address: Faker::Internet.ip_v4_address, counter: 1)
end

7.times do
  SearchQuery.create!(query: "What are the services of Helpjuice company?", ip_address: Faker::Internet.ip_v4_address, counter: 1)
end

25.times do
  SearchQuery.create!(query: "What it takes to be part of Helpjuice Amazing team?", ip_address: Faker::Internet.ip_v4_address, counter: 1)
end
