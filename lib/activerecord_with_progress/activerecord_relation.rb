require 'active_record'

module ActiverecordWithProgress
  module ActiverecordRelation
    # Adds a progress bar to iterator methods if _with_progress or
    # _and_progress is appended to the method name.  Arguments are passed
    # through to the backing method, with options pulled from the last Hash in
    # the argument list (if any).  If only our own options are specified, the
    # options hash will be deleted from the argument list (so no arguments will
    # be passed to methods that expect no arguments, like #each).
    #
    # Options:
    #   :handle_errors - If true, returns two values: the original result and a
    #                    Hash mapping records to errors.
    #   :total - Override the total count used by the progress bar.
    def method_missing(method, *args)
      name = method.to_s
      if name.end_with?('_with_progress') || name.end_with?('_and_progress')
        name = name.sub(/_(with|and)_progress$/, '')
        iterate_with_progress(name, *args) do |*a|
          yield *a
        end
      else
        super
      end
    end

    private
    # Implements progress bar iteration and error handling.  Calls the given
    # +method+ with the given arguments, incrementing the progress bar each
    # time the method yields.
    def iterate_with_progress(method, *args)
      options = args.reverse.detect{|a| a.is_a?(Hash)} || {}
      total = options.delete(:total) || self.count
      handle_errors = options.delete(:handle_errors)
      args.delete(options) if options.empty?

      progress = ActiverecordWithProgress.create(total: total)

      if handle_errors
        errors = {}

        results = send(method, *args) do |*a|
          progress.increment rescue nil

          begin
            yield *a
          rescue => e
            errors[a[0]] = e
            nil
          end
        end

        [ results, errors ]
      else
        send(method, *args) do |*a|
          progress.increment rescue nil
          yield *a
        end
      end

    ensure
      progress.finish if progress
    end
  end
end

ActiveRecord::Relation.include ActiverecordWithProgress::ActiverecordRelation
