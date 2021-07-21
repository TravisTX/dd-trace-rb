# typed: true
require 'datadog/ci/contrib/cucumber/formatter'

module Datadog
  module CI
    module Contrib
      module Cucumber
        # Instrumentation for Cucumber
        module Instrumentation
          def self.included(base)
            base.prepend(InstanceMethods)
          end

          # Instance methods for configuration
          module InstanceMethods
            attr_reader :datadog_formatter

            def formatters
              @datadog_formatter ||= Datadog::CI::Contrib::Cucumber::Formatter.new(@configuration)
              [@datadog_formatter] + super
            end
          end
        end
      end
    end
  end
end
