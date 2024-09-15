class CategoriesController < ApplicationController
  before_action :authorize_request, except: [:index, :show]
  def index
    @categories = Category.all
    render json: @categories
  end

  def show
    @category = Category.find(params[:id])
    # render json: @category
    render json: {user_serializer: CategorySerializer.new(@category)}
  end

  def create
    # debugger
    @category = Category.new(category_params)
    if @category.save
      render json: @category, status: :created
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      render json: @category
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    head :no_content
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
