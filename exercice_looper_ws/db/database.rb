# frozen_string_literal: true

require 'mysql2'
require 'dotenv/load'

ENV['MARIADB_TLS_DISABLE_PEER_VERIFICATION'] = '1'

# j'ai trouvé cool du coup je l'ai fait en mode singletoon voici la doc
# https://refactoring.guru/design-patterns/singleton/ruby/example
class Database
  def self.connection
    if @connection.nil? || @connection == false
        @connection = Mysql2::Client.new(
          host: ENV['DB_HOST'],
          username: ENV['DB_USER'],
          password: ENV['DB_PASSWORD'],
          database: ENV['DB_NAME']
        )
    end
    @connection
  end

  def self.close
    @connection&.close
    @connection = nil
  end
end