# Dependencies
require 'time'
require 'savon'

require 'economic/support/string'
require 'economic/session'

require 'economic/debtor'
require 'economic/debtor_contact'
require 'economic/creditor'
require 'economic/creditor_contact'
require 'economic/current_invoice'
require 'economic/current_invoice_line'
require 'economic/invoice'
require 'economic/cash_book'
require 'economic/cash_book_entry'
require 'economic/account'
require 'economic/debtor_entry'
require 'economic/creditor_entry'
require 'economic/entry'

require 'economic/proxies/current_invoice_proxy'
require 'economic/proxies/current_invoice_line_proxy'
require 'economic/proxies/debtor_proxy'
require 'economic/proxies/debtor_contact_proxy'
require 'economic/proxies/creditor_proxy'
require 'economic/proxies/creditor_contact_proxy'
require 'economic/proxies/invoice_proxy'
require 'economic/proxies/cash_book_proxy'
require 'economic/proxies/cash_book_entry_proxy'
require 'economic/proxies/account_proxy'
require 'economic/proxies/debtor_entry_proxy'
require 'economic/proxies/creditor_entry_proxy'
require 'economic/proxies/entry_proxy'

require 'economic/proxies/actions/find_by_name'

# http://www.e-conomic.com/apidocs/Documentation/index.html
# https://www.e-conomic.com/secure/api1/EconomicWebService.asmx
#
# TODO
#
# * Basic validations; ie check for nil values before submitting to API

module Economic
  # Configures global settings for Economic
  #   Economic.configure do |config|
  #     config.agreement = 'agreement'
  #     config.user_id = 'user_id'
  #     config.password = 'password'
  #   end
  def self.configure(&block)
    yield @config ||= Configuration.new
    raise 'Please provide agreement, user_id and password' unless %w{agreement user_id password}.all? { |attr| @config.send(attr.to_sym).present? }
  end

  def self.config
    @config
  end

  def self.client
    @client ||= Session.new(self.config.agreement, self.config.user_id, self.config.password)
    @client.connect
    @client
  end

  class Configuration
    attr_accessor :agreement, :user_id, :password
  end
end

