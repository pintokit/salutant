require 'rails_helper'

RSpec.describe "submissions/index", type: :view do
  before(:each) do
    assign(:submissions, [
      Submission.create!(
        :name => "Name",
        :email => "Email",
        :content => ""
      ),
      Submission.create!(
        :name => "Name",
        :email => "Email",
        :content => ""
      )
    ])
  end

  it "renders a list of submissions" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
