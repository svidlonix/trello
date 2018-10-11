# frozen_string_literal: true

class ChangePositionTask < SmartInit::Base
  initialize_with_keywords :from_list_id, :to_list_id, :old_position, :new_position
  is_callable

  def call
    if to_list_id == from_list_id
      the_same_list(old_position, new_position, to_list_id)
    else
      another_list(old_position, new_position, from_list_id, to_list_id)
    end
  end

  private

  def decrement_positions_old_list(old_position, list_id)
    positio_last_task = positio_last_task(list_id)
    decrement_positions(old_position, positio_last_task, list_id) if positio_last_task
  end

  def increment_positions_new_list(new_position, list_id)
    positio_last_task = positio_last_task(list_id)
    increment_positions(positio_last_task + 1, new_position, list_id) if positio_last_task
  end

  def decrement_positions(old_position, new_position, list_id)
    array_positions = ((old_position + 1)..new_position).to_a
    change_positions(array_positions, -1, list_id)
  end

  def increment_positions(old_position, new_position, list_id)
    array_positions = (new_position...old_position).to_a
    change_positions(array_positions, +1, list_id)
  end

  def change_positions(array_positions, value, list_id)
    array_positions.each do |position|
      Task.find_by(position: position, list_id: list_id).update_attribute(:position, position + value)
    end
  end

  def positio_last_task(list_id)
    List.find_by(id: list_id).tasks&.last&.position
  end

  def the_same_list(old_position, new_position, to_list_id)
    Task.find_by(position: old_position, list_id: to_list_id).update_attributes(position: new_position)

    if new_position > old_position
      decrement_positions(old_position, new_position, to_list_id)
    else
      increment_positions(old_position, new_position, to_list_id)
    end
  end

  def another_list(old_position, new_position, from_list_id, to_list_id)
    increment_positions_new_list(new_position, to_list_id)

    task = Task.find_by(position: old_position, list_id: from_list_id)
    task.update_attributes(position: new_position, list_id: to_list_id)

    decrement_positions_old_list(old_position, from_list_id)
  end
end
