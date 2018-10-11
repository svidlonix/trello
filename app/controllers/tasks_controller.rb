# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: :destroy

  def create
    Task.create(task_params.merge(user_id: current_user.id)) unless params[:task][:name] == 'undefined'
    redirect_to project_path(params[:task][:project_id])
  end

  def destroy
    @task.destroy
  end

  def move
    from_list_id, to_list_id = params[:task][:list].split(',').map(&:to_i)
    old_position, new_position = params[:task][:positions].split(',').map(&:to_i)

    ChangePositionTask.call(
      from_list_id: from_list_id,
      to_list_id:   to_list_id,
      old_position: old_position,
      new_position: new_position
    )
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :project_id, :list_id)
  end
end
