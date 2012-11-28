require 'erb'

module Sig
  class Template
    attr_reader :template_name

    def self.[]( *args , &block )
      new *args , &block
    end

    def initialize( template_name )
      @template_name = template_name
    end

    def filename
      @_filename ||= File.expand_path \
                       File.join(
                         __FILE__,
                         "../templates/#{ template_name }.rb.erb"
                       )
    end

    def read
      @_read = File.read filename
    end

    def result( b )
      b = ( b or binding )
      ERB.new( read ).result b
    end
  end
end
