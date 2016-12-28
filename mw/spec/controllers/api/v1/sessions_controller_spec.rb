require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  describe 'POST #create' do
    before :each do
      request.env['devise.mapping'] = Devise.mappings[:user]
    end

    context 'Email or Password is not provided' do
      it 'returns 401' do
        post :create, params: { user: { email: 'kareem@test.com' } }
        expect(response).to have_http_status(401)
      end
    end

    context 'Email or Password is not valid' do
      it 'returns 401' do
        post :create, params: { user: { email: 'test@test.com', password: 'test' } }
        expect(response).to have_http_status(401)
      end
    end

    context 'Email and Password are valid' do
      it 'returns 200 ok' do
        post :create, params: { user: { email: user.email, password: 'test@1234' } }
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).keys).to eq(['authentication_token'])
      end
    end
  end

  describe 'DELTE #destroy' do
    before :each do
      request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
    end

    it 'deletes the last authentication_token token' do
      delete :destroy
      expect(response).to have_http_status(200)
    end
  end
end
