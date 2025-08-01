class StudentsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_student, only: [:edit, :update, :destroy]

  def index
    @students = Student.all
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

  def results
        @session_filter = params[:session]
        @level_filter = params[:level]

        @students = Student.by_session(@session_filter).by_level(@level_filter)

        @total_students = @students.count
        @passed = @students.select(&:passed?).count
        @failed = @total_students - @passed

        @pass_percentage = @total_students > 0 ? (@passed * 100.0 / @total_students).round(2) : 0
        @fail_percentage = 100 - @pass_percentage
   end

   def import
        if params[:file].present?
            Student.import(params[:file])
            redirect_to students_path, notice: "Students imported successfully."
        else
            redirect_to students_path, alert: "Please upload a CSV file."
        end
    end

    def export
        @students = Student.order(:matric_no)
        respond_to do |format|
            format.html
            format.csv { send_data @students.to_csv, filename: "students-#{Date.today}.csv" }
        end
    end



  private

  def set_student
    @student = Student.find(params[:id])
  end

  def student_params
    params.require(:student).permit(:matric_no, :name, :department, :level, :session, :ca, :exam)
  end
end
