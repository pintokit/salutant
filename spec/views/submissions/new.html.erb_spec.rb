require 'rails_helper'

RSpec.describe "submissions/new", type: :view do
  before(:each) do
    assign(:submission, Submission.new(
      :name => "MyString",
      :email => "MyString",
      :content => ""
    ))
  end

  it "renders new submission form" do
    render

    assert_select "form[action=?][method=?]", submissions_path, "post" do

      assert_select "input#submission_name[name=?]", "submission[name]"

      assert_select "input#submission_email[name=?]", "submission[email]"

      assert_select "input#submission_content[name=?]", "submission[content]"
    end
  end
end
