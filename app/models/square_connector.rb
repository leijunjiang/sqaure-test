class SquareConnector < ApplicationRecord

  def authenticate!
    begin
      RestClient.get url
    rescue Exception => e
      raise "ERROR, Authentication Square failed"
    end

  end


  def url
    "#{connect_host}/oauth2/authorize?client_id=#{client_id}"
  end

  def connect_host
    "https://connect.squareupsandbox.com"
  end
end
