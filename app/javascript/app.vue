<template>
  <div class="row">
    <hr />
    <div class='col-md-9'>
      <draggable  v-model="lists" :options="{group: 'original_project.lists'}" class="dragArea" @end="listMoved">
        <div v-for='list in original_project.lists' class='col-md-3'>
          <h3>{{ list.name }}</h3>
          <hr />
          <draggable v-model="list.tasks" :options="{group: 'tasks'}" class="dragArea" @end="taskMoved" :id='list.id'>
            <div v-for='task in list.tasks'>
              <div class='border' :id="`task-${task.id}`">
                <h5>{{ task.name }}</h5>
                <button v-on:click="deleteTask(task.id)" class="glyphicon glyphicon-trash"></button>
              </div>
            </div>
          </draggable>
          <button v-on:click="showTaskForm(list.id)" class="btn btn-secondary" v-bind:id="`link-${list.id}`">+ Add another task</button>
          <div v-bind:id="`new-task-${list.id}`" class="none">
            <textarea v-model="messages[list.id]" class="form-control"></textarea>
            <button v-on:click="submitTaskForm(list.id, original_project.id)" class="btn btn-secondary">Save Task</button>
            <button v-on:click="cancelShowForm(list.id)" class="btn btn-secondary">Cancel</button>
          </div>
        </div>
      </draggable>
    </div>
    <div class='col-md-3'>
      <button v-on:click="showListForm" class="btn btn-secondary col-md-12" id="link-list">+ Add another list</button>
      <div id="new-list" class="none">
        <textarea v-model="messages[original_project.id]" class="form-control"></textarea>
        <button v-on:click="submitListForm(original_project.id)" class="btn btn-secondary">Save List</button>
        <button v-on:click="cancelShowListForm" class="btn btn-secondary">Cancel</button>
      </div>
      <hr />
    </div>
  </div>
</template>

<script>
  import draggable from 'vuedraggable'
  export default {
    components: { draggable },
    props: ['original_project'],
    data: function() {
      return {
        messages: {},
        lists: this.original_lists,
      }
    },

    methods: {
      listMoved: function(event) {
        var data = new FormData
        data.append("list[positions]", [event.oldIndex + 1, event.newIndex + 1])
        Rails.ajax({
          url: '/lists/move',
          type: "POST",
          data: data,
          dataType: "json",
        })
      },

      taskMoved: function(event) {
        var data = new FormData
        data.append("task[list]", [event.from["id"], event.to["id"]])
        data.append("task[positions]", [event.oldIndex + 1, event.newIndex + 1])
        Rails.ajax({
          url: '/tasks/move',
          type: "POST",
          data: data,
          dataType: "json",
        })
      },

      deleteTask: function(task_id) {
        $(`#task-${task_id}`).remove()
        Rails.ajax({
          url: `/tasks/${task_id}`,
          type: "DELETE",
          dataType: "json",
        })
      },

      showTaskForm: function(list_id) {
        $(`#new-task-${list_id}`).show()
        $(`#link-${list_id}`).hide()
      },

      cancelShowTaskForm: function(list_id) {
        $(`#new-task-${list_id}`).hide()
        $(`#link-${list_id}`).show()
      },

      submitTaskForm: function(list_id, project_id) {
        var data = new FormData
        data.append('task[list_id]', list_id)
        data.append('task[project_id]', project_id)
        data.append('task[name]', this.messages[list_id])
        Rails.ajax({
          url: '/tasks',
          type: 'POST',
          data: data,
          dataType: 'json'
        })
      },

      submitListForm: function(project_id) {
        var data = new FormData
        data.append('list[project_id]', project_id)
        data.append('list[name]', this.messages[project_id])
        Rails.ajax({
          url: '/lists',
          type: 'POST',
          data: data,
          dataType: 'json'
        })
      },

      showListForm: function(list_id) {
        $("#new-list").show()
        $("#link-list").hide()
      },

      cancelShowListForm: function(list_id) {
        $("#new-list").hide()
        $("#link-list").show()
      },
    }
  }
</script>

<style scoped>
  .dragArea {
    min-height: 10px;
  }

  .none {
    display: none;
  }

  .border {
    border: 1px solid gray;
    border-radius: 5px;
    padding: 10px;
    margin-bottom: 10px;
    display: -webkit-inline-box;
  }

  .glyphicon-trash {
    margin-left: 10px;
  }
</style>
