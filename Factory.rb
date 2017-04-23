class Factory
  def self.new(*arguments_name, &block)
    Class.new do
      attr_accessor(*arguments_name)

      instance_eval(&block) if block_given?

      define_method(:initialize) do |*values|
        values.each_with_index { |v, i| send("#{arguments_name[i]}=", v) }
      end

      def [](value)
        if value.is_a?(String) || value.is_a?(Symbol)
          instance_variable_get("@#{value}")
        elsif value.is_a?(Integer)
          instance_variable_get("@#{arguments[value]}")
        end
      end

      define_method(:arguments) do
        arguments_name
      end
    end
  end
end
