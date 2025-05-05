class ApplicationController < ActionController::Base
  before_action :set_car, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @car = Car.new
  end

  def create
    @car = Car.new(car_params)
    if @car.save
      flash[:notice] = "Авто успішно створено"
      redirect_to @car
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @car.update(car_params)
      flash[:notice] = "Авто успішно оновлено"
      redirect_to @car
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @car.destroy
    flash[:notice] = "Авто успішно видалено"
    redirect_to cars_path
  end

  private

  def set_car
    @car = Car.find(params[:id])
  end

  def car_params
    params.require(:car).permit(:brand, :model, :year, :price)
  end
end
