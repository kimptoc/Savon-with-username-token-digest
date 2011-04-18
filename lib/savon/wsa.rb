
require "savon/core_ext/string"
require "savon/core_ext/hash"
require "savon/core_ext/time"

module Savon

  # = Savon::WSA
  #
  # Provides WS-Addressing.
  class WSA

    # Namespace for WS Security Secext.
    WSANamespace = "http://schemas.xmlsoap.org/ws/2004/08/addressing"

    # Returns a value from the WSA Hash.
    def [](key)
      hash[key]
    end

    # Sets a value on the WSA Hash.
    def []=(key, value)
      hash[key] = value
    end

    attr_accessor :action, :message_id, :reply_to, :to

    def ws_addressing?
      action && message_id && reply_to && to
    end

    # Returns the XML for a WSA header.
    def to_xml
      @other_xml ||= Gyoku.xml(hash)

      xml = ""

      if ws_addressing?
        xml += Gyoku.xml wsa_element("Action", action).merge!(hash)
        xml += Gyoku.xml wsa_element("MessageID", message_id).merge!(hash)
        xml += Gyoku.xml wsa_element("ReplyTo", reply_to, "Address").merge!(hash)
        xml += Gyoku.xml wsa_element("To", to).merge!(hash)
      end

      xml + @other_xml
    end

  private

    def wsa_element(tag, value, nested_tag=nil, id=nil)
      id = "#{tag}-#{count}" if id.nil?
      value = {"wsa:"+nested_tag => value } unless nested_tag.nil?
      {
        "wsa:#{tag}" => value,
        :attributes! => { "wsa:#{tag}" => { "wsu:Id" => id} }
      }
    end

    # Returns a new number with every call.
    def count
      @count ||= 0
      @count += 1
    end

    #TODO - are these needed?

    # Returns a memoized and autovivificating Hash.
    def hash
      @hash ||= Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
    end

  end
end
