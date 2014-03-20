module Klam
  module Template
    def render_string(template, *args)
      args = join_array_arguments(args)
      segments = segment_string(template)
      segments.map do |segment|
        if segment =~ /^\$(\d+)$/
          args[$1.to_i - 1]
        else
          segment
        end
      end.join
    end

  private

    def join_array_arguments(args)
      args.map do |arg|
        if arg.kind_of?(Array)
          arg.join(',')
        else
          arg
        end
      end
    end
    def segment_string(str)
      segments = []
      pre, placeholder, str = str.partition(/\$\d+/)
      until placeholder.empty? && str.empty?
        segments << pre
        segments << placeholder
        pre, placeholder, str = str.partition(/\$\d+/)
      end
      segments << pre
      segments
    end
  end
end
