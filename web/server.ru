require 'sinatra'
require 'pg'

get '/bank/report.json' do
  content_type 'application/json'

  connection = PG.connect(host: 'postgres',
                          user: 'postgres',
                          password: 'postgres',
                          dbname: 'postgres')

  sql = File.read('bank/sql/report.sql')
  result = connection.exec(sql).to_a

  connection.close

  result.to_json
end

run Sinatra::Application
