# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


User.create(username: "francis", email: "francis@semiweb.ca", role: 2, encrypted_password: "$2a$10$tRR/q9CH9.02EqqXJOpnRe27324Jng05wQ8gWl6/Lrd3HMrYA6YsS", salt:"$2a$10$tRR/q9CH9.02EqqXJOpnRe")