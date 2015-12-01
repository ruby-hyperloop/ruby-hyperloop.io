require 'opal'
require 'opal/compiler'
require 'browser/interval'
require 'browser/delay'
require 'opal-jquery'
require 'reactive-ruby'

module React
  module Callbacks
    module ClassMethods
      def define_callback(callback_name)
        attribute_name = "_#{callback_name}_callbacks"
        class_attribute(attribute_name)
        self.send("#{attribute_name}=", [])
        define_singleton_method(callback_name) do |*args, &block|
          puts "calling new and improved callbacks"
          callbacks = []
          callbacks.concat(args)
          callbacks.push(block) if block_given?
          self.send("#{attribute_name}=", callbacks)
        end
      end
    end
  end
end
