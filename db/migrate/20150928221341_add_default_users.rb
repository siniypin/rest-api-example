class AddDefaultUsers < ActiveRecord::Migration
  def up
    self.connection.execute "INSERT INTO users (role, name, password_digest) VALUES ('admin', 'admin', '#{BCrypt::Password.create('Adm1n', cost: BCrypt::Engine::MIN_COST)}')"
    self.connection.execute "INSERT INTO users (role, name, password_digest) VALUES ('user', 'user', '#{BCrypt::Password.create('Us3r', cost: BCrypt::Engine::MIN_COST)}')"
    self.connection.execute "INSERT INTO users (role, name, password_digest) VALUES ('guest', 'guest', '#{BCrypt::Password.create('Gue8t', cost: BCrypt::Engine::MIN_COST)}')"
  end

  def down
    self.connection.execute 'DELETE from users'
  end
end
