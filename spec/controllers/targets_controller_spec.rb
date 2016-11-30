require 'rails_helper'
require 'spec_helper'

describe Api::V1::TargetsController do

  describe 'index action' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'show action' do

    it 'returns http success' do
      target = create(:target)
      get :show, id: target.id
      expect(response.body).to look_like_json
      expect(response).to have_http_status(:success)
    end

    it 'returns status 404 if target is not found' do
      get :show, id: 0
      expect(response).to have_http_status(404)
    end

  end

  describe 'create action' do

    it 'returns status created if target saved to database' do
      expect{
        post :create, target: { target_url: 'http://google.com'}
      }.to change(Target, :count).by(1)
    end

    it 'returns status created if content saved to database' do
      before_count = Content.count
      post :create, target: { target_url: 'http://google.com'}
      expect(Content.count).not_to eq(before_count)
    end

    it 'returns status created if target url is valid' do
      post :create, target: { target_url: 'http://google.com'}
      expect(response).to have_http_status(:created)
    end

    it 'returns status unprocessable entity if target url is invalid' do
      post :create, target: { target_url: nil}
      expect(response).to have_http_status(:unprocessable_entity)
    end

  end

  describe 'delete action' do

    it 'returns status no_content if target deleted' do
      target = create(:target)
      delete :destroy, id: target.id
      expect(response).to have_http_status(:no_content)
    end

    it 'returns status 404 if target is not found' do
      delete :destroy, id: 0
      expect(response).to have_http_status(404)
    end

  end

end