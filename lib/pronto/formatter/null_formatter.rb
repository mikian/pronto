module Pronto
  module Formatter
    class NullFormatter < Base
      def format(_, _, _); end
    end
  end
end

::Pronto::Formatter.register('null', ::Pronto::Formatter::NullFormatter)
