require 'spec_helper'

describe EffortLog do

  context 'log_effort_week?' do
    it 'should respond to log_effort_week?' do
      EffortLog.should respond_to :log_effort_week?
    end

    it 'it is spring break' do
      EffortLog.log_effort_week?(2010, 9).should == false
      EffortLog.log_effort_week?(2010, 10).should == false
    end

    it 'it is not spring break' do
      (1..8).each do |week_number|
        EffortLog.log_effort_week?(2010, week_number).should == AcademicCalendar.week_during_semester?(2010, week_number)
      end
      (11..52).each do |week_number|
        EffortLog.log_effort_week?(2010, week_number).should == AcademicCalendar.week_during_semester?(2010, week_number)
      end
    end
  end
  
  context "is not valid" do
    [:person, :week_number, :year].each do |attr|
      it "without #{attr}" do
        subject.should_not be_valid
        subject.errors[attr].should_not be_empty
      end
    end    
  end
  
  context "has_permission_to_edit" do
    before(:each) do
      @effort = Factory(:effort_log)
    end
    
    it "for effort log owner" do
      @effort.has_permission_to_edit(@effort.person).should be_true
    end
    
    it "for admin who is not effort owner" do
      admin_andy = Factory(:admin_andy)
      @effort.person.should_not be_equal(admin_andy)
      @effort.has_permission_to_edit(admin_andy).should be_true
    end
    
    it "not for non admin and non effort log owner" do
      faculty_frank = Factory(:faculty_frank)
      @effort.person.should_not be_equal(faculty_frank)
      @effort.has_permission_to_edit(faculty_frank).should be_false
    end
  end
  
  context "has_permission_to_edit_period" do
    before(:each) do
      @effort = Factory(:effort_log)
    end
    
    context "within time period" do
      it "for admin who is not effort owner" do
        admin_andy = Factory(:admin_andy)
        @effort.person.should_not be_equal(admin_andy)
        @effort.has_permission_to_edit_period(admin_andy).should be_true
      end
    
      it "for effort log owner" do
        @effort.has_permission_to_edit_period(@effort.person).should be_true
      end
    
      it "not for non admin and non effort log owner" do
        faculty_frank = Factory(:faculty_frank)
        @effort.person.should_not be_equal(faculty_frank)
        @effort.has_permission_to_edit_period(faculty_frank).should be_false
      end
    end
    
    context "outside of time period" do
      before(:each) do
        tenDaysAgo = Date.today-10
        @effort.year = tenDaysAgo.year
        @effort.week_number = tenDaysAgo.cweek
      end
      
      it "for admin who is not effort owner" do
        admin_andy = Factory(:admin_andy)
        @effort.person.should_not be_equal(admin_andy)
        @effort.has_permission_to_edit(admin_andy).should be_true
      end
          
      it "for effort log owner" do
        @effort.has_permission_to_edit(@effort.person).should be_false
      end
          
      it "not for non admin and non effort log owner" do
        faculty_frank = Factory(:faculty_frank)
        @effort.person.should_not be_equal(faculty_frank)
        @effort.has_permission_to_edit(faculty_frank).should be_false
      end
    end
  end
  
  context "validate_effort_against_registered_courses" do
    before(:each) do
    #  @effort = Factory(:effort_log)
    #  @effort_log_line_item = Factory(:effort_log_line_item, :effort_log => @effort)
    end
    
    it "is signed up for the course" # do
    #       person = @effort.person
    #       courses = [@effort_log_line_item.course]
    #       person.should_receive(:get_registered_courses).and_return(courses)
    #       
    #       @effort.validate_effort_against_registered_courses.should be_equal(courses)
    #     end
    
    it "is not signed up for the course"
  end


end
