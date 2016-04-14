require 'rails_helper'


RSpec.describe Users::SessionsController, type: :controller do

  include Devise::TestHelpers

  describe 'POST /users/sign_in' do

    let(:json) { JSON.parse(response.body) }
    let(:user) { create(:user) }
    let(:valid_user_attributes) { attributes_for(:user) }

    before do
      user
      request.env['devise.mapping'] = Devise.mappings[:user]
    end

    it 'accepts valid credentials' do
      post :create, user: valid_user_attributes, format: :json
      expect(json["success"]).to be true
      expect(response.status).to eq(200)
      expect(json["auth_token"]).to_not be nil
    end




  end

end