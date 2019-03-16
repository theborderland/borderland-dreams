require 'rails_helper'
require 'faker'
I18n.reload!

describe CampsController do
  let(:email) { Faker::Internet.email }
  let(:user) { User.create! email: email, password: Faker::Internet.password, ticket_id: '6687' }
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

  describe "camp creation" do
    before do
      sign_in user
    end

    it 'got a form' do
      get :new

      expect(response).to have_http_status(:success)
    end

    it 'creates a camp' do
      post :create, params: { camp: camp_attributes }

      c = Camp.find_by_contact_name camp_leader

      expect( c.name ).to eq 'Burn something'
    end
  end

  context 'update permissions' do
    let!(:camp) { Camp.create!(camp_attributes.merge(creator: user)) }

    shared_examples_for 'should fail' do
      it 'should not succeed updating' do
        post :update, params: { camp: camp_attributes, id: camp.id }

        expect(flash[:alert]).to_not be_nil
      end
    end

    shared_examples_for 'should succeed' do
      it 'should succeed updating' do
        post :update, params: { camp: camp_attributes, id: camp.id }

        expect(flash[:alert]).to be_nil
        expect(flash[:notice]).to be_nil
      end
    end

    describe 'not logged in' do
      it_behaves_like 'should fail'
    end

    context 'logged in' do
      let(:guide) { false }
      let(:admin) { false }
      let(:current_user) {
        User.create!(email: 'mr@robot.me', password: 'badpassword', guide: guide, admin: admin)
      }

      before :each do
        sign_in current_user
      end

      context 'another user' do
        it_behaves_like 'should fail'
      end

      context 'dream owner' do
        let(:current_user) { user }
        it_behaves_like 'should succeed'
      end

      context 'guide' do
        let(:guide) { true }
        it_behaves_like 'should succeed'
      end

      context 'admin' do
        let(:admin) { true }
        it_behaves_like 'should succeed'
      end
    end
  end

  describe '#update_grants' do
    let!(:camp) { Camp.create!(camp_attributes.merge(creator: user)) }

    before do
      sign_in user
      camp.update!(maxbudget_realcurrency: 80, minbudget_realcurrency: 50)
    end

    it 'should transfer grants' do
      expect { patch :update_grants, params: { id: camp.id, grants: 3 } }.to change { Grant.count }.by(1)
      expect(user.reload.grants).to eq 7
      expect(camp.reload.grants_received).to eq 3
      expect(Grant.exists?(camp: camp, user: user))
    end

    it 'should transfer grants' do
      expect { patch :update_grants, params: { id: camp.id, grants: 10 } }.to change { Grant.count }.by(1)
      expect(user.reload.grants).to eq 2
      expect(camp.reload.grants_received).to eq camp.maxbudget
      expect(camp.fullyfunded).to eq true
      expect(Grant.exists?(camp: camp, user: user))
      expect(Grant.last.amount).to eq camp.maxbudget
    end

    it 'should not transfer grants if the user does not have enough' do
      user.update(grants: 2)
      expect { patch :update_grants, params: { id: camp.id, grants: 3 } }.to_not change { Grant.count }
      expect(flash[:alert]).to be_present
    end

    it 'should not transfer grants if no max budget is given' do
      camp.update(maxbudget_realcurrency: nil)
      expect { patch :update_grants, params: { id: camp.id, grants: 3 } }.to_not change { Grant.count }
      expect(flash[:alert]).to be_present
    end

    it 'should not transfer grants if no grants are given' do
      expect { patch :update_grants, params: { id: camp.id, grants: 0 } }.to_not change { Grant.count }
      expect(flash[:alert]).to be_present
    end

    it 'should not transfer grants if too many grants are given' do
      Rails.application.config.x.firestarter_settings["max_grants_per_user_per_dream"] = 7
      Grant.create!(user: user, camp: camp, amount: 7)
      expect { patch :update_grants, params: { id: camp.id, grants: 4 } }.to_not change { Grant.count }
      expect(flash[:alert]).to be_present
      Rails.application.config.x.firestarter_settings["max_grants_per_user_per_dream"] = 10
    end

    it 'should allow admins to give any amount of grants' do

    end
  end
end
