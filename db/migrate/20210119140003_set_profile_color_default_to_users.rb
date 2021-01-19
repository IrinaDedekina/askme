class SetProfileColorDefaultToUsers < ActiveRecord::Migration[6.0]
  def up
    change_table :users do |t|
      t.change :profile_color, :string, default: "#005a55"
    end
  end

  def down
    change_table :users do |t|
      t.change :profile_color, :string
    end
  end
end
