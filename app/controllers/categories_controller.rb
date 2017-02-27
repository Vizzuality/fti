# frozen_string_literal: true
class CategoriesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  before_action :set_category, except: [:index, :new, :create]

  def index
    @categories = Category.by_name_asc
  end

  def show; end

  def edit; end

  def new
    @category = Category.new
  end

  def update
    if @category.update(category_params)
      redirect_to categories_url, notice: 'Category succesfully updated.'
    else
      render :edit, notice: @category.errors.full_messages
    end
  end

  def create
    if @category.save(category_params)
      redirect_to categories_url, notice: 'Category succesfully updated.'
    else
      render :new, notice: @category.errors.full_messages
    end
  end

  def destroy
    if @category.destroy
      redirect_to categories_url, notice: 'Category succesfully deleted.'
    else
      redirect_to categories_url, notice: "There was an error and category can't be deleted."
    end
  end

  private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name)
    end

    def menu_highlight
      @menu_highlighted = :admin
    end
end
