# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

application = Application.create!(name: 'John Doe', street_address: '123 apple street', city: 'Denver', state: 'CO', zipcode: '90210', description: 'we love pets', status: 'In Progress')
shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
scooby = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
frank = Pet.create!(name: 'Frank', age: 1, breed: 'Pug', adoptable: true, shelter_id: shelter.id)
nala = Pet.create!(name: 'Nala', age: 100, breed: 'Bichon', adoptable: false, shelter_id: shelter.id)
scooby_application = PetApplication.create!(pet: scooby, application: application)
