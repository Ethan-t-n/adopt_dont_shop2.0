require 'rails_helper'

RSpec.describe 'the application new page' do
    describe 'the application new page' do
        it "has a link on the pet index to make an application" do
            visit "/pets"

            click_on('Start an Application')

            expect(current_path).to eq('/applications/new')
        end

        it 'makes new form' do
            visit '/applications/new'

            expect(page).to have_content('New Application')
            expect(find('form')).to have_content('Name')
            expect(find('form')).to have_content('Street Address')
            expect(find('form')).to have_content('City')
            expect(find('form')).to have_content('State')
            expect(find('form')).to have_content('Zip Code')
        end
end
    describe 'Application creation' do
        it 'Application create with correct data' do
            visit '/applications/new'

            fill_in('name', with: 'Bobbert')
            fill_in('street_address', with: '142 something st')
            fill_in('city', with: 'Littleton')
            fill_in('state', with: 'CO')
            fill_in('zipcode', with: '80124')

            click_on('Submit')
            application = Application.last

            expect(current_path).to eq("/applications/#{application.id}")
            expect(page).to have_content('Bobbert')
            expect(page).to have_content('142 something st')
            expect(page).to have_content('Littleton')
            expect(page).to have_content('CO')
            expect(page).to have_content('80124')
            expect(page).to have_content('Description Needed')
            expect(page).to have_content('In Progress')
        end

        it 'gives warning for wrong data' do
            visit '/applications/new'

            click_on('Submit')

            expect(current_path).to eq('/applications/new')
            expect(page).to have_content("Error: Name can't be blank, Street address can't be blank, City can't be blank, State can't be blank, Zipcode can't be blank")
        end
    end
end
