class SubCategoriesController < ApplicationController
  before_action :authorize_request
  # before_action :set_category, only: [:index, :create]
  # before_action :set_sub_category, only: [:show, :update, :destroy]
  def index
    @sub_categories = SubCategory.all
    render json: @sub_categories
  end

  def show
    render json:@sub_categories
  end

  def create
    # byebug
    @category = Category.find(params[:category_id])
    @sub_category = @category.sub_categories.build(sub_category_params)
    if @sub_category.save
      render json: @sub_category, status: :created
    else
      render json: @sub_category.errors, status: :unprocessable_entity
    end
  end  

  def update
    if @sub_category.update(sub_category_params)
      render json: @sub_category
    else 
      render json: @sub_category.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @sub_category.destroy
    head :no_content
  end

  private

  def sub_category_params
    params.require(:sub_category).permit(:name)
  end
end
