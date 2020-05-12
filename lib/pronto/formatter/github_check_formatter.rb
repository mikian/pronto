require_relative 'github_check_run_formatter/check_run_builder'

module Pronto
  module Formatter
    class GithubCheckFormatter
      def format(messages, repo, _)
        client = Github.new(repo)
        head = repo.head_commit_sha

        messages_by_runner = messages.uniq.group_by(&:runner)

        Runner.runners.each do |runner|
          create_check_run(client, head, runner, messages_by_runner[runner] || [])
        end
      end

      private

      def create_check_run(client, sha, runner, messages)
        builder = CheckRunBuilder.new(runner, messages)
        check_run = CheckRun.new(sha, builder.name,
                            builder.conclusion, builder.description,
                            builder.annotations
                            )
        client.publish_check_run(check_run)
      end
    end
  end
end
