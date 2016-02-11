require 'yaml/store'

module Clickatell
  module Sandbox
    module Rack
      class SharedArray
        include Enumerable

        def initialize
          @store = YAML::Store.new(store_patch)
          @store.transaction do |store|
            store[:data] ||= []
          end
        end

        private

        def store_patch
          if File.directory?('tmp')
            'tmp/clickatell_catcher.yml'
          else
            'clickatell_catcher.yml'
          end
        end

        public

        def clear
          @store.transaction do |store|
            store[:data] = []
          end
        end

        def <<(item)
          @store.transaction do |store|
            store[:data].unshift(item)
            store[:data].pop if store[:data].size > 25
          end
        end

        def each
          data = @store.transaction { @store[:data] }
          data.each do |item|
            yield(item)
          end
        end

        def size
          @store.transaction { @store[:data] }.size
        end
      end
    end
  end
end
