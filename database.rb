require 'rubygems'
require 'sequel'

def buildSchema!(db)
  db.create_table!(:user) do 
    primary_key :id, :null => false
    String :name, :null => false
    DateTime :created_date, :null => false
    DateTime :modified_date
  end
  db.create_table!(:account) do 
    primary_key :id, :null => false
    foreign_key :user_id, :user
    foreign_key :account_type_id, :account_type
    String :name, :null => false
    String :description, :text => true
    FalseClass :has_debit?, :default => false, :null => false
    DateTime :created_date, :null => false
    DateTime :modified_date
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
    String :account_type, :null => false, :size => 64, :unique => true
  end
  db.create_table!(:transaction_type) do 
    primary_key :id, :null => false
    String :transaction_type, :null => false, :size => 64, :unique => true
  end
end

def buildAccountTypeTable(dataset)
  dataset.insert(:account_type => "Savings")
  dataset.insert(:account_type => "Checking")
  dataset.insert(:account_type => "Credit")
  dataset.insert(:account_type => "Retirement Savings")
  dataset.insert(:account_type => "Income")
  dataset.insert(:account_type => "Spent")
end

def buildTransactionTypeTable(dataset)
  dataset.insert(:transaction_type => "Arts/Entertainment")
  dataset.insert(:transaction_type => "Groceries")
  dataset.insert(:transaction_type => "Utilities/Monthly Payments")
  dataset.insert(:transaction_type => "Merchandise")
  dataset.insert(:transaction_type => "Transportation")
  dataset.insert(:transaction_type => "Restaurant")
  dataset.insert(:transaction_type => "Travel")
  dataset.insert(:transaction_type => "Other")
end


DB = Sequel.sqlite('data.db')
DB.drop_table(:transaction, :account)
buildSchema!(DB)

buildTransactionTypeTable(DB.from(:transaction_type))
buildAccountTypeTable(DB.from(:account_type))

DB.from(:user).insert(name: "John Doe", created_date: Time.now)

DB.from(:account).insert(user_id: 1,
                         account_type_id: 2,
                         name: "My Checking",
                         created_date: Time.now,
                         has_debit?: true)
DB.from(:account).insert(user_id: 1,
                         account_type_id: 1,
                         name: "My Savings",
                         created_date: Time.now)
DB.from(:account).insert(user_id: 1,
                         account_type_id: 3,
                         name: "My Credit",
                         created_date: Time.now)

DB.from(:transaction).insert(to_account_id: 1,
                             from_account_id: 2,
                             transaction_type_id: 8,
                             name: "Initial amount",
                             amount: 4050.43,
                             date: Time.now)



