# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user = User.new(
    name: 'Admin',
    email: 'admin@admin.com',
    password: '12345678',
    profile: 'default_img.png',
    role: "1",
    phone: "09778202283",
    address: "insein",
    create_user_id: "1",
    updated_user_id: "1"
  )
  user.save