require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do
    it { should have_many(:pets)}
    it { should have_many(:pets).through(:pet_applications)}
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:street_address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zipcode) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:status) }
  end

  describe 'methods' do
    it 'has_pets? returns true if application has pets associated' do
      application = Application.create!(name: 'Jeremy', street_address: '111 Nonya Ave', city: 'Denver', state: 'CO', zipcode: '80201', description: 'Dogs are rad', status: 'In Progress')
      application_2 = Application.create!(name: 'Jeremy', street_address: '111 Nonya Ave', city: 'Denver', state: 'CO', zipcode: '80201', description: 'Dogs are rad', status: 'In Progress')
      shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      scooby = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
      PetApplication.create!(pet: scooby, application: application)

      expect(application_2.has_pets?).to eq(false)
      expect(application.has_pets?).to eq(true)
    end
  end
end
