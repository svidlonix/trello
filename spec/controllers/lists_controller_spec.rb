# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ListsController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project) }

  before { sign_in(user) }

  describe 'POST #create' do
    let(:list_attributes) { attributes_for(:list).merge(project_id: project.id) }

    subject { post :create, params: { list: list_attributes }, format: :json }

    it { expect { subject }.to change(List, :count).by(1) }

    it 'check attributes value' do
      subject
      expect(List.last.name).to eq(list_attributes[:name])
      expect(List.last.position).to eq(1)
      expect(List.last.project_id).to eq(project.id)
    end
  end

  describe 'POST #move' do
    let!(:list1) { create(:list, project_id: project.id) }
    let!(:list2) { create(:list, project_id: project.id) }
    let!(:list3) { create(:list, project_id: project.id) }
    let!(:list4) { create(:list, project_id: project.id) }
    let!(:list5) { create(:list, project_id: project.id) }

    before do
      post :move, params: { list: positions }
      list1.reload
      list2.reload
      list3.reload
      list4.reload
      list5.reload
    end

    context 'when change place first list to last' do
      let(:positions) { { positions: '1,5' } }

      it { expect(list1.position).to eq(5) }
      it { expect(list5.position).to eq(4) }
      it { expect(list4.position).to eq(3) }
      it { expect(list3.position).to eq(2) }
      it { expect(list2.position).to eq(1) }
    end

    context 'when change place last list to first' do
      let(:positions) { { positions: '5,1' } }

      it { expect(list5.position).to eq(1) }
      it { expect(list4.position).to eq(5) }
      it { expect(list3.position).to eq(4) }
      it { expect(list2.position).to eq(3) }
      it { expect(list1.position).to eq(2) }
    end

    context 'when place not changed' do
      let(:positions) { { positions: '1,1' } }

      it { expect(list5.position).to eq(5) }
      it { expect(list4.position).to eq(4) }
      it { expect(list3.position).to eq(3) }
      it { expect(list2.position).to eq(2) }
      it { expect(list1.position).to eq(1) }
    end
  end
end
