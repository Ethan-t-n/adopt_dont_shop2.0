RSpec.describe 'show application' do
  it "shows the applications and all the attributes" do
    application = Application.create!(name: 'Jeremy', street_address: '111 Nonya Ave', city: 'Denver', state: 'CO', zipcode: '80201', description: 'Dogs are rad', status: 'In Progress')
    shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
    pet = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)

    PetApplication.create!(pet: pet, application: application)

    visit "/applications/#{application.id}"

    expect(page).to have_content('Jeremy')
    expect(page).to have_content('111 Nonya Ave')
    expect(page).to have_content('Denver')
    expect(page).to have_content('CO')
    expect(page).to have_content('80201')
    expect(page).to have_content('Dogs are rad')
    expect(page).to have_content('In Progress')

    expect(page).to have_link('Scooby')
  end

  it "has a search and add a Pet to this Application" do #Wyatt user story
    application = Application.create!(name: 'Jeremy', street_address: '111 Nonya Ave', city: 'Denver', state: 'CO', zipcode: '80201', description: 'Dogs are rad', status: 'In Progress')
    shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)

    pet = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)

    PetApplication.create!(pet: pet, application: application)

    visit "/applications/#{application.id}"

    expect(page).to have_content('In Progress')

    within "#pet_search" do
    expect(page).to have_content('Search for a Pet to Add to this Application')
    end
  end

  it "show pet names that match" do
    application = Application.create!(name: 'Jeremy', street_address: '111 Nonya Ave', city: 'Denver', state: 'CO', zipcode: '80201', description: 'Dogs are rad', status: 'In Progress')
    shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)

    scooby = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
    frank = Pet.create!(name: 'Frank', age: 1, breed: 'Pug', adoptable: true, shelter_id: shelter.id)
    nala = Pet.create!(name: 'Nala', age: 100, breed: 'Bichon', adoptable: false, shelter_id: shelter.id)

    PetApplication.create!(pet: scooby, application: application)

    visit "/applications/#{application.id}"

    fill_in('Search for Pets by name:', with: "Scooby")

    click_button("Search")

    expect(current_path).to eq("/applications/#{application.id}")
    within "#searched_pets" do
      expect(page).to have_content("Scooby")
      expect(page).to_not have_content("Frank")
      expect(page).to_not have_content("Nala")
    end
  end

  it "shows full name of pet with partial name of pet" do #Ethan User Story
    application = Application.create!(name: 'Jeremy', street_address: '111 Nonya Ave', city: 'Denver', state: 'CO', zipcode: '80201', description: 'Dogs are rad', status: 'In Progress')
    shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)

    scooby = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
    frank = Pet.create!(name: 'Frank', age: 1, breed: 'Pug', adoptable: true, shelter_id: shelter.id)
    nala = Pet.create!(name: 'Nala', age: 100, breed: 'Bichon', adoptable: false, shelter_id: shelter.id)

    PetApplication.create!(pet: scooby, application: application)

    visit "/applications/#{application.id}"

    fill_in('Search for Pets by name:', with: "Fra")

    click_button("Search")

    expect(current_path).to eq("/applications/#{application.id}")
    within "#searched_pets" do
      expect(page).to have_content("Frank")
      expect(page).to_not have_content("Scooby")
      expect(page).to_not have_content("Nala")
    end
  end

  it "has a button adopt this pet next to each pet after searching the name" do
    application = Application.create!(name: 'Jeremy', street_address: '111 Nonya Ave', city: 'Denver', state: 'CO', zipcode: '80201', description: 'Dogs are rad', status: 'In Progress')
    shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)

    scooby = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
    frank = Pet.create!(name: 'Frank', age: 1, breed: 'Pug', adoptable: true, shelter_id: shelter.id)
    nala = Pet.create!(name: 'Nala', age: 100, breed: 'Bichon', adoptable: false, shelter_id: shelter.id)
    emma = Pet.create!(name: 'Emma', age: 3, breed: 'Lab', adoptable: true, shelter_id: shelter.id)

    PetApplication.create!(pet: scooby, application: application)

    visit "/applications/#{application.id}"

    fill_in('Search for Pets by name:', with: "Scoo")

    click_button("Search")

    expect(current_path).to eq("/applications/#{application.id}")
    within "#searched_pets" do
      expect(page).to have_button("Adopt this Pet")
    end
  end

  it "adopt this pet button adds the pet to the application" do
    application = Application.create!(name: 'Jeremy', street_address: '111 Nonya Ave', city: 'Denver', state: 'CO', zipcode: '80201', description: 'Dogs are rad', status: 'In Progress')
    shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)

    scooby = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
    frank = Pet.create!(name: 'Frank', age: 1, breed: 'Pug', adoptable: true, shelter_id: shelter.id)
    nala = Pet.create!(name: 'Nala', age: 100, breed: 'Bichon', adoptable: false, shelter_id: shelter.id)
    emma = Pet.create!(name: 'Emma', age: 3, breed: 'Lab', adoptable: true, shelter_id: shelter.id)

    PetApplication.create!(pet: scooby, application: application)

    visit "/applications/#{application.id}"

    fill_in('Search for Pets by name:', with: "Fra")

    click_button("Search")

    click_button("Adopt this Pet")

    expect(current_path).to eq("/applications/#{application.id}")

    within "#pets_in_application" do
      expect(page).to have_content("Frank")
      expect(page).to_not have_content("Emma")
    end
  end

  it "adopt this pet button adds the pet to the application case insensitive" do
    application = Application.create!(name: 'John Doe', street_address: '123 apple street', city: 'Denver', state: 'CO', zipcode: '90210', description: 'we love pets', status: 'In Progress')
    shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)

    scooby = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
    frank = Pet.create!(name: 'Frank', age: 1, breed: 'Pug', adoptable: true, shelter_id: shelter.id)
    nala = Pet.create!(name: 'Nala', age: 100, breed: 'Bichon', adoptable: false, shelter_id: shelter.id)
    emma = Pet.create!(name: 'Emma', age: 3, breed: 'Lab', adoptable: true, shelter_id: shelter.id)

    PetApplication.create!(pet: scooby, application: application)

    visit "/applications/#{application.id}"

    fill_in('Search for Pets by name:', with: "fRa")

    click_button("Search")

    click_button("Adopt this Pet")

    expect(current_path).to eq("/applications/#{application.id}")

    within "#pets_in_application" do
      expect(page).to have_content("Frank")
      expect(page).to_not have_content("Emma")
    end
  end

  it 'shows a submit section when pets are part of application' do
    application = Application.create!(name: 'Jeremy', street_address: '111 Nonya Ave', city: 'Denver', state: 'CO', zipcode: '80201', description: 'Dogs are rad', status: 'In Progress')
    shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)

    scooby = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)

    PetApplication.create!(pet: scooby, application: application)

    visit "/applications/#{application.id}"

    expect(page).to have_button("Submit this Application")
  end

  it 'doesnt show a submit section without any pets in application'do
    application = Application.create!(name: 'Jeremy', street_address: '111 Nonya Ave', city: 'Denver', state: 'CO', zipcode: '80201', description: 'Dogs are rad', status: 'In Progress')
    shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)


    visit "/applications/#{application.id}"

    expect(page).to_not have_button("Submit this Application")
  end

  it 'when submitted the Application status is pending cant add more pets' do
    application = Application.create!(name: 'Jeremy', street_address: '111 Nonya Ave', city: 'Denver', state: 'CO', zipcode: '80201', description: 'Dogs are rad', status: 'In Progress')
    shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)

    scooby = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
    frank = Pet.create!(name: 'Frank', age: 1, breed: 'Pug', adoptable: true, shelter_id: shelter.id)

    PetApplication.create!(pet: scooby, application: application)

    visit "/applications/#{application.id}"

    fill_in('description', with: "Dogs are rad")
    click_button("Submit this Application")

    expect(current_path).to eq("/applications/#{application.id}")
    expect(page).to have_content("Pending")
    expect(page).to have_content("Scooby")
    expect(page).to_not have_content("Frank")
  end

  it 'admin routes to show page with priviledge' do
  application = Application.create!(name: 'Jeremy', street_address: '111 Nonya Ave', city: 'Denver', state: 'CO', zipcode: '80201', description: 'Dogs are rad', status: 'In Progress')

  visit "/admin/applications/#{application.id}"

  expect(page).to have_content("Application Show Page")
  end

  it 'every pet on the application has a approve button' do
    application = Application.create!(name: 'Jeremy', street_address: '111 Nonya Ave', city: 'Denver', state: 'CO', zipcode: '80201', description: 'Dogs are rad', status: 'In Progress')
    shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)

    scooby = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
    frank = Pet.create!(name: 'Frank', age: 1, breed: 'Pug', adoptable: true, shelter_id: shelter.id)

    PetApplication.create!(pet: scooby, application: application)
    PetApplication.create!(pet: frank, application: application)

    visit "/admin/applications/#{application.id}"

    within "#pets-#{scooby.id}" do
      expect(page).to have_button("Approve")
    end

    within "#pets-#{frank.id}" do
      expect(page).to have_button("Approve")
    end
  end

  it 'every pet on the application has a reject button' do
    application = Application.create!(name: 'Jeremy', street_address: '111 Nonya Ave', city: 'Denver', state: 'CO', zipcode: '80201', description: 'Dogs are rad', status: 'In Progress')
    shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)

    scooby = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
    frank = Pet.create!(name: 'Frank', age: 1, breed: 'Pug', adoptable: true, shelter_id: shelter.id)

    PetApplication.create!(pet: scooby, application: application)
    PetApplication.create!(pet: frank, application: application)

    visit "/admin/applications/#{application.id}"

    within "#pets-#{scooby.id}" do
      expect(page).to have_button("Reject")
    end

    within "#pets-#{frank.id}" do
      expect(page).to have_button("Reject")
    end
  end

  it 'when clicked the approve button it takes the admin to the show page with the pet approved' do
    application = Application.create!(name: 'Jeremy', street_address: '111 Nonya Ave', city: 'Denver', state: 'CO', zipcode: '80201', description: 'Dogs are rad', status: 'In Progress')
    shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)

    scooby = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
    frank = Pet.create!(name: 'Frank', age: 1, breed: 'Pug', adoptable: true, shelter_id: shelter.id)

    PetApplication.create!(pet: scooby, application: application)
    PetApplication.create!(pet: frank, application: application)

    visit "/admin/applications/#{application.id}"

    within "#pets-#{scooby.id}" do
      click_on("Approve")
    end

    expect(current_path).to eq("/applications/#{application.id}")

    within "#pets-#{scooby.id}" do
      expect(page).to have_content("Approved")
      expect(page).to_not have_button("Approve")
      expect(page).to_not have_button("Reject")
    end

    within "#pets-#{frank.id}" do
      expect(page).to have_button("Approve")
      expect(page).to have_button("Reject")
    end
  end

  it 'when clicked the reject button it takes the admin to the show page with the pet approved' do
    application = Application.create!(name: 'Jeremy', street_address: '111 Nonya Ave', city: 'Denver', state: 'CO', zipcode: '80201', description: 'Dogs are rad', status: 'In Progress')
    shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)

    scooby = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
    frank = Pet.create!(name: 'Frank', age: 1, breed: 'Pug', adoptable: true, shelter_id: shelter.id)

    PetApplication.create!(pet: scooby, application: application)
    PetApplication.create!(pet: frank, application: application)

    visit "/admin/applications/#{application.id}"

    within "#pets-#{scooby.id}" do
      click_on("Reject")
    end

    expect(current_path).to eq("/applications/#{application.id}")

    within "#pets-#{scooby.id}" do
      expect(page).to have_content("Rejected")
      expect(page).to_not have_button("Approve")
      expect(page).to_not have_button("Reject")
    end

    within "#pets-#{frank.id}" do
      expect(page).to have_button("Approve")
      expect(page).to have_button("Reject")
    end
  end

  it 'approved or rejected pets do not affect other apps' do
    application = Application.create!(name: 'Jeremy', street_address: '111 Nonya Ave', city: 'Denver', state: 'CO', zipcode: '80201', description: 'Dogs are rad', status: 'In Progress')
    application_2 = Application.create!(name: 'Veronica', street_address: '145 Sad Ave', city: 'Los Angeles ', state: 'CA', zipcode: '90001', description: 'Need Pet Pics for Insta', status: 'In Progress')
    shelter = Shelter.create!(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)

    scooby = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)
    frank = Pet.create!(name: 'Frank', age: 1, breed: 'Pug', adoptable: true, shelter_id: shelter.id)

    PetApplication.create!(pet: scooby, application: application)
    PetApplication.create!(pet: scooby, application: application_2)

    visit "/admin/applications/#{application.id}"

    within "#pets-#{scooby.id}" do
      click_on("Reject")
    end

    expect(current_path).to eq("/applications/#{application.id}")

    within "#pets-#{scooby.id}" do
      expect(page).to have_content("Rejected")
      expect(page).to_not have_button("Approve")
      expect(page).to_not have_button("Reject")
    end

    visit "/admin/applications/#{application_2.id}"

    within "#pets-#{scooby.id}" do
      expect(page).to have_button("Approve")
      expect(page).to have_button("Reject")
    end
  end
end
