require_relative '../github_status_formatter/sentence'

module Pronto
  module Formatter
    class GithubCheckFormatter
      class CheckRunBuilder
        def initialize(runner, messages)
          @runner = runner
          @messages = messages
        end

        def description
          desc = map_description
          desc.empty? ? NO_ISSUES_DESCRIPTION : "Found #{desc}."
        end

        def conclusion
          @messages.empty? ? :success : :failure
        end

        def name
          @runner.title
        end

        def annotations
          @messages.map do |message|
            {
              path: message.path,
              start_line: message.line.position,
              end_line: message.line.position,
              annotation_level: message_state(message.level),
              message: message.msg
            }
          end
        end

        private

        def failure?
          @messages.any? { |message| failure_message?(message) }
        end

        def failure_message?(message)
          message_state(message.level) == :failure
        end

        def message_state(level)
          DEFAULT_LEVEL_TO_STATE_MAPPING[level]
        end

        def map_description
          words = count_issue_types.map do |issue_type, issue_count|
            pluralize(issue_count, issue_type)
          end

          Pronto::Formatter::GithubStatusFormatter::Sentence.new(words).to_s
        end

        def count_issue_types
          counts = @messages.each_with_object(Hash.new(0)) do |message, r|
            r[message.level] += 1
          end
          order_by_severity(counts)
        end

        def order_by_severity(counts)
          Hash[counts.sort_by { |k, _v| Pronto::Message::LEVELS.index(k) }]
        end

        def pluralize(count, word)
          "#{count} #{word}#{count > 1 ? 's' : ''}"
        end

        DEFAULT_LEVEL_TO_STATE_MAPPING = {
          info: :notice,
          warning: :warning,
          error: :failure,
          fatal: :failure
        }.freeze

        NO_ISSUES_DESCRIPTION = 'Coast is clear!'.freeze

        private_constant :DEFAULT_LEVEL_TO_STATE_MAPPING, :NO_ISSUES_DESCRIPTION
      end
    end
  end
end
