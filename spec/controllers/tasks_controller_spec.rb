# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project) }
  let!(:list1) { create(:list, project_id: project.id) }
  let!(:list2) { create(:list, project_id: project.id) }

  before { sign_in(user) }

  describe 'POST #create' do
    let(:task_attributes) { attributes_for(:task).merge(project_id: project.id, list_id: list1) }

    subject { post :create, params: { task: task_attributes }, format: :json }

    it { expect { subject }.to change(Task, :count).by(1) }

    it 'check attributes value' do
      subject
      expect(Task.last.name).to eq(task_attributes[:name])
      expect(Task.last.position).to eq(1)
      expect(Task.last.project_id).to eq(project.id)
      expect(Task.last.list_id).to eq(list1.id)
    end
  end

  describe 'POST #move' do
    let!(:task1) { create(:task, project_id: project.id, list_id: list1.id) }
    let!(:task2) { create(:task, project_id: project.id, list_id: list1.id) }
    let!(:task3) { create(:task, project_id: project.id, list_id: list1.id) }
    let!(:task4) { create(:task, project_id: project.id, list_id: list1.id) }
    let!(:task5) { create(:task, project_id: project.id, list_id: list1.id) }

    before do
      post :move, params: { task: { positions: positions, list: list } }
      task1.reload
      task2.reload
      task3.reload
      task4.reload
      task5.reload
    end

    context 'when the same list' do
      let(:list) { "#{list1.id},#{list1.id}" }

      context 'when change place first task to last' do
        let(:positions) { '1,5' }

        it { expect(task1.position).to eq(5) }
        it { expect(task5.position).to eq(4) }
        it { expect(task4.position).to eq(3) }
        it { expect(task3.position).to eq(2) }
        it { expect(task2.position).to eq(1) }
      end

      context 'when change place last task to first' do
        let(:positions) { '5,1' }

        it { expect(task5.position).to eq(1) }
        it { expect(task4.position).to eq(5) }
        it { expect(task3.position).to eq(4) }
        it { expect(task2.position).to eq(3) }
        it { expect(task1.position).to eq(2) }
      end

      context 'when place not changed' do
        let(:positions) { '1,1' }

        it { expect(task5.position).to eq(5) }
        it { expect(task4.position).to eq(4) }
        it { expect(task3.position).to eq(3) }
        it { expect(task2.position).to eq(2) }
        it { expect(task1.position).to eq(1) }
      end
    end

    context 'when another list' do
      let(:list) { "#{list1.id},#{list2.id}" }

      context 'when change place first task to another list' do
        let(:positions) { '1,1' }

        it { expect(task1.position).to eq(1) }
        it { expect(task1.list_id).to eq(list2.id) }
        it { expect(task5.position).to eq(4) }
        it { expect(task4.position).to eq(3) }
        it { expect(task3.position).to eq(2) }
        it { expect(task2.position).to eq(1) }
      end

      context 'when change place last task to to another list' do
        let(:positions) { '5,1' }

        it { expect(task5.position).to eq(1) }
        it { expect(task5.list_id).to eq(list2.id) }
        it { expect(task4.position).to eq(4) }
        it { expect(task3.position).to eq(3) }
        it { expect(task2.position).to eq(2) }
        it { expect(task1.position).to eq(1) }
      end

      context 'when turn task on first place from another list' do
        let!(:task1) { create(:task, project_id: project.id, list_id: list2.id) }
        let!(:list) { "#{list2.id},#{list1.id}" }
        let!(:positions) { '1,1' }

        it { expect(task5.position).to eq(5) }
        it { expect(task4.position).to eq(4) }
        it { expect(task3.position).to eq(3) }
        it { expect(task2.position).to eq(2) }
        it { expect(task1.position).to eq(1) }
        it { expect(task1.list_id).to eq(list1.id) }
      end

      context 'when turn task on дфые place from another list' do
        let!(:task1) { create(:task, project_id: project.id, list_id: list2.id) }
        let!(:list) { "#{list2.id},#{list1.id}" }
        let!(:positions) { '1,5' }

        it { expect(task5.position).to eq(4) }
        it { expect(task4.position).to eq(3) }
        it { expect(task3.position).to eq(2) }
        it { expect(task2.position).to eq(1) }
        it { expect(task1.position).to eq(5) }
        it { expect(task1.list_id).to eq(list1.id) }
      end
    end
  end
end
