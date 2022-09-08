class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.create(products_params)
    if @product.save
      flash[:notice] = "Product created successfully."
      redirect_to root_path
    else
      flash[:error] = "Product not found."
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(products_params)
      flash[:notice] = "Product updated successfully."

      redirect_to root_path
    else
      flash[:error] = "Product not found."
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.delete
      flash[:notice] = "Product deleted successfully."
      redirect_to root_path
    else
      flash[:error] = "Product not found."
      render :destroy
    end
  end


  def products_params
    params.require(:product).permit(:name, :price, :old_price, :short_description, :full_description)
  end
end
