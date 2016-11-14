require 'rails_helper'

RSpec.describe "submissions/edit", type: :view do
  before(:each) do
    @submission = assign(:submission, Submission.create!(
      :name => "MyString",
      :email => "MyString",
      :content => ""
    ))
  end

  it "renders the edit submission form" do
    render

    assert_select "form[action=?][method=?]", submission_path(@submission), "post" do

      assert_select "input#submission_name[name=?]", "submission[name]"

      assert_select "input#submission_email[name=?]", "submission[email]"

      assert_select "input#submission_content[name=?]", "submission[content]"
    end
  end
end
