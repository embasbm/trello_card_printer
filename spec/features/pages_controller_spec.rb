require 'rails_helper'

describe 'index page', type: :feature do
  describe '#index page' do
    before do
      visit '/'
    end
    it 'should have label & text area' do
      expect(page).to have_content("Ticket card:")
      expect(page).to have_css("textarea#q")
    end

    context 'When filling the form with tasks url from trello' do
      it 'should show card data' do
        VCR.use_cassette 'trello/api_response' do
          within('.search_form') do
            fill_in 'Ticket card', with: 'https://trello.com/c/uuVT2tNZ/1-task-1
            https://trello.com/c/rFeY74R8/2-task-2'
            click_button 'Search'
          end
        end
        expect(page).to have_content("Task 1")
        expect(page).to have_content("Task 2")

        expect(page).to have_content("Foo Bar")
      end
    end
  end
end
