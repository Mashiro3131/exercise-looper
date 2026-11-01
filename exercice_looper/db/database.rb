# frozen_string_literal: true

require 'mysql2'
require 'dotenv/load'

ENV["MARIADB_TLS_DISABLE_PEER_VERIFICATION"] = "1"

class Database
  def self.connection
    @connection ||= Mysql2::Client.new(
      host: ENV.fetch("DB_HOST"),
      username: ENV.fetch("DB_USER"),
      password: ENV.fetch("DB_PASSWORD"),
      database: ENV.fetch("DB_NAME")
    )
  end

  def self.close
    @connection&.close
    @connection = nil
  end
end