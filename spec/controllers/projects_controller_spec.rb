# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'GET #index' do
    let(:projects) { create_list(:project, 2) }

    before { get :index }

    it { expect(assigns(:projects)).to match_array(projects) }
    it { expect(response).to render_template(:index) }
  end

  describe 'GET #show' do
    let(:project) { create(:project) }

    before { get :show, params: { id: project.id } }

    it { expect(assigns(:project)).to eq(project) }
    it { expect(response).to render_template(:show) }
  end
end
