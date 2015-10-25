require 'rubygems'
require 'sequel'

def buildSchema!(db)
	db.create_table!(:user) do 
		primary_key :id, :null => false
		String :name, :null => false
		DateTime :created_date, :null => false
		DateTime :modified_date, :null => false
	end
	db.create_table!(:account) do 
		primary_key :id, :null => false
		foreign_key :user_id, :user
		foreign_key :account_type_id, :account_type
		String :name, :null => false
		String :description, :text => true
		DateTime :created_date, :null => false
		DateTime :modified_date, :null => false
	end
	db.create_table!(:transaction) do
		primary_key :id, :null => false
		foreign_key :to_account_id, :account
		foreign_key :from_account_id, :account
		foreign_key :transaction_type_id, :transaction_type
		String :name, :null => false
		String :description, :text => true
		BigDecimal :amount, :null => false
		DateTime :date, :null => false
	end
	db.create_table!(:account_type) do
		primary_key :id, :null => false
		String :account_type, :null => false, :size => 64
	end
	db.create_table!(:transaction_type) do 
		primary_key :id, :null => false
		String :transaction_type, :null => false, :size => 64
	end
end

DB = Sequel.sqlite('data.db')
buildSchema!(DB)
