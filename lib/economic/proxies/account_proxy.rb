require 'economic/proxies/entity_proxy'

module Economic
  class AccountProxy < EntityProxy
    def find_by_name(name)
      response = session.request entity_class.soap_action('FindByName'), {
        'name' => name
      }

      handle = response[:account_handle]

      entity = build(response)
      entity.name = name
      entity.number = handle[:number]
      entity.persisted = true
      entity
    end
  end
end
