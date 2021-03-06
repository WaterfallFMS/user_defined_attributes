require 'spec_helper'

feature 'Fields' do
  before do
    @udat = create :user_defined_field_type, name: 'Uda', hidden: false, data_type: 'string'
  end

  scenario 'can be edited on the object' do
    visit '/'
    click_link 'Leads'
    click_link 'Create new lead'
    
    fill_in 'Name', with: 'My lead'
    fill_in @udat.name, with: 'My value'
    click_button 'Create Lead'

    expect(page).to have_content @udat.name
    expect(page).to have_content 'My value'
    
    click_link 'Edit'
    expect(find_field(@udat.name).value).to eq 'My value'
    
    fill_in @udat.name, with: '-'*256
    click_button 'Update Lead'
    expect(page).to have_content 'too long'

    fill_in @udat.name, with: 'New value'
    click_button 'Update Lead'

    expect(page).to have_content 'New value'
    expect(page).not_to have_content 'My value'
  end
end