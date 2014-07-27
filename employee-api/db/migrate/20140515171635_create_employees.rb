class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :first_name
      t.string :last_name
      t.string :job_title
      t.string :email
      t.string :office_phone

      t.timestamps
    end
  end
end
