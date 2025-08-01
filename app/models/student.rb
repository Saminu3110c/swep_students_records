require 'csv'

class Student < ApplicationRecord
  # Scope for filtering
  scope :by_session, ->(session) { where(session: session) if session.present? }
  scope :by_level, ->(level) { where(level: level) if level.present? }

  # Grade method already exists
  def grade
    return '' if total.nil?
    case total
    when 70..100 then 'A'
    when 60..69 then 'B'
    when 50..59 then 'C'
    when 45..49 then 'D'
    when 40..44 then 'E'
    else 'F'
    end
  end

  def passed?
    grade != 'F'
  end

   # Import students from CSV file
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      student_data = row.to_hash.slice('matric_no', 'name', 'department', 'level', 'session', 'ca', 'exam')
      student_data['total'] = student_data['ca'].to_i + student_data['exam'].to_i
      Student.create!(student_data)
    end
  end

  # Export students to CSV
  def self.to_csv
    attributes = %w[matric_no name department level session ca exam total]

    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |student|
        csv << attributes.map { |attr| student.send(attr) }
      end
    end
  end
end
