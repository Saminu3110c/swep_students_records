class CreateStudents < ActiveRecord::Migration[7.2]
  def change
    create_table :students do |t|
      t.string :matric_no
      t.string :name
      t.string :department
      t.string :level
      t.string :session
      t.integer :ca
      t.integer :exam
      t.integer :total

      t.timestamps
    end
  end
end
