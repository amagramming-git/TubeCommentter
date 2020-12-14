#6章
class AddIndexToUsersEmail < ActiveRecord::Migration[5.2]
  def change
    #indexを追加し、一意性をTrueにする。
    add_index :users, :email, unique: true
  end
end
