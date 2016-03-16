require "activerecord_with_progress/version"

require 'ruby-progressbar'

module ActiverecordWithProgress
  # Default progress bar format (see ruby-progressbar documentation).
  DEFAULT_FORMAT = "\e[36m%a \e[35m%e\e[0m \e[34m[\e[1m%B\e[0;34m] %c/%C %p%%\e[0m"
  @progress_format = DEFAULT_FORMAT

  class << self
    # Set or retrieve the format string used for progress bars.
    attr_accessor :progress_format

    # Creates a progress bar with our own default options and format, unless
    # overrided by the options hash.  Also works around Spring's removal of
    # IO.console for Rails apps that use Spring by setting :length.
    def create(options=nil)
      opts = {
        format: progress_format,
        length: (IO.console.winsize[1] rescue nil) || ENV['columns'] || `tput cols`
      }
      opts.merge!(options) if options.is_a?(Hash)
      ProgressBar.create(opts)
    end
  end
end

require 'activerecord_with_progress/activerecord_relation'
