module Products

    class ProductsAPI < Grape::API

        mount Products::ProductsAPI => '/api/products'

        format :json

        desc "Products List", {
            :notes => <<-NOTE
            Get All Products
            ________________
            NOTE
        }

        get do
            Product.all
        end
        
        desc "Products By Id", {
            :notes => <<-NOTE
            Get Product by Id
            ________________
            NOTE
        }

        
        params do
            require :id, type: integer, desc: "Product Id"
        end

        get ':id' do
            begin
                product = Product.find(params[:id])
            rescue ActiveRecord::RecordNotFound
                error!({status::not_found}, 404)
            end
        end

        desc "Products Delete By Id", {
            :notes => <<-NOTE
            Delete Product by Id
            ________________
            NOTE
        }

        params do
            require :id, type: String, desc: "Product Id"
        end

        delete ':id' do
            begin
                product = Product.find(params[:id])
                {status::success} if product.delete
            rescue ActiveRecord::RecordNotFound
                error!({status::error, message::not_found}, 404)
            end
        end

        desc "Update Product By Id", {
            :notes => <<-NOTE
            Update Product by Id
            ________________
            NOTE
        }

        params do
            require :id, type: integer, desc: "Product Id"
            require :name, type: String, desc: "Product Name",
            require :price, type: BigDecimal, desc: "Product price",
            optional :old_price, type: BigDecimal, desc: "Product old price",
            require :short_description, type: String, desc: "Product Description",
            optional :full_description, type: String, desc: "Product full description"
        end

        put ':id' do
            begin
                product = Product.find(params[:id])
                if product.update({
                    name: params[:name],
                    price: params[:price],
                    old_price: params[:old_price],
                    short_description: params[:short_description],
                })
                
                    {status::success}
                else
                    error!({status::error, message: product.error.full_messages.first}) if product.errors.any?
                end
            rescue ActiveRecord::RecordInvalid
                error!({status::error, message: not_found}, 404)
            end
        end

        desc "Create Product", {
            :notes => <<-NOTE
            Create Product
            __________________   
            NOTE
        }

        params do
            require :id, type: integer, desc: "Product Id"
            require :name, type: String, desc: "Product Name",
            require :price, type: BigDecimal, desc: "Product price",
            optional :old_price, type: BigDecimal, desc: "Product old price",
            require :short_description, type: String, desc: "Product Description",
            optional :full_description, type: String, desc: "Product full description"
        end

        post do
            begin
                product = Product.create({
                    name: params[:name],
                    price: params[:price],
                    old_price: params[:old_price],
                    short_description: params[:short_description],
                })

                if product.save
                    {status::success}
                else
                    error!({status::error, message: product.errors.full_messages.first}) if product.errors.any?
                end

            rescue ActiveRecord::RecordNotFound
                error!({status::error, message::not_found}, 404)
            end
        end
    end
end




