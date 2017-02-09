# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

unless User.find_by(username: 'admin')
  @user = User.new(email: 'admin@example.com', password: 'password', password_confirmation: 'password', name: 'Admin', username: 'admin')
  @user.save
  @user.user_permission.update(user_role: 'admin', permissions: { admin: { all: [:read] }, all: { all: [:manage] } })

  puts '*************************************************************************'
  puts '*                                                                       *'
  puts '* Admin user created (email: "admin@example.com", password: "password") *'
  puts '* visit http://localhost:3000/                                          *'
  puts '*                                                                       *'
  puts '*************************************************************************'
end
