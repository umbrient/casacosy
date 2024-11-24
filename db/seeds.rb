# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

ExpenseType.create([

  { name: 'Rent' },
  { name: 'Setup cost' },
  { name: 'Cleaning' },
  { name: 'Assets' },
  { name: 'Booking fees' },
  { name: 'Bills' },
  { name: 'Entertainment' },
  { name: 'Maintenance' },
  { name: 'Consumables' },
  { name: 'Parking' },
  { name: 'Income' },
  { name: 'Reconciliation' },
  { name: 'Refund' },
  { name: 'Unrelated' },
  { name: 'Other' }

])