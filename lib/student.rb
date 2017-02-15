class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end


  def self.find_by_name(name)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE name = ?
    SQL

    DB[:conn].execute(sql,name).map do |sql_row|
      self.new_from_db(sql_row)
    end.first
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.count_all_students_in_grade_9 #why is this a class?  Because it's calling the entire results
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 9
    SQL
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade < 12
    SQL
    DB[:conn].execute(sql)
  end

  def self.all
    sql = <<-SQL
    SELECT *
    FROM students
    SQL
    students_all = DB[:conn].execute(sql)
    students_all.map do |row_data|
      self.new_from_db(row_data)
    end
  end

  def self.first_x_students_in_grade_10(limit)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10
    LIMIT (?)
    SQL
    DB[:conn].execute(sql, limit)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10
    ORDER BY students.id
    LIMIT 1
    SQL
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_x(grade)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = (?)
    SQL
    DB[:conn].execute(sql,grade)
  end

end
