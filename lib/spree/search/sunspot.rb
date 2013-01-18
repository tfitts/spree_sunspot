module Spree
  module Search
    class Sunspot < defined?(Spree::Search::MultiDomain) ? Spree::Search::MultiDomain : Spree::Core::Search::Base
      def retrieve_products
        conf = Spree::Search.configuration

        # send(name) looks in @properties
        @properties[:sunspot] = ::Sunspot.search(Spree::Product) do
          # This is a little tricky to understand
          #     - we are sending the block value as a method
          #     - Spree::Search::Base is using method_missing() to return the param values
          conf.display_facets.each do |name|
            with("#{name}", send(name)) if send(name).present?
            facet("#{name}")
          end

          with(:price, Range.new(price.split('-').first, price.split('-').last)) if price
          facet(:price) do
            conf.price_ranges.each do |range|
              row(range) do
                with(:price, Range.new(range.split('-').first, range.split('-').last))
              end
            end

            # TODO add greater than range
          end

          facet(:taxon_ids)
          with(:taxon_ids, send(:taxon).id) if send(:taxon)

          order_by sort.to_sym, order.to_sym
          with(:is_active, true)
          keywords(query)
          paginate(:page => page, :per_page => per_page)
        end

        self.sunspot.results
      end
      
      def retrieve_themes
        conf = Spree::Search.configuration

        # send(name) looks in @properties
        @properties[:sunspot] = ::Sunspot.search(Spree::Product) do
          # This is a little tricky to understand
          #     - we are sending the block value as a method
          #     - Spree::Search::Base is using method_missing() to return the param values
          conf.display_facets.each do |name|
            with("#{name}", send(name)) if send(name).present?
            facet("#{name}")
          end

          with(:price, Range.new(price.split('-').first, price.split('-').last)) if price
          facet(:price) do
            conf.price_ranges.each do |range|
              row(range) do
                with(:price, Range.new(range.split('-').first, range.split('-').last))
              end
            end

            # TODO add greater than range
          end

          facet(:taxon_ids)
          with(:taxon_ids, send(:taxon).id) if send(:taxon)

          facet :themesort

          #facet :saletype
          #with(:saletype, send(:saletype)) if send(:saletype)
          #with(:featured, true)

          if send(:sort) == :score
            order_by :themesort
            order_by :position
            order_by :subposition
          end

          order_by :themesort
          with(:is_active, true)
          with(:featured, true)
          
          keywords(query)
          paginate(:page => 1, :per_page => 180)
        end

        self.sunspot.results
      end

      protected

      def prepare(params)
        # super copies over :taxon and other variables into properties
        # as well as handles pagination
        super

        # TODO should do some parameter cleaning here: only allow valid search params to be passed through
        # the faceting partial is kind of 'dumb' about the params object: doesn't clean it out and just
        # dumps all the params into the query string

        @properties[:query] = params[:keywords]
        @properties[:price] = params[:price]

        @properties[:sort] = params[:sort] || :score
        @properties[:order] = params[:order] || :desc

        Spree::Search.configuration.display_facets.each do |name|
          @properties[name] ||= params["#{name}"]
        end
      end

    end

  end
end
