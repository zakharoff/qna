require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do

  given!(:user) { create :user }
  given!(:question) { create :question, author: user }

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user as author', js: true do
    given!(:url) { 'http://ya.ru' }

    background do
      sign_in user
      visit question_path(question)

      click_on 'Edit question'
    end

    scenario 'edit his question' do
      within '.question' do
        fill_in 'Title', with: 'edited title'
        fill_in 'Body', with: 'edited body'
        click_on 'Save question'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited title'
        expect(page).to_not have_selector "#edit-question-#{question.id}"
      end
    end

    scenario 'edit his question with errors' do
      within '.question' do
        fill_in 'Title', with: ''
        click_on 'Save question'

        expect(page).to have_content question.title
      end

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'edit for add attached files' do
      within '.question' do
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save question'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edit for add link' do
      within '.question' do
        click_on 'Add link'

        fill_in 'Link name', with: 'My href'
        fill_in 'Url', with: url

        click_on 'Save question'

        expect(page).to have_link 'My href', href: url
      end
    end
  end

  describe 'Authenticated user as not author', js: true do
    given(:user2) { create :user }

    scenario "tries to edit other user's question" do
      sign_in user2
      visit question_path(question)

      expect(page).to_not have_link 'Edit question'
    end
  end
end
