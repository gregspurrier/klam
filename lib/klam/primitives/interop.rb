module Klam
  module Primitives
    # Primitives for interoperation with the host Ruby environment.
    # These are not official KLambda primitives.
    module Interop
      def rb_send(obj, method_name, *args)
        obj.send(method_name, *args)
      end
      alias_method :"rb-send", :rb_send
      remove_method :rb_send

      def rb_send_block(obj, method_name, blk, *args)
        if blk.instance_of?(::Symbol)
          # The caller won't take advantage of the currying, but we already
          # are tracking the curried form. This also allows for paritial
          # application of the named function, which could be interesting.
          blk = @curried_methods[blk]
        else
          blk = ::Klam::Primitives::Interop.uncurry(blk)
        end
        obj.send(method_name, *args, &blk)
      end
      alias_method :"rb-send-block", :rb_send_block
      remove_method :rb_send_block

      if RUBY_VERSION < '2.'
        def rb_const(name)
          parts = name.to_s.split('::')
          parts.shift if parts.first.empty?
          parts.reduce(::Module) do |m, x|
            m.const_get(x)
          end
        end
      else
        def rb_const(name)
          ::Module.const_get(name)
        end
      end

      alias_method :"rb-const", :rb_const
      remove_method :rb_const

      class << self
        def uncurry(blk)
          lambda do |*args|
            args.reduce(blk) { |f, x| f.call(x) }
          end
        end
      end
    end
  end
end
