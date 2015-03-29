# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

User.create(email: "alice@example.com", password: "password")
User.create(email: "bob@example.com", password: "password")
Chain.create(name: "Commit to Github", user: User.first, longest_chain: 30)
Chain.create(name: "Exercise 7 Minutes", user: User.last, longest_chain: 4)

counter = 6
30.times do
  Link.create(link_day: Time.now.utc.midnight - counter.days, chain: Chain.first)
  counter += 1
end

counter = 6
4.times do
  Link.create(link_day: Time.now.utc.midnight - counter.days, chain: Chain.last)
  counter += 1
end
