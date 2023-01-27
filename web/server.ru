require 'sinatra'
require 'pg'
require 'redis'
require 'ddtrace'

Datadog.configure do |c|
  c.tracing.instrument :sinatra
end

class Fib
  def self.call(n)
    n < 2 ? n : call(n - 1) + call(n - 2)
  end
end

get '/fib/:value' do
  Fib.call(params[:value].to_i)

  'Ok'
end

get '/bank/report_slow.json' do
  content_type 'application/json'

  connection = PG.connect(host: 'postgres',
                          user: 'postgres',
                          password: 'postgres',
                          dbname: 'postgres')

  sql = File.read('bank/sql/transfers.sql') # 400ms
  result = connection.exec(sql).to_a

  ## 4k accounts
  users = result.map do |row|
    user_id = row["user_id"]
    query = "SELECT users.name AS name FROM users WHERE users.id = #{user_id}" # 100ms
    user = connection.exec(query).to_a.first

    bank_id = row["bank_id"]
    query = "SELECT banks.name AS name FROM banks WHERE banks.id = #{bank_id}" # 100ms
    bank = connection.exec(query).to_a.first

    {
      user: user["name"],
      bank: bank["name"],
      balance: row["balance"]
    }
  end

  connection.close

  users.to_json
end

get '/bank/report_slow_cache.json' do
  content_type 'application/json'

  redis = Redis.new(host: 'redis')
  cache = redis.get('report:cache')

  if cache.nil?
    connection = PG.connect(host: 'postgres',
                            user: 'postgres',
                            password: 'postgres',
                            dbname: 'postgres')

    sql = File.read('bank/sql/transfers.sql') # 400ms
    result = connection.exec(sql).to_a

    ## 4k accounts
    users = result.map do |row|
      user_id = row["user_id"]
      query = "SELECT users.name AS name FROM users WHERE users.id = #{user_id}" # 100ms
      user = connection.exec(query).to_a.first

      bank_id = row["bank_id"]
      query = "SELECT banks.name AS name FROM banks WHERE banks.id = #{bank_id}" # 100ms
      bank = connection.exec(query).to_a.first

      {
        user: user["name"],
        bank: bank["name"],
        balance: row["balance"]
      }
    end

    redis.set('report:cache', users.to_json, ex: 15)
    cache = redis.get('report:cache')

    connection.close
  end

  cache
end

get '/bank/invalidate_report_cache' do
  redis = Redis.new(host: 'redis')
  redis.del('report:cache')

  'OK'
end

get '/bank/report_fast.json' do
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

get '/bank/report_slow_http_cache.json' do
  content_type 'application/json'

  connection = PG.connect(host: 'postgres',
                          user: 'postgres',
                          password: 'postgres',
                          dbname: 'postgres')

  sql = File.read('bank/sql/transfers.sql') # 400ms
  result = connection.exec(sql).to_a

  ## 4k accounts
  users = result.map do |row|
    user_id = row["user_id"]
    query = "SELECT users.name AS name FROM users WHERE users.id = #{user_id}" # 100ms
    user = connection.exec(query).to_a.first

    bank_id = row["bank_id"]
    query = "SELECT banks.name AS name FROM banks WHERE banks.id = #{bank_id}" # 100ms
    bank = connection.exec(query).to_a.first

    {
      user: user["name"],
      bank: bank["name"],
      balance: row["balance"]
    }
  end

  connection.close

  headers 'Cache-Control' => 'max-age=20'

  users.to_json
end

get '/bank' do
  content_type 'text/html'

  "<a href=\"/bank/report_slow_http_cache.json\">Report</a>"
end

run Sinatra::Application
