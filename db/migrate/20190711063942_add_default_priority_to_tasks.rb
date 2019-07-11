class AddDefaultPriorityToTasks < ActiveRecord::Migration[5.2]
  def up
    change_column_default :tasks, :priority, 0
    change_column_null :tasks, :priority, false, 0
    add_index :tasks, [:priority]
  end
  
  def down
    change_column_default :tasks, :priority, nil
    change_column_null :tasks, :priority, true
    remove_index :tasks, [:priority]
  end
end
