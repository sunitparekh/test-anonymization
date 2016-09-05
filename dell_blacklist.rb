
require 'data-anonymization'

DataAnon::Utils::Logging.logger.level = Logger::INFO

connection_spec = {:adapter => 'postgresql', :host => 'localhost', :port => 5432, :pool => 5, :username => 'developer', :password => 'password', :database => 'dell'}

database 'DellStore' do
  strategy DataAnon::Strategy::Blacklist
  source_db({:adapter => 'postgresql', :host => 'localhost', :port => 5432, :pool => 5, :username => 'developer', :password => 'password', :database => 'dell'})

  table 'customers' do
    primary_key 'customerid'

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

end

