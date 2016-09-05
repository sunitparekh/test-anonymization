require 'data-anonymization'

DataAnon::Utils::Logging.logger.level = Logger::INFO

connection_spec = {:adapter => 'postgresql', :host => 'localhost', :port => 5432, :pool => 5, :username => 'developer', :password => 'password', :database => 'dell'}

database 'DellStore' do
  strategy DataAnon::Strategy::Whitelist
  source_db :adapter => 'postgresql', :host => 'localhost', :port => 5432, :pool => 5, :username => 'developer', :password => 'password', :database => 'dell'
  destination_db :adapter => 'postgresql', :host => 'localhost', :port => 5432, :pool => 5, :username => 'developer', :password => 'password', :database => 'dell_empty'

  table 'categories' do
    primary_key 'category'
    whitelist 'category','categoryname'
  end

  table 'products' do
    primary_key 'prod_id'
    whitelist 'prod_id','category','title','actor','price','special','common_prod_id'
  end

  table 'inventory' do
    primary_key 'prod_id'
    whitelist 'prod_id','quan_in_stock','sales'
  end

  table 'reorder' do
    primary_key 'prod_id'
    whitelist 'prod_id','date_low','quan_low','date_reordered','quan_reordered','date_expected'
  end

  table 'customers' do
    primary_key 'customerid'

    whitelist 'customerid', 'income', 'city', 'country', 'region', 'creditcardexpiration'
    anonymize('firstname').using FieldStrategy::RandomString.new
    anonymize('lastname').using FieldStrategy::RandomLastName.new
    anonymize('address1').using FieldStrategy::RandomAddress.region_US
    anonymize('address2').using FieldStrategy::RandomString.new
    anonymize('state').using FieldStrategy::SelectFromDatabase.new("customers","state", connection_spec)
    anonymize('zip').using FieldStrategy::RandomZipcode.region_US
    anonymize('email').using FieldStrategy::RandomMailinatorEmail.new
    anonymize('phone').using FieldStrategy::RandomPhoneNumber.new
    anonymize('creditcardtype').using FieldStrategy::SelectFromDatabase.new("customers","creditcardtype", connection_spec)
    anonymize('creditcard').using FieldStrategy::RandomPhoneNumber.new
    anonymize('username').using FieldStrategy::StringTemplate.new('user#{row_number}')
    anonymize('password') { |f| 'password'}
    anonymize('age')
    anonymize('gender').using FieldStrategy::SelectFromList.new(['M','F'])
  end

  table 'orders' do
    primary_key 'orderid'
    whitelist 'orderid','orderdate','customerid','netamount','tax','totalamount'
  end

  table 'orderlines' do
    primary_key 'orderlineid','orderid'
    whitelist 'orderlineid','orderid','prod_id','quantity','orderdate'
  end

  table 'cust_hist' do
    primary_key 'customerid','orderid','prod_id'
    whitelist 'customerid','orderid','prod_id'
  end


end

