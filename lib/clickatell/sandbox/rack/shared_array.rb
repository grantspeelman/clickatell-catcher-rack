require "yaml/store"

module Clickatell
  module Sandbox
    module Rack
      class SharedArray
        include Enumerable

        def initialize(store_path: '')
          if File.directory?('tmp')
            @store = YAML::Store.new("tmp/clickatell_catcher.yml")
          else
            @store = YAML::Store.new("clickatell_catcher.yml")
          end
          @store.transaction do |store|
            store[:data] ||= []
          end
        end

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
