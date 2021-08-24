require 'rails_helper'

describe 'visitor visit homepage' do
  it 'successfully' do
    visit root_path
    expect(page).to have_content('Bem vindos a PayNow')
    expect(page).to have_content('Somos uma plataforma de pagamento')
    expect(page).to have_content('Organize e gerencie suas vendas')
  end
end
