class Api::V1::EmployeesController < ApplicationController

  def index
    @employees = Employee.all
  end

  def show
    @employee = Employee.find_by(id: params[:id])
    render(json: "Employee is not found", status: 404) unless @employee
  end

  def create
    @employee = Employee.new(employee_params)

    if @employee.save
      render
    else
      render json: {
        message: 'Employee not created',
        errors: @employee.errors.full_messages
      }, status: 422
    end
  end

  def update
    @employee = Employee.find_by(id: params[:id])

    render(json: "Employee is not found", status: 404) and return unless @employee

    if @employee.update_attributes(employee_params)
      render
    else
      render json: {
        message: 'Employee not modified',
        errors: @employee.errors.full_messages
      }, status: 422
    end
  end

  def destroy
    @employee = Employee.find_by(id: params[:id])

    if @employee
      @employee.destroy
      render json: "Employee deleted", status: 200
    else
      render json: "Employee is not found", status: 404
    end
  end

  private

  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :job_title, :email, :office_phone)
  end

end