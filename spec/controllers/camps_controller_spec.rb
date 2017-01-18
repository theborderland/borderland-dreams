require 'rails_helper'
require 'faker'
I18n.reload!

describe CampsController do  
  describe "camp creation" do

    let(:camp_leader) { Faker::Name.name }

    let(:camp_attributes){
      {
        name: 'Burn something',
        subtitle: 'Subtitle',
        description: 'We will build something and then burn it',
        electricity: 'Big enough for a big fire',
        light: 'There sill be need of good ventilation',
        fire: '2 to build and 3 to burn',
        noise: 'The fire consumes everything',
        nature: 'Well - it will burn....',
        contact_email: 'burn@example.com',
        contact_name: camp_leader
      }
    }

    let(:email) { Faker::Internet.email }

    let(:user) { User.create! email: email, password: Faker::Internet.password, ticket_id: '6687' }

    before do
      sign_in user
    end

    it 'got a form' do
      get :new

      expect(response).to have_http_status(:success)
    end

    it 'creates a camp' do
      post :create, camp: camp_attributes

      c = Camp.find_by_contact_name camp_leader

      expect( c.name ).to eq 'Burn something'
    end
  end
end
