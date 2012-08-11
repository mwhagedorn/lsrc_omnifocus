#!/usr/local/bin/macruby
framework 'Foundation'
framework 'ScriptingBridge'

require "hp_object_storage"
require "s_b_element"
require "json"


class OmniFocusToDos
  # To change this template use File | Settings | File Templates.
  def initialize(project)
    @of  = SBApplication.applicationWithBundleIdentifier("com.omnigroup.Omnifocus")
    load_bridge_support_file 'Omnifocus.bridgesupport'
    @doc = @of.defaultDocument
    @project = @doc.projects[project]
    @swift = HPObjectStorage.new
  end

  def task_list
    tasks = []
    @doc.flattenedTasks.get.each do |task|
      if task.respond_to?(:containingProject)
        if task.containingProject.get && task.containingProject.get.name == @project.name
          unless task.completed
           tasks << task
          end
        end
      end
    end
    tasks
  end

  def formatted_task_list
    tasks = task_list
    todos = {}
    todo_list = []
    todos[:day]=Time.now.strftime("%a %b %e")
    tasks.each do |task|
       todo_list << {:title=>task.name, :due_date=>task.dueDate.get}
    end
    todos[:task_list] = todo_list
    todos.to_json
  end

  def save_todos
      @swift.update_tasks_file(formatted_task_list)
  end


end

