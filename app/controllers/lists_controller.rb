# frozen_string_literal: true

class ListsController < ApplicationController
  before_action :set_list, only: [:destroy]

  def create
    List.create(list_params.merge(user_id: current_user.id))
    redirect_to project_path(params[:list][:project_id])
  end

  def move
    old_position, new_position = params[:list][:positions].split(',').map(&:to_i)
    List.find_by(position: old_position).update_attribute(:position, new_position)

    if new_position > old_position
      decrement_positions(old_position, new_position)
    else
      increment_positions(old_position, new_position)
    end
  end

  private

  def set_list
    @list = List.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:name, :project_id)
  end

  def decrement_positions(old_position, new_position)
    array_positions = ((old_position + 1)..new_position).to_a
    change_positions(array_positions, -1)
  end

  def increment_positions(old_position, new_position)
    array_positions = (new_position...old_position).to_a
    change_positions(array_positions, +1)
  end

  def change_positions(array_positions, value)
    array_positions.each do |position|
      List.find_by(position: position).update_attribute(:position, position + value)
    end
  end
end
