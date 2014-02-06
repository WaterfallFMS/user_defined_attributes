require 'spec_helper'

feature 'UDA type' do
  scenario 'can be edited in app' do
    visit '/'
    click_link 'UDA'
    click_link 'Create new type'

    fill_in 'Name', with: 'Test'
    fill_in 'Model type', with: 'Lead'
    click_button 'Create Field type'

    expect(page).to have_content 'Test'

    click_link 'Edit'
    fill_in 'Name', with: 'New UDA'
    click_button 'Update Field type'

    expect(page).to have_content 'New UDA'
    expect(page).not_to have_content 'Test'

    click_link 'Delete'
    expect(page).not_to have_content 'New UDA'
  end
end