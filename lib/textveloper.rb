require "textveloper/version"

module Textveloper

  class Sdk

    def initialize(account_token_number, subaccount_token_number)
      @account_token_number = account_token_number
      @subaccount_token_number = subaccount_token_number
    end

    def api_actions
      {
      :enviar => 'enviar',
      :puntos_cuenta => 'saldo-cuenta',
      :puntos_subcuenta => 'saldo-subcuenta',
      :compras => 'historial-compras',
      :envios => 'historial-envios',
      }
    end

    def send_sms(number,message)
      response = []
      data = {
        :cuenta_token => @account_token_number,
        :subcuenta_token => @subaccount_token_number,
        :telefono => number,
        :mensaje => message
      }
      response << Curl.post(url + api_actions[:enviar] + '/', data ).body_str 
      show_format_response([number],response)
    end

    def subaccount_balance
      data = {
        :cuenta_token => @account_token_number,
        :subcuenta_token => @subaccount_token_number
      }
      Curl.get(url + api_actions[:puntos_subcuenta] + '/', data)
    end

    def mass_messages(numbers, message)
      response = []
      numbers.each do |number|
        data = {
        :cuenta_token => @account_token_number,
        :subcuenta_token => @subaccount_token_number,
        :telefono => number,
        :mensaje => message
        }
        response << Curl.post(url + api_actions[:enviar] + '/', data ).body_str
      end
      show_format_response(numbers,response)
    end
    
    def show_format_response(numbers,response)
      data = {}
      hash_constructor(numbers,response, data)        
    end

    def hash_constructor(numbers,response, data)
      numbers.each_with_index do |number, index|
        data[number.to_sym] = Hash[*response[index].split(/\W+/)[1..-1]]
      end
      data
    end

    private

    def url
      'http://api.textveloper.com/' 
    end
  end
end
