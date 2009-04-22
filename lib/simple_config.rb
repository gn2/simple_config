# SimpleConfig
module SimpleConfigHelper

  def self.included(klass)
    klass.class_eval do

      class << self
        def method_missing(method, *args)
          method = (method.to_s =~ /.*=$/) ? method.to_s[0,method.to_s.size-1].to_sym : method.to_sym
          if args.length == 1 then
            @values[method] = args[0]
          else
            @values[method]
          end
        end # method_missing

        def const_missing(name)
          name = name.to_sym
          if !@modules.has_key?(name)
            @modules[name] = Module.new do
              include SimpleConfigHelper
              @values = Hash.new
              @modules = Hash.new
            end
          end
          @modules[name]
        end # const_missing
      end # self

    end # class_eval
  end # self

end # ConfigHelper

# Initialising
module SimpleConfig
  include SimpleConfigHelper
  @values = Hash.new
  @modules = Hash.new
end

# Setting default values
SimpleConfig.site_domain = "http://localhost:3000"
SimpleConfig.site_name = "My App"
SimpleConfig.email_domain = "myapp.com"

# These can be set at the bottom of environment.rb or environment/*.rb etc.
# 
# Sub modules can also be created:
# SimpleConfig::Customers::Account.auto_activation = true