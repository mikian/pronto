module Pronto
  module Formatter
    def self.get(names)
      names ||= 'text'
      Array(names).map { |name| formatters[name.to_s] || TextFormatter }
        .uniq.map(&:new)
    end

    def self.names
      formatters.keys
    end

    def self.register(name, klass)
      formatters[name] = klass
    end

    def self.formatters
      @formatters ||= {}
    end
  end
end
