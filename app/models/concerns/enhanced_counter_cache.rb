module EnhancedCounterCache
  extend ActiveSupport::Concern

  def include(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def counter_cache_column(name, body)
      unless body.respond_to?(:call)
        raise ArgumentError, "The scope body needs to be callable."
      end

      if dangerous_class_method?(name)
        raise ArgumentError, "You tried to define a scope named \"#{name}\" " \
              "on the model \"#{self.name}\", but Active Record already defined " \
              "a class method with the same name."
      end

      if method_defined_within?(name, ActiveRecord::Relation)
        raise ArgumentError, "You tried to define a scope named \"#{name}\" " \
              "on the model \"#{self.name}\", but ActiveRecord::Relation already defined " \
              "an instance method with the same name."
      end

      valid_scope_name?(name)

      define_method "update_#{name}" do
        send(:"#{name}=", body.call(self))
        save(validate: false)
      end

      singleton_class.define_method "update_#{name}" do
        transaction { all.each(&:"update_#{name}") }
      end
    end

    def resettable_counter_for(*counters)
      counters.each do |counter|
        next unless counter.present?

        class_eval <<-CODE, __FILE__, __LINE__ + 1
          def reset_#{counter}_counter
            send(:reset_counters, :#{counter})
          end
        CODE
      end
    end
  end

  def reset_counters(*counters)
    self.class.reset_counters(id, *counters)
  end
end
