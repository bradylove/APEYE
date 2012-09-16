require 'openssl'
require 'base64'

class Crypto
  attr_accessor :pem_file, :pem, :params, :signature_b64
  
  def initialize(path_to_pem, params)
    @pem_file = path_to_pem
    @pem      = File.read(path_to_pem)
    @signer   = OpenSSL::PKey::RSA.new(@pem)
    @params   = params
    @signature_b64 = sign_and_encode
  end

  def signature_string
    signature_string = ""
    @params.each do |p|
      signature_string += "#{p.key}=#{p.value}" if p.sign?
    end

    puts signature_string
    signature_string
  end

  def sign_and_encode
    Base64.encode64(@signer.sign(OpenSSL::Digest::SHA256.new, signature_string))
  end
end
