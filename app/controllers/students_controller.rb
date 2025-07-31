class StudentsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_student, only: [:edit, :update, :destroy]

  def index
    @students = Student.order(:matric_no).page(params[:page]).per(5)
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(student_params)
    @student.total = @student.ca.to_i + @student.exam.to_i

    if @student.save
      redirect_to students_path, notice: 'Student added successfully.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    @student.assign_attributes(student_params)
    @student.total = @student.ca.to_i + @student.exam.to_i

    if @student.save
      redirect_to students_path, notice: 'Student updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @student.destroy
    redirect_to students_path, notice: 'Student deleted successfully.'
  end

  private

  def set_student
    @student = Student.find(params[:id])
  end

  def student_params
    params.require(:student).permit(:matric_no, :name, :department, :level, :session, :ca, :exam)
  end
end
